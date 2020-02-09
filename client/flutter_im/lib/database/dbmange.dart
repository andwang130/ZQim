import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlManager{

  static const _VERSION=1;

  static const _NAME="chat.db";

  static Database _database;


  ///初始化
  static init() async {
    var databasesPath=await getDatabasesPath();

    String path = join(databasesPath, _NAME);

    _database=await openDatabase(path,version: _VERSION,onCreate: (Database db,int version) async{
    var dialoguesql="create table dialogue(id text primary key,uid integer,talkcontent text not null,ctime text not null,unread integer not null,dtype integer not null)";
     await db.execute(dialoguesql);
     var usersql="create table user(id text primary key,uid integer,nickname text not null,headimage text not null,utype integer not null)";
    await db.execute(usersql);
    var onemessagesql="create table onemessages(rek integer primary key,sender integer,receiver integer,msgtype integer,body text,time integer,status integer not null)";
    await db.execute(onemessagesql);
    var friendsSql="create table friends(id text primary key,uid integer)";
    await db.execute(friendsSql);
    var groupmessagsql="create table groupmessage(rek integer primary key,sender integer,gid integer,msgtype integer,body text,time integer,status integer not null)";
    await db.execute(groupmessagsql);
    });

  }

  ///判断表是否存在
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res=await _database.rawQuery("select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res!=null && res.length >0;
  }

  static createTable(sql)async{
  
   await _database.execute(sql);

  }
  ///获取当前数据库对象
  static Future<Database> getCurrentDatabase() async {
    if(_database == null){
      await init();
    }
    return _database;
  }
  static inster(String table , Map<String, dynamic> values)async{
    var db=await getCurrentDatabase();
   var data= await db.insert(table,values);

  }



  ///关闭
  static close() {
    _database?.close();
    _database = null;
  }
}