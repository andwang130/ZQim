import 'package:flutter_im/database/dbmange.dart';

class OneMessage{
  int rek;
  int sender;
  int receiver;
  int msgtype;
  int time;
  String body;
  static String table="onemessages";
  static void inster(int rek,int sender,int receiver,int msgtype,String body,int time){

    var data= Map<String, dynamic>();
    data["rek"]=rek;
    data["sender"]=sender;
    data["receiver"]=receiver;
    data["msgtype"]=msgtype;
    data["time"]=time;
    data["body"]=body;
    SqlManager.inster(table,data);

  }
  static Future<List<OneMessage>> GetOneMessage(int sender,receiver,page)async{

    var size=20;
    var list=List<OneMessage>();
    var db= await SqlManager.getCurrentDatabase();
    var sql="select * from ${table}  left join user on user.uid=${table}.sender where(sender=${sender} and receiver=${receiver}) OR (sender=${receiver} and receiver=${sender})  ORDER BY time DESC limit ${size} offset ${(page-1)*size}";

    print(sql);
    var data=await db.rawQuery(sql);

    for(var d in data){
      print(d);
      var one=OneMessage();
      one.sender=d["sender"];
      one.receiver=d["receiver"];
      one.time=d["tiem"];
      one.msgtype=d["msgtype"];
      one.rek=d["rek"];
      one.body=d["body"];
      list.add(one);
    }
    return list;

  }
  static void deleteUserOneMessage(int sender,receiver)async{
    var db= await SqlManager.getCurrentDatabase();
    var args=List<dynamic>();
    args.add(sender);
    args.add(receiver);
   var count=await db.delete(table,where: "sender=? or receiver=?",whereArgs: args);
    print(count);

  }
}