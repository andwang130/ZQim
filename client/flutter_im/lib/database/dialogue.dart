import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_im/database/dbmange.dart';
import 'package:flutter_im/database/user.dart';
class Dialogue{
 int uid;
 String talkcontent;
 String ctime;
 int unread;
 User user;
 static String tabname="dialogue";
 static void CreateDialogue(int uid,String talk,String ctime){

   Map<String, dynamic> data=Map<String, dynamic>();
   data["uid"]=uid;
   data["talkcontent"]=talk;
   data["ctime"]=ctime;
   data["unread"]=0;

   SqlManager.inster(tabname,data);

 }
 static  Future<List<Dialogue>> GetDialogues()async{
   List<Dialogue>  list=List<Dialogue>();
   var db=await SqlManager.getCurrentDatabase();
   var sql="select * from dialogue left join user on user.uid=dialogue.uid";
   var row =await db.rawQuery(sql);
   for (var r in row){
     Dialogue dia=Dialogue();
     dia.uid=r["uid"];
     dia.ctime=r["ctime"];
     dia.talkcontent=r["talkcontent"];
     dia.unread=r["unread"];
     dia.user=new User();
     dia.user.nickname=r["nickname"];
     dia.user.headimage=r["headimage"];
     list.add(dia);
   }
   return list;

 }
 static dialoguesZeroing(int uid)async{
   var db=await SqlManager.getCurrentDatabase();
   db.update(tabname,{"unread":0},where:"uid="+uid.toString());
 }

 static Future<Dialogue> checkDialogues(int uid )async{
   print(uid);
   var db=await SqlManager.getCurrentDatabase();
  var data=await db.query(tabname,where:"uid="+uid.toString());
  if (data.length>0){
    var r=data.first;
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
 static updateDialogues(int uid,String talk,String ctime,int unread )async{
   var db=await SqlManager.getCurrentDatabase();

   db.update(tabname, {"talkcontent":talk,"ctime":ctime,"unread":unread},where:"uid="+uid.toString());

 }

}
