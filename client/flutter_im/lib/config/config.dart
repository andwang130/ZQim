import 'package:flutter_im/database/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_im/net/networkmanage.dart';
import 'package:flutter_im/uitls/diouitls.dart';
import 'package:flutter_im/database/friends.dart';
const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";
const WWW="http://192.168.0.106:8080";
var me=0;
var token;
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

void friendInit()async{
  const String url="http://192.168.0.106:8080/friend/list";
  var data=await DioUtls.get(url);
  if (data.data["code"]==0){
    for(var v in  data.data["data"]){
      try {
        Friend.createFriends(v["id"], v["nickname"], v["head_image"]);
      }catch(e){

      }
    }
    }

}
void Init(data)async{
  var  token = data["data"]["token"];
  var  addr = data["data"]["ip"];
  var uid=data["data"]["user"]["ID"];
  print(data);
  print(addr.toString().split(":"));

  var ip=addr.toString().split(":")[0];
  var port=int.parse(addr.toString().split(":")[1]);
  SharedPreferences prefs = await  SharedPreferences.getInstance();
  prefs.setString("token", token);
  prefs.setString("ip", ip);
  prefs.setInt("prot",port);
  prefs.setInt("uid", uid);
  me=uid;
  token=token;
  var workmange=NetWorkManage.getInstance(ip, port);
  await workmange.init();
  workmange.auth(token);

}