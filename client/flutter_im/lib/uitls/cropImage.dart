import 'dart:io';
import 'package:flutter_im/config/config.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
Future<String> cropImage(File originalImage) async {
  print('裁剪');

  File croppedFile = await ImageCropper.cropImage(
      sourcePath: originalImage.path,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio5x4,
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: '编辑图片',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ));

  if (croppedFile != null) {

    var filename=await UploadImage(croppedFile);
    return filename;

  }
  return "";

}