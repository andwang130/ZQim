import 'package:flutter_im/net/networkmanage.dart';
import 'package:flutter_im/proto/message.pb.dart';
import 'package:flutter_im/uitls/eventbus.dart';
import 'package:flutter_im/database/message.dart' as dbmessage;
import 'package:flutter_im/database/dialogue.dart';
enum Type {
  Auth, //认证
  OneMessage,    //单聊消息
  GorupMessage,  //群聊消息
  AckMesage ,    //Ack
  AckManyMessage, //多Ack
  Ping,          //心跳
  PullOneMessage,   //拉取单聊消息
  PullGorupMessage , //拉取群聊消息
  PullNotifie,   //拉取通知
  DeleteManyMesage ,   //离线消息删除多个
  FriendNotife,//添加好友通知消息
  FriendAgree, //同意通知。发起方收到
}
class Handles {

  void route(Message message){


    if (message.ty==Type.Auth.index+1){

      auth(message);

    }
    if (message.ty==Type.OneMessage.index+1){

      oneMessages(message);

    }

    if (message.ty==Type.GorupMessage.index+1){

      gorupMessage(message);
    }

    if(message.ty==Type.PullOneMessage.index+1){

      pullOneMessage(message);
    }
    if (message.ty==Type.PullGorupMessage.index+1){
      pullGorupMessage(message);
    }
    if (message.ty==Type.PullNotifie.index+1){

      pullNotifies(message);

    }


  }

  void auth(Message message){

  }
  void oneMessages(Message message)async{

  var one =OneMessage.fromBuffer(message.body);
  print("收到一条单聊信息");
  bus.emit("message",one);
  var  dia =await Dialogue.checkDialogues(one.sender);
  dbmessage.OneMessage.inster(one.rek.toInt(), one.sender, one.receiver, one.msgtype, one.msgbody, one.time);
  if (dia!=null){
    Dialogue.updateDialogues(one.sender,one.msgbody, one.time.toString(),dia.unread+1);
  }else {
    Dialogue.CreateDialogue(one.sender, one.msgbody, one.time.toString());
  }
 NetWorkManage.getInstance("127.0.0.1", 8080).ack(one.rek);
}
  void gorupMessage(Message message){

  }
  void pullOneMessage(Message message){
    var pullone=PullOneMessages.fromBuffer(message.body);
  }
  void pullGorupMessage(Message message){
    var pullgroup=PullGroupMessages.fromBuffer(message.body);
  }
  void pullNotifies(Message message){
    var pullnotfie=PullNotifieMessage.fromBuffer(message.body);
    print(pullnotfie.toString());
    for (var v in pullnotfie.messages){
      if (v.notifieType==Type.FriendAgree.index+1){
        var agree=Agree.fromBuffer(v.body);
        NetWorkManage.getInstance("127.0.0.1", 8080).pushOneMessage(agree.notife.greet, agree.notife.uid, agree.notife.receiver);
      }

    }
  }
  void friendAgree(Message message){

  }
  void friendNotife(Message message){

  }

}