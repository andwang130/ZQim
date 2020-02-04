import 'package:flutter_im/database/dbmange.dart';

class User {
  //用户id
  int uid;
  //昵称
  String nickname;
  //headiamge
  String headimage;
  String useranme;
  static String tabname="user";
  static void inster(int uid,String nickname,String headimage){
    Map<String, dynamic> data=Map<String, dynamic>();
    data["uid"]=uid;
    data["nickname"]=nickname;
    data["headimage"]=headimage;
    SqlManager.inster(tabname,data);
  }
  static  Future<List<User>> GetUsers()async{

    var db= await SqlManager.getCurrentDatabase();
    var data=await db.query(tabname);
    var list=List<User>();
    for(var d in data){
      var user=User();
      print(d);
      user.headimage=d["headimage"];
      user.nickname=d["nickname"];
      user.uid=d["uid"];
      list.add(user);

    }
    return list;

  }
  static Future<bool> isfriend(int uid)async{
    var db= await SqlManager.getCurrentDatabase();
    var data= await db.query(tabname,where:"uid="+uid.toString());
    if (data.length<1){

      return false;
    }else{
      return true;
    }
  }
}