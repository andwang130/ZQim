//import 'dart:io';
//
//import 'package:dio/dio.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
//
//import 'package:image_crop/image_crop.dart';
//
//class CropImageRoute extends StatefulWidget {
//  CropImageRoute(this.image);
//
//  File image; //原始图片路径
//
//  @override
//  _CropImageRouteState createState() => new _CropImageRouteState();
//}
//
//class _CropImageRouteState extends State<CropImageRoute> {
//  double baseLeft; //图片左上角的x坐标
//  double baseTop; //图片左上角的y坐标
//  double imageWidth; //图片宽度，缩放后会变化
//  double imageScale = 1; //图片缩放比例
//  Image imageView;
//  final cropKey = GlobalKey<CropState>();
//
//  @override
//  Widget build(BuildContext context) {
//    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
//
//    return Scaffold(
//        body: Container(
//          child: Column(
//            children: <Widget>[
//              Container(
////                height: ScreenUtil.screenHeight*0.8,
//                child: Crop.file(
//                  widget.image,
//                  key: cropKey,
//                  aspectRatio: 1.0,
//                  alwaysShowGrid: true,
//                ),
//              ),
//              RaisedButton(
//                onPressed: () {
//                  _crop(widget.image);
//                },
//                child: Text('ok'),
//              ),
//            ],
//          ),
//        ));
//  }
//
//  Future<void> _crop(File originalFile) async {
//    final crop = cropKey.currentState;
//    final area = crop.area;
//    if (area == null) {
//      //裁剪结果为空
//      print('裁剪不成功');
//    }
//    await ImageCrop.requestPermissions().then((value) {
//      if (value) {
//        ImageCrop.cropImage(
//          file: originalFile,
//          area: crop.area,
//        ).then((value) {
//          upload(value);
//        }).catchError(() {
//          print('裁剪不成功');
//        });
//      } else {
//        upload(originalFile);
//      }
//    });
//  }
//
//  ///上传头像
//  void upload(File file) {
//
//    print(file);
//
//  }
//}
