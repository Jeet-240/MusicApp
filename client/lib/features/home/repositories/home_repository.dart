import 'dart:convert';
import 'dart:io';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref){
  return HomeRepository();
}
class HomeRepository{
  Future<Either<AppFailure, String>> uploadSong({
    required File selectedAudio,
    required File selectedImage,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try{
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstant.serverURL}/song/upload'),
      );
      request
        ..files.addAll([
          await http.MultipartFile.fromPath(
              'song',
              selectedAudio.path
          ),
          await http.MultipartFile.fromPath(
              'thumbnail',
              selectedImage.path
          ),
        ])
        ..fields.addAll({
          'artist': artist,
          'song_name': songName,
          'hex_code': hexCode,
        })
        ..headers.addAll({
          'x-auth-token': token
        });
      final response = await request.send();
      if(response.statusCode != 201){
        return Left(AppFailure(await response.stream.bytesToString()));
      }

      return Right(await response.stream.bytesToString());

    }catch(e){
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>>getAllSongs() async{
      try{
        final request = await http.get(
              Uri.parse('${ServerConstant.serverURL}/song/list'),
          headers: {'Content-Type': 'application/json'},
        );
        if(request.statusCode == 200){
          final List<dynamic> jsonList = jsonDecode(request.body);
          final List<SongModel> songs = jsonList.map((song) => SongModel.fromMap(song as Map<String, dynamic>)).toList();
          return Right(songs);
        }else{
          final requestMap = jsonDecode(request.body) as Map<String, dynamic>;
          return Left(AppFailure(requestMap['detail']));
        }

      }
      catch(e){
        return Left(AppFailure(e.toString()));
      }
  }

}
