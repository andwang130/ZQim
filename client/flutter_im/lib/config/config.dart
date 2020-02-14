import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_im/database/dbmange.dart';
import 'package:flutter_im/database/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_im/net/networkmanage.dart';
import 'package:flutter_im/uitls/diouitls.dart';
import 'package:flutter_im/database/friends.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
const OssUrl="https://xkws.oss-cn-hangzhou.aliyuncs.com/";
const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";
const WWW="http://Mychat.carzy.wang";
bool isLogin=false;
bool NetStaus=false;
var MyHeadimage="";
var me=0;
var token;
class UserCache{
  String nickname;
  String headImge;
}

Map<int,UserCache> Usercaches=Map<int,UserCache>();

SetUsercache(int uid,String nickname, String headimage){

  var usercache=UserCache();
  usercache.nickname=nickname;
  usercache.headImge=headimage;
  Usercaches[uid]=usercache;
}
Future<UserCache> getUserCache(int uid)async{
  var user=Usercaches[uid];
  if (Usercaches.containsKey(uid)){
    return  Usercaches[uid];;
  }else{
    var d= await User.GetUser(uid);
    var user = UserCache();
    if(user!=null) {
      user.nickname = d.nickname;
      user.headImge = d.headimage;
      Usercaches[uid] = user;
      return user;
    }
  }
}

void friendInit()async{
  const String url=WWW+"/friend/list";
  var data=await DioUtls.get(url);
  if (data.data["code"]==0){
    for(var v in  data.data["data"]){
      try {
        await Friend.createFriends(v["id"], v["nickname"], v["head_image"]);
      }catch(e){

      }
    }
    }

}
void Init(data)async{
  var  _token = data["data"]["token"];
  var  addr = data["data"]["ip"];
  var uid=data["data"]["user"]["ID"];
  var headimage=data["data"]["user"]["head_image"];
  var ip=addr.toString().split(":")[0];
  var port=int.parse(addr.toString().split(":")[1]);
  SharedPreferences prefs = await  SharedPreferences.getInstance();
  prefs.setString("token", _token);
  prefs.setString("ip", ip);
  prefs.setInt("prot",port);
  prefs.setInt("uid", uid);

  me=uid;
  token=_token;
  MyHeadimage=headimage;
  await SqlManager.init();
  await friendInit();
 var users= await User.GetUsers();
  for(var u in users){
    var user = UserCache();
      user.nickname = u.nickname;
      user.headImge = u.headimage;
      Usercaches[uid] = user;
  }
  var workmange=NetWorkManage.getInstance(ip, port);
  await workmange.init();
  workmange.auth(token);
  isLogin=true;

}
getcurrent()async{
  var url=WWW+"/getcurrent";
  var data=await DioUtls.get(url);
  return data.data;
}
Future<String> UploadImage(File file)async{
  var res=await getcurrent();
  var url=res["host"];
  print(url);
  String filename = Uuid().v4()+"."+basename(file.path).split(".").last;
  var formdata=FormData.fromMap({
    "key":res["dir"]+filename,
    "OSSAccessKeyId":res["accessid"],
   "policy":res["policy"],
   "Signature":res["signature"],
   "success_action_status":200,
   "file": await  MultipartFile.fromFile(file.path)
 });
  print(file.lengthSync());


    var data = await DioUtls.post(url, data: formdata);
    if (data.statusCode==200){
      return OssUrl+filename;
    }else{
      return "";
    }



}