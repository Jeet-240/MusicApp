import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content){
  ScaffoldMessenger.of(context)
    ..hideCurrentMaterialBanner()
    ..showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
}
 Future<File?> pickAudio() async {
  try{
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio
    );

    if (result != null && result.files.isNotEmpty) {
      final path = result.files.first.xFile.path;
      if (path != null) {
        return File(path);
      }
    }
    else{
      return null;
    }
  } catch (e){
    return null;
  }
}

Future<File?> pickImage() async {
  try{
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image
    );

    if(result != null && result.files.isNotEmpty){
      return File(result.files.first.xFile.path);
    }
    else{
      return null;
    }
  } catch (e){
    return null;
  }
}

Color hexToColor(String hex){
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}
