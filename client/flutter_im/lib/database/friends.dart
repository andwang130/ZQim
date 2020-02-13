import 'package:flutter_im/database/dbmange.dart';
import 'user.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
class Friend {
  String id;
  User user;
  static String table="friends";
  static createFriends(int uid,String nickname,String headimage)async{
    Map<String, dynamic> data=Map<String, dynamic>();
    var db=await SqlManager.getCurrentDatabase();
    var content = new Utf8Encoder().convert("user:"+uid.toString());
    var digest = md5.convert(content);
    data["id"]=digest.toString();
    data["uid"]=uid;
    await db.insert(table, data);
    await User.insterUser(uid, nickname, headimage);
  }
  static  Future<List<User>> GetFriends()async{
    var sql="select * from ${table}  left join user on user.id=${table}.id ";
    var db=await SqlManager.getCurrentDatabase();

    var data=await db.rawQuery(sql);
    var list=List<User>();
    for(var d in data){

      var user=User();
      user.headimage=d["headimage"];
      user.nickname=d["nickname"];
      user.uid=d["uid"];
      list.add(user);
    }
    return list;
  }
  static Future<bool> isfriend(int uid)async{
    var db= await SqlManager.getCurrentDatabase();
    var content = new Utf8Encoder().convert("user:"+uid.toString());
    var digest = md5.convert(content);
    var data= await db.query(table,where:"id='${digest.toString()}'");
    if (data.length<1){
      return false;
    }else{
      return true;
    }
  }
  static deleteFriend(int uid )async{
    var db= await SqlManager.getCurrentDatabase();
    var content = new Utf8Encoder().convert("user:"+uid.toString());
    var digest = md5.convert(content);
    var data= await db.delete(table,where:"id='${digest.toString()}'");
  }
}

