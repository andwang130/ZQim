import 'package:flutter_im/database/user.dart';
const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";
const WWW="http://192.168.0.106:8080";
class UserCache{
  String nickname;
  String headImge;
}

Map<int,UserCache> Usercache=Map<int,UserCache>();

Future<UserCache> getUserCache(int uid)async{
  var user=Usercache[uid];
  if (Usercache.containsKey(uid)){
    return  Usercache[uid];;
  }else{
   var d= await User.GetUser(uid);
   var user = UserCache();
   user.nickname=d.nickname;
   user.headImge=d.headimage;
   Usercache[uid]=user;
   return user;
  }
}