import 'package:flutter_im/database/dbmange.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
class User {
  String id;
  //用户id
  int uid;
  //昵称
  String nickname;
  //headiamge
  String headimage;
  String useranme;
  int utype;
  static String tabname="user";
  static void insterUser(int uid,String nickname,String headimage){
    Map<String, dynamic> data=Map<String, dynamic>();
    var content = new Utf8Encoder().convert("user:"+uid.toString());
    var digest = md5.convert(content);
    data["id"]=digest.toString();
    data["uid"]=uid;
    data["nickname"]=nickname;
    data["headimage"]=headimage;
    data["utype"]=1;
    SqlManager.inster(tabname,data);
  }
  static void insterGroup(int gid,String nickname,String headimage){
    Map<String, dynamic> data=Map<String, dynamic>();
    var content = new Utf8Encoder().convert("group:"+gid.toString());
    var digest = md5.convert(content);
    data["id"]=digest.toString();
    data["uid"]=gid;
    data["nickname"]=nickname;
    data["headimage"]=headimage;
    data["utype"]=2;
    SqlManager.inster(tabname,data);
  }
  static  Future<List<User>> GetUsers()async{

    var db= await SqlManager.getCurrentDatabase();
    var data=await db.query(tabname,where: "utype=1");
    var list=List<User>();
    for(var d in data){
      print(d);
      var user=User();
      user.headimage=d["headimage"];
      user.nickname=d["nickname"];
      user.uid=d["uid"];
      list.add(user);

    }
    return list;
  }
  static Future<User> GetUser(int uid)async{
    var db= await SqlManager.getCurrentDatabase();
    var content = new Utf8Encoder().convert("user:"+uid.toString());
    var digest = md5.convert(content);
    var data=await db.query(tabname,where: "id="+digest.toString());
    var user=User();
    user.headimage=data.first["headimage"];
    user.nickname=data.first["nickname"];
    user.uid=data.first["uid"];
    return user;
  }
  static Future<User> GetGroup(int gid)async{
    var db= await SqlManager.getCurrentDatabase();
    var content = new Utf8Encoder().convert("group:"+gid.toString());
    var digest = md5.convert(content);
    var data= await db.query(tabname,where:"id='${digest.toString()}'");
    var user=User();
    user.headimage=data.first["headimage"];
    user.nickname=data.first["nickname"];
    user.uid=data.first["uid"];
    return user;
  }
  static Future<bool> isfriend(int uid)async{
    var db= await SqlManager.getCurrentDatabase();
    var content = new Utf8Encoder().convert("user:"+uid.toString());
    var digest = md5.convert(content);
    var data= await db.query(tabname,where:"id='${digest.toString()}'");
    if (data.length<1){
      return false;
    }else{
      return true;
    }
  }
}