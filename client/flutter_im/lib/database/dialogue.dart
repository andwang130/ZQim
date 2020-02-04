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
   data["unread"]=1;
   SqlManager.inster(tabname,data);

 }
 static  Future<List<Dialogue>> GetDialogues(int page)async{
   List<Dialogue>  list=List<Dialogue>();
   var db=await SqlManager.getCurrentDatabase();
   var sql="select * from dialogue left join user on user.uid=dialogue.uid limit 100 offset 1";

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
}
