import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_im/proto/message.pb.dart';
enum Type {
  Auth, //认证
OneMessage, //单聊消息
GorupMessage, //群聊消息
AckMesage,//Ack
AckManyMessage,//多Ack
Ping, //心跳
PullOneMessage, //拉取单聊消息
PullGorupMessage, //拉取群聊消息
DeleteManyMesage, //离线消息删除多个
FriendNotice, //添加好友通知消息
FriendAgree, //同意通知。发起方收到
}

class Message{
  int ty;
  int len;
  int flag=0;
  List<int> body;
}


class NetWorkManage{

  static NetWorkManage _instance;
  String ip;
  int port;
 Socket socket;
 Int8List cacheData = Int8List(0);
  NetWorkManage(this.ip,this.port){

  }
  static NetWorkManage getInstance(String ip,int port) {
    if (_instance == null) {
      _instance = NetWorkManage(ip,port);
    }
    return _instance;
  }

  //重连
  void reload(String ip,int prot){
    this.ip=ip;
    this.port=port;
    this.init();
  }
    void init() async{
    socket= await Socket.connect(this.ip, this.port);
    print(socket.address.address);
    this.socket=socket;
    socket.listen(
        this.decodehandle,
      onDone:onDonehandle,
      onError: onErrorhanle,
        cancelOnError:false
    );

  }

  void decodehandle(data){

    cacheData=Int8List.fromList(cacheData+data);

    while(cacheData.length>=7){
     Message message=Message();
     var bytes=cacheData.buffer.asByteData();
     message.ty=bytes.getUint16(0);
     message.len=bytes.getUint32(2);
     if (message.len+7>cacheData.length){
       return ;

     }
     message.flag=bytes.getUint8(6);
     message.body=cacheData.sublist(7,message.len+7);
     cacheData=cacheData.sublist(7+message.len,cacheData.length);
     print(message.body);

    }
  }
  void onDonehandle(){
    print("断开连接");
  }
  void onErrorhanle(error, StackTrace trace){

  }
  void send(Message message){

    Int8List data=Int8List(7+message.len);
    ByteData bytes=ByteData(7);
    bytes.setUint16(0, message.ty);
    bytes.setUint32(2, message.len);
    bytes.setInt8(6, message.flag);
    data=Int8List.fromList(bytes.buffer.asInt8List()+message.body);
    socket.add(data.buffer.asInt8List());
  }
  void auth(String token){
    AuthMessage auth=AuthMessage();
    auth.token=token;
    Message message=Message();
    message.ty=Type.Auth.index+1;
    message.body=auth.writeToBuffer();
    message.len=auth.writeToBuffer().length;
    this.send(message);

  }
}
//NetWorkManage netWorkManage=NetWorkManage.getInstance("192.168.0.106", 8080);
