
import 'package:flutter/material.dart';
import 'package:fixnum/fixnum.dart';
import 'chat.dart';
import 'package:flutter_im/database/message.dart';
import 'package:flutter_im/component/toast.dart';
import 'package:flutter_im/net/networkmanage.dart';
import 'package:flutter_im/database/dialogue.dart';
import 'package:flutter_im/uitls/eventbus.dart';
import 'package:flutter_im/proto/message.pb.dart' as proto;
import 'package:flutter_im/config/config.dart';
import 'package:flutter_im/src/pages/chatinfo/group.dart';
import 'package:flutter_im/component/customroute.dart';
class GroupChat extends StatefulWidget{
  int gid;
  String titile;
  GroupChat(this.gid,this.titile);
  State<GroupChat> createState()=>_GroupChat();
}

class _GroupChat extends State<GroupChat>{

  int page=1;
  List<OneMessage> list=List<OneMessage>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bus.on("group message",chatcallback);
    bus.on("ack",ackevent);
    Dialogueset();
    this.getmessage();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bus.off("group message",chatcallback);
    bus.off("ack",ackevent);
  }
  getmessage()async{
    var data=await GroupMessage.GetGroupMessage(widget.gid, page);
    list.insertAll(0,data);
    setState(() {
      page++;
    });
  }
  void Dialogueset()async{
    var  dia =await Dialogue.checkGroupDialogues(widget.gid);
    if (dia!=null){
      Dialogue.diagroupZeroing(widget.gid);
      bus.emit("zeroing",widget.gid);
    }else{

      Dialogue.CreateGroupDialogue(widget.gid, "",(DateTime.now().millisecondsSinceEpoch/1000).toInt().toString());
    }
  }
  chatcallback(arg){
    if((arg as proto.GroupMessage).groupid==widget.gid){
      var message= (arg as proto.GroupMessage);
      var one=OneMessage();
      one.sender=message.sender;
      one.body=message.msgbody;
      one.rek=message.rek.toInt();
      one.receiver=widget.gid;
      one.time=message.time;
      one.msgtype=message.msgtype;
      list.add(one);
      if (mounted) {
        setState(() {
//          scrollController();
        });
        bus.emit("zeroing",widget.gid);
        bus.emit("scrojump",widget.gid);



      }
    }

  }
  ackevent(arg) {
    var ackmessag = (arg as proto.AckMessage);
    for (var i = 0; i < list.length; i++) {
      if (list[i].rek == ackmessag.rek) {
        print("ack status"+ackmessag.status.toString());
        list[i].status = ackmessag.status == 0 ? 1 : 2;
        if (mounted) {
          setState(() {});
        }
      }
    }
  }
  _handleSubmitted(String valeu){
    if(!NetStaus){
      Toast.toast(context, "无网络连接");

      return;
    }
    if(valeu!=""){
      var rek=Int64(int.parse(me.toString()+(DateTime.now().toLocal().millisecondsSinceEpoch/10).toInt().toString()));
      var time=(DateTime.now().toLocal().millisecondsSinceEpoch/1000).toInt();
      GroupMessage.createGroupMessage(widget.gid,rek.toInt(),me, 1, valeu, time,0);
      NetWorkManage.Instance().pushGroupMessage(valeu, me, widget.gid,rek);
      var one=OneMessage();
      one.sender=me;
      one.body=valeu;
      one.rek=rek.toInt();
      one.time=time;
      one.receiver=widget.gid;
      one.msgtype=1;
      list.add(one);
      setState(() {
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Chat(list,_handleSubmitted,getmessage,widget.titile,
        (){
          Navigator.push(context, CustomRoute(GroupChatInfo(widget.gid)));
        });
  }
}