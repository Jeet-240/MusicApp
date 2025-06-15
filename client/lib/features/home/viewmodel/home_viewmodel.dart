import 'dart:io';
import 'dart:ui';
import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../song_model.dart';
part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(Ref ref) async{
  final res = await ref.watch(homeRepositoryProvider).getAllSongs();

  final val = switch(res){
    Left(value : final l) => throw l.message,
    Right(value : final r) => r,
  };

  return val;
}



@riverpod
class HomeViewModel extends _$HomeViewModel{
  late HomeRepository _homeRepository ;
  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedImage,
    required String songName,
    required String artist,
    required Color selectedColor,
})async {
    state = const AsyncLoading();
    final response = await _homeRepository.uploadSong(selectedAudio: selectedAudio, selectedImage: selectedImage, songName: songName, artist: artist, hexCode: selectedColor.hex, token: ref.read(currentUserNotifierProvider)!.token);
    final val = switch(response){
      Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncData(r),
    };
  }



}