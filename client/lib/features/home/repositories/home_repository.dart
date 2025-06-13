import 'dart:io';
import 'dart:ui';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref){
  return HomeRepository();
}
class HomeRepository {
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
}
