import 'package:flutter_im/net/networkmanage.dart';
import 'package:flutter_im/proto/message.pb.dart';
import 'package:flutter_im/uitls/eventbus.dart';
import 'package:flutter_im/database/message.dart' as dbmessage;
import 'package:flutter_im/database/dialogue.dart';
import 'package:flutter_im/database/user.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_im/uitls/notifietion.dart';
import 'package:flutter_im/uitls/diouitls.dart';
import 'package:flutter_im/database/friends.dart';
import 'package:flutter_im/config/config.dart';

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
    if(message.ty==Type.FriendAgree.index+1){
      friendAgree(message);
    }


  }

  void auth(Message message){

  }
  void ack(Message message){
    var ackmessage=AckMessage.fromBuffer(message.body);

    if(ackmessage.status==0){
      if(ackmessage.msgtype==Type.OneMessage.index+1) {
        dbmessage.OneMessage.updateStauts(ackmessage.rek.toInt(), 1);
      }else{
        dbmessage.GroupMessage.updateStauts(ackmessage.rek.toInt(), 1);
      }
    }else{
      if(ackmessage.msgtype==Type.OneMessage.index+1) {
        dbmessage.OneMessage.updateStauts(ackmessage.rek.toInt(), 2);
      }else{
        dbmessage.GroupMessage.updateStauts(ackmessage.rek.toInt(), 2);
      }
    }
    bus.emit("ack",ackmessage);
  }
  void oneMessages(Message message)async{

  var one =OneMessage.fromBuffer(message.body);

  dbmessage.OneMessage.inster(one.rek.toInt(), one.sender, one.receiver, one.msgtype, one.msgbody, one.time,1);
  var  dia =await Dialogue.checkUserDialogues(one.sender);
  var user=await User.GetUser(one.sender);
  if(user==null){
    user=await getuser(one.sender);
    User.insterUser(user.uid, user.nickname, user.headimage);
  }
  Notifications.oneMessageNotification(one.sender, user.nickname,"[${dia==null?1:dia.unread+1}]条 "+ one.msgbody, user.headimage);

  if (dia!=null){
    Dialogue.updateUserDialogues(one.sender,one.msgbody, one.time.toString(),dia.unread+1);
  }else {
    Dialogue.CreateDialogue(one.sender, one.msgbody, one.time.toString());
  }
  player.play("mp3/4082.mp3");
  bus.emit("message",one);
 NetWorkManage.Instance().ack(one.rek);

}
  void gorupMessage(Message message)async{
    var group=GroupMessage.fromBuffer(message.body);
    dbmessage.GroupMessage.createGroupMessage(group.groupid,group.rek.toInt(),group.sender,group.msgtype,group.msgbody,group.time,1);
    var diagroup=await Dialogue.checkGroupDialogues(group.groupid);
    var user=await User.GetUser(group.sender);
    if(user==null){
      user=await getuser(group.sender);
      User.insterUser(user.uid, user.nickname, user.headimage);
    }
    var groupUser=await User.GetGroup(group.groupid);
    if(groupUser==null){
      groupUser=await getGropChat(group.groupid);
      User.insterGroup(groupUser.uid, groupUser.nickname, groupUser.headimage);
    }
    Notifications.oneMessageNotification(group.sender, groupUser.nickname,"${user.nickname}"+ group.msgbody, groupUser.headimage);

    if (diagroup!=null){
      Dialogue.updateGrouoDialogues(group.groupid,"${user.nickname}"+group.msgbody, group.time.toString(),diagroup.unread+1);
    }else {
      Dialogue.CreateGroupDialogue(group.groupid,"${user.nickname}"+group.msgbody, group.time.toString());
    }
    player.play("mp3/4082.mp3");
    bus.emit("group message",group);
    NetWorkManage.Instance().ack(group.rek);
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
        var rek=Int64(int.parse(me.toString()+(DateTime.now().toLocal().millisecondsSinceEpoch/10).toInt().toString()));
        var time=(DateTime.now().toLocal().millisecondsSinceEpoch/1000).toInt();
        NetWorkManage.Instance().pushOneMessage(agree.notife.greet, agree.notife.uid, agree.notife.receiver,rek,time);
      }

    }
  }
  void friendAgree(Message message)async{
    var agree=Agree.fromBuffer(message.body);
    var user =await getuser(agree.notife.receiver);
    User.insterUser(user.uid, user.nickname, user.headimage);
    Friend.createFriends(user.uid, user.nickname, user.headimage);
    var time=(DateTime.now().toLocal().millisecondsSinceEpoch/1000).toInt();
    var rek=Int64(int.parse(me.toString()+(DateTime.now().toLocal().millisecondsSinceEpoch/10).toInt().toString()));

    Dialogue.CreateDialogue(user.uid ,agree.notife.greet,time.toString());
    dbmessage.OneMessage.inster(rek.toInt(), me, agree.notife.receiver, 1, agree.notife.greet, time, 1);
    NetWorkManage.Instance().pushOneMessage(agree.notife.greet, agree.notife.uid, agree.notife.receiver,rek,time);
    var one=OneMessage();
    one.rek=rek;
    one.sender=me;
    one.receiver=agree.notife.receiver;
    one.msgbody=agree.notife.greet;
    one.time=time;
    one.msgtype=TypeMessage;
    bus.emit("message",one);
  }
  void friendNotife(Message message){

  }

}


Future<User> getuser(int uid)async{
  const String url="http://192.168.0.106:8080/user/get";
  var data=await DioUtls.get(url,queryParameters: {"uid":uid});
  if(data.data["code"]==0){
    var d=data.data["data"];
    var user=User();
    user.uid=d["ID"];
    user.nickname=d["nickname"];
    user.headimage=d["head_image"];
    return user;
  }
  return null;


}
Future<User> getGropChat(int gid)async{
  const String url="http://192.168.0.106:8080/group/get";
  var data=await DioUtls.get(url,queryParameters: {"id":gid});
  if(data.data["code"]==0){
    var d=data.data["data"];
    var user=User();
    user.uid=d["ID"];
    user.nickname=d["group_name"];
    user.headimage=d["avatar"];
    return user;
  }
  return null;
}