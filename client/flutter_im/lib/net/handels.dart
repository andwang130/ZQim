import 'package:flutter_im/net/networkmanage.dart';
import 'package:flutter_im/proto/message.pb.dart';
import 'package:flutter_im/uitls/eventbus.dart';
import 'package:flutter_im/database/message.dart' as dbmessage;
import 'package:flutter_im/database/dialogue.dart';
import 'package:flutter_im/database/user.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_im/uitls/notifietion.dart';
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
  static AudioCache player = AudioCache();

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
    if(message.ty==Type.AckMesage.index+1){
    ack(message);
    }


  }

  void auth(Message message){

  }
  void ack(Message message){
    var ackmessage=AckMessage.fromBuffer(message.body);

    if(ackmessage.status==0){
      dbmessage.OneMessage.updateStauts(ackmessage.rek.toInt(),1);
    }else{
      dbmessage.OneMessage.updateStauts(ackmessage.rek.toInt(),2);
    }
    bus.emit("ack",ackmessage);
  }
  void oneMessages(Message message)async{

  var one =OneMessage.fromBuffer(message.body);
  dbmessage.OneMessage.inster(one.rek.toInt(), one.sender, one.receiver, one.msgtype, one.msgbody, one.time,1);
  var  dia =await Dialogue.checkUserDialogues(one.sender);
  var user=await User.GetUser(one.sender);

  Notifications.oneMessageNotification(one.sender, user.nickname,"[${dia==null?1:dia.unread+1}]条 "+ one.msgbody, user.headimage);

  if (dia!=null){
    Dialogue.updateDialogues(one.sender,one.msgbody, one.time.toString(),dia.unread+1);
  }else {
    Dialogue.CreateDialogue(one.sender, one.msgbody, one.time.toString());
  }
  player.play("mp3/4082.mp3");
  bus.emit("message",one);
 NetWorkManage.Instance().ack(one.rek);

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
        var rek=Int64(int.parse(3.toString()+DateTime.now().toLocal().millisecondsSinceEpoch.toString()));
        var time=(DateTime.now().toLocal().millisecondsSinceEpoch/1000).toInt();
        NetWorkManage.getInstance("127.0.0.1", 8080).pushOneMessage(agree.notife.greet, agree.notife.uid, agree.notife.receiver,rek,time);
      }

    }
  }
  void friendAgree(Message message){

  }
  void friendNotife(Message message){

  }

}


