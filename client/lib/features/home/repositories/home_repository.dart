import 'dart:io';

import 'package:client/core/constants/server_constant.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  Future<void> uploadSong(
      File selectedImage,
      File selectedAudio
      ) async {
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
        'artist': 'Karan',
        'song_name': 'Sifar Safar',
        'hex_code': 'FFFFFF',
      })
      ..headers.addAll({
        'x-auth-token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImY4OWMyNDM3LTVhYjItNGEwNS04NTEyLWI5ODMxYjQzZWYwNyJ9.8s3mpgMww3SH6LmeXZHooY97DKYJbeC_FkU-BDGOEgo',
      });
    final response = await request.send();
    print(response);
  }
}
