import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_im/proto/message.pb.dart';
import 'package:flutter_im/net/handels.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_im/config/config.dart';
import 'package:flutter_im/uitls/eventbus.dart';
const int TypeMessage=1;
const int TypeImage=2;

class Message{
  int ty;
  int len;
  int flag=0;
  List<int> body;
  static Message NewMessage(int ty){
    var message=Message();
    message.ty=ty;
    message.len=0;
    message.body=List<int>();
    return message;
  }
}


class NetWorkManage{

  static NetWorkManage _instance;
  Handles handles;
  Timer timer;
  String ip;
  int port;
  Socket socket;
  Timer rTimer;
 Int8List cacheData = Int8List(0);
  NetWorkManage(this.ip,this.port){


    handles=Handles();
  }
  static NetWorkManage getInstance(String ip,int port) {
    if (_instance == null) {
      _instance = NetWorkManage(ip,port);
    }
    return _instance;
  }
  static NetWorkManage Instance(){
    return _instance;
  }
  //重连
  void reload()async{

    await this.init();
    print(token);
    await this.auth(token);
  }
    void init() async{
      rTimer= Timer.periodic(Duration(seconds: 3), (t){


        print(t);
        if(!NetStaus){
          reload();
        }
      });
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
 void ping(){
   timer =Timer.periodic(Duration(seconds: 10),(t){

     send(Message.NewMessage(Type.Ping.index+1));

    });

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
     handles.route(message);

    }
  }
  void onDonehandle(){
    bus.emit("NetStatusChange",null);
    timer.cancel();
    NetStaus=false;
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
  void ack(Int64 rek,int msgtype){
    var ackmesage=AckMessage();
    ackmesage.rek=rek;
    ackmesage.status=0;
    ackmesage.msgtype=msgtype;
    var message=Message();
    message.ty=Type.AckMesage.index+1;
    message.body=ackmesage.writeToBuffer();
    message.len=ackmesage.writeToBuffer().length;
    send(message);
  }
  void ackmany(List<Int64> reks, int msgtype){
    var ackmanymesage=AckManyMesasges();
    ackmanymesage.reks.addAll(reks);
    ackmanymesage.status=0;
    ackmanymesage.msgtype=msgtype;
    var message=Message();
    message.ty=Type.DeleteManyMesage.index+1;
    message.body=ackmanymesage.writeToBuffer();
    message.len=ackmanymesage.writeToBuffer().length;
    send(message);
  }
  void pullOneMessage(){

    send(Message.NewMessage(Type.PullOneMessage.index+1));
  }
  void pullGroupMessage(){

    send(Message.NewMessage(Type.PullGorupMessage.index+1));
  }
  void pullNotifies(){
    send(Message.NewMessage(Type.PullNotifie.index+1));
  }
  void auth(String token){
    AuthMessage auth=AuthMessage();
    auth.token=token;
    Message message=Message();
    message.ty=Type.Auth.index+1;
    message.body=auth.writeToBuffer();
    message.len=auth.writeToBuffer().length;
    send(message);
    ping();
    pullGroupMessage();
    pullOneMessage();
    pullNotifies();
  }
  void pushOneMessage(String msg,int sender,receiver,Int64 rek,int time){
    var one=OneMessage();
    one.rek=rek;
    one.sender=sender;
    one.receiver=receiver;
    one.msgbody=msg;
    one.time=time;
    one.msgtype=TypeMessage;
    var message=Message();
    message.ty=Type.OneMessage.index+1;
    message.body=one.writeToBuffer();
    message.len=one.writeToBuffer().length;
    send(message);
  }
  void pushGroupMessage(String msg,int sender,gid,Int64 rek){

    var group=GroupMessage();
    group.rek=rek;
    group.sender=sender;
    group.msgbody=msg;
    group.msgtype=TypeMessage;
    group.groupid=gid;
    var message=Message();
    message.ty=Type.GorupMessage.index+1;
    message.body=group.writeToBuffer();
    message.len=group.writeToBuffer().length;
    send(message);
  }
  void close(){
    socket.close();
    rTimer.cancel();
  }

}
//NetWorkManage netWorkManage=NetWorkManage.getInstance("192.168.0.106", 8080);
