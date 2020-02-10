import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_im/database/dbmange.dart';
import 'package:flutter_im/database/user.dart';
class Dialogue{
  String id;
 int uid;
 String talkcontent;
 String ctime;
 int unread;
 User user;
 int dtype;
 static String tabname="dialogue";
 static void CreateDialogue(int uid,String talk,String ctime)async{
   print("inin");
   Map<String, dynamic> data=Map<String, dynamic>();

   var content = new Utf8Encoder().convert("user:"+uid.toString());
   var digest = md5.convert(content);
   data["id"]=digest.toString();
   data["uid"]=uid;
   data["talkcontent"]=talk;
   data["ctime"]=ctime;
   data["unread"]=0;
   data["dtype"]=1;
   SqlManager.inster(tabname,data);


 }
 static void CreateGroupDialogue(int gid,String talk,String ctime){
   Map<String, dynamic> data=Map<String, dynamic>();
   var content = new Utf8Encoder().convert("group:"+gid.toString());
   var digest = md5.convert(content);
   data["id"]=digest.toString();
   data["uid"]=gid;
   data["talkcontent"]=talk;
   data["ctime"]=ctime;
   data["unread"]=0;
   data["dtype"]=2;
   SqlManager.inster(tabname,data);
 }
 static  Future<List<Dialogue>> GetDialogues()async{
   List<Dialogue>  list=List<Dialogue>();
   var db=await SqlManager.getCurrentDatabase();

   var sql="select * from dialogue left join user on user.id=dialogue.id";
   var row =await db.rawQuery(sql);
   print(row.length);
   for (var r in row){

     print(row);
     Dialogue dia=Dialogue();
     dia.id=r["id"];
     dia.uid=r["uid"];
     dia.ctime=r["ctime"];
     dia.talkcontent=r["talkcontent"];
     dia.unread=r["unread"];
     dia.dtype=r["dtype"];
     dia.user=new User();
     dia.user.nickname=r["nickname"];
     dia.user.headimage=r["headimage"];
     list.add(dia);
   }
   return list;

 }
 static dialoguesZeroing(int uid)async{
   var db=await SqlManager.getCurrentDatabase();
   var content = new Utf8Encoder().convert("user:"+uid.toString());
   var digest = md5.convert(content);

   db.update(tabname,{"unread":0},where:"id='${digest.toString()}'");
 }
 static diagroupZeroing(int gid)async{
   var db=await SqlManager.getCurrentDatabase();
   var content = new Utf8Encoder().convert("group:"+gid.toString());
   var digest = md5.convert(content);

   db.update(tabname,{"unread":0},where:"id='${digest.toString()}'");
 }

 static Future<Dialogue> checkUserDialogues(int uid)async{
   print(uid);
   var db=await SqlManager.getCurrentDatabase();
   var content = new Utf8Encoder().convert("user:"+uid.toString());
   var digest = md5.convert(content);
  var data=await db.query(tabname,where:"id='${digest.toString()}'");
  if (data.length>0){
    var r=data.first;
    print(r);
    Dialogue dia=Dialogue();
    dia.uid=r["uid"];
    dia.ctime=r["ctime"];
    dia.talkcontent=r["talkcontent"];
    dia.unread=r["unread"];
    return dia;
  }else{
    return null;
  }

 }
 static Future<Dialogue> checkGroupDialogues(int gid)async{
   var db=await SqlManager.getCurrentDatabase();
   var content = new Utf8Encoder().convert("group:"+gid.toString());
   var digest = md5.convert(content);
   var data=await db.query(tabname,where:"id='${digest.toString()}'");
   if (data.length>0){
     var r=data.first;
     Dialogue dia=Dialogue();
     dia.uid=r["uid"];
     dia.ctime=r["ctime"];
     dia.talkcontent=r["talkcontent"];
     dia.unread=r["unread"];
     dia.dtype=r["dtype"];
     return dia;
   }else{
     return null;
   }

 }
 static updateUserDialogues(int uid,String talk,String ctime,int unread )async{
   var db=await SqlManager.getCurrentDatabase();
   var content = new Utf8Encoder().convert("user:" + uid.toString());
   var digest = md5.convert(content);
   db.update(tabname, {"talkcontent":talk,"ctime":ctime,"unread":unread},where:"id='${digest.toString()}'");

 }
static updateGrouoDialogues(int gid,String talk,String ctime,int unread) async{
  var content = new Utf8Encoder().convert("group:" + gid.toString());
  var digest = md5.convert(content);
  var db=await SqlManager.getCurrentDatabase();
  db.update(tabname, {"talkcontent": talk, "ctime": ctime, "unread": unread}, where:"id='${digest.toString()}'");
}
}
