import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_im/src/pages/chatinfo/index.dart';
import 'package:flutter_im/database/message.dart';
import 'package:flutter_im/database/dialogue.dart';
import 'package:flutter_im/uitls/eventbus.dart';
import 'package:flutter_im/database/message.dart' as dbmessage;
import 'package:flutter_im/proto/message.pb.dart' as proto;
import 'package:flutter_im/net/networkmanage.dart';
import 'package:fixnum/fixnum.dart';
import 'dart:async';
import 'package:flutter_im/uitls/uitls.dart';
import 'package:flutter_im/src/pages/chat/component/loding.dart';
import 'package:flutter_im/config/config.dart';
import 'chat.dart';
class OneChat extends StatefulWidget{
  int uid;
  OneChat(this.uid);
  State<OneChat> createState()=>_OneChat();


}
class _OneChat extends State<OneChat> {
  int page=1;
  List<OneMessage> list=List<OneMessage>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     Dialogueset();
    bus.on("message",chatcallback);
    bus.on("ack",ackevent);
    this.getmessage();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bus.off("message",chatcallback);
    bus.off("ack",ackevent);

  }
  void Dialogueset()async{

    var  dia =await Dialogue.checkUserDialogues(widget.uid);

    print(dia==null);
    if (dia!=null){
      await Dialogue.dialoguesZeroing(widget.uid);
      bus.emit("zeroing",widget.uid);
    }else{
      print("init");
     await Dialogue.CreateDialogue(widget.uid, "",DateTime.now().toString());
    }
  }
  chatcallback(arg){
    if((arg as proto.OneMessage).sender==widget.uid){
      var message= (arg as proto.OneMessage);
      var one=OneMessage();
      one.sender=message.sender;
      one.body=message.msgbody;
      one.rek=message.rek.toInt();
      one.receiver=message.receiver;
      one.time=message.time;
      one.msgtype=message.msgtype;
      list.add(one);
      if (mounted) {
        bus.emit("zeroing",widget.uid);
        bus.emit("scrojump",widget.uid);
        setState(() {
//          scrollController();
        });


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
  void getmessage()async{
    var data=await OneMessage.GetOneMessage(widget.uid, me, page);
    list.insertAll(0,data);
    setState(() {
      page++;
    });
  }
  _handleSubmitted(String valeu){
    if(valeu!=""){
      var rek=Int64(int.parse(me.toString()+(DateTime.now().toLocal().millisecondsSinceEpoch/10).toInt().toString()));
      var time=(DateTime.now().toLocal().millisecondsSinceEpoch/1000).toInt();
      OneMessage.inster(rek.toInt(), me, widget.uid, 1, valeu, time,0);
      NetWorkManage.Instance().pushOneMessage(valeu, me, widget.uid,rek,time);
      var one=OneMessage();
      print(rek.toString());
      one.sender=me;
      one.body=valeu;
      one.rek=rek.toInt();
      one.time=time;
      one.receiver=widget.uid;
      one.msgtype=1;
      list.add(one);
      setState(() {

      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Chat(list,_handleSubmitted,this.getmessage,"单聊",(){
      Navigator.push(context, MaterialPageRoute(builder: (_)=>Chatinfo(me,widget.uid)));
    });
  }

}