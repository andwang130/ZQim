import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DioUtls {

  static  GetDio()async{

    SharedPreferences prefs = await  SharedPreferences.getInstance();
    var token=prefs.get("token");
    var dio=await Dio();
    dio.options.headers={"token":token};
    return dio;
  }
  static  post( String path, {
  data,
  Map<String, dynamic> queryParameters,
  Options options,
  CancelToken cancelToken,
  ProgressCallback onSendProgress,
  ProgressCallback onReceiveProgress}) async{

   var dio=await GetDio();
   var req= await dio.post(path,data:data,queryParameters: queryParameters,cancelToken: cancelToken,options: options
    ,onReceiveProgress: onReceiveProgress,onSendProgress: onSendProgress
    );

   return req;
  }
  static get( String path, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  })async{
    var dio=await GetDio();
    var req=await dio.get(path,queryParameters: queryParameters,options: options,cancelToken: cancelToken,onReceiveProgress: onReceiveProgress);

    return req;
  }
}