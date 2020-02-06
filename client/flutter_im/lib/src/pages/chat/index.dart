import 'package:flutter/material.dart';
import 'package:flutter_im/src/pages/chat/component/bubble.dart';
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
class Chat extends StatefulWidget{
  int uid;
  Chat(this.uid);
  State<StatefulWidget> createState()=>_Chat();
}
const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";

class _Chat extends State<Chat> with SingleTickerProviderStateMixin {
  TextEditingController _textController=TextEditingController();
  ScrollController _scrollController=ScrollController();
  int page=1;
  List<OneMessage> list=List<OneMessage>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //键盘弹出事件监听
    bus.on("message",chatcallback);
    bus.on("ack",ackevent);
    Dialogueset();
    this.getmessage();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bus.off("message",chatcallback);
    bus.off("ack",ackevent);
    _textController.dispose();
    _scrollController.dispose();

  }
  ackevent(arg) {
    var ackmessag = (arg as proto.AckMessage);
    for (var i = 0; i < list.length; i++) {
      if (list[i].rek == ackmessag.rek) {
        list[i].status = ackmessag.status == 0 ? 1 : 2;
        if (mounted) {
          setState(() {});
        }
        break;
      }
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

        setState(() {

          scrollController();
        });


      }
    }

  }
  scrollController(){


    _scrollController.animateTo(_scrollController.position.maxScrollExtent+100,duration: Duration(milliseconds: 300),curve: Curves.ease);

  }
  void Dialogueset()async{
    var  dia =await Dialogue.checkDialogues(widget.uid);
    if (dia!=null){
      Dialogue.dialoguesZeroing(widget.uid);
      bus.emit("zeroing",widget.uid);
    }else{

      Dialogue.CreateDialogue(widget.uid, "",DateTime.now().toString());
    }

  }
  void getmessage()async{
    var data=await OneMessage.GetOneMessage(widget.uid, 3, page);
    list.insertAll(0,data);
    setState(() {
      page++;
    });
  }
  Widget titleArea(){
    return AppBar(
      centerTitle:true ,
      title: Text("聊天页面",style: TextStyle(color: Colors.black),),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.settings,color: Colors.black,),onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>Chatinfo(3,widget.uid)));
        },)
      ],
    );
  }
  Widget LeftMessageItem(String message,int time){
    num width=message.length>20?600:message.length*100;
    num height=(message.length/20).ceil()*100;
    return Container(
      padding: EdgeInsets.only(top: 10,left: 10),
      child:Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipOval(child: Image.network(testImage,fit:BoxFit.fill,width: 52,height: 52,),),
              Container(child: BubbleWidget(
                  ScreenUtil().setWidth(width),
                  ScreenUtil().setHeight(height),
                  Colors.white,
                  BubbleArrowDirection.left,child:Text(message,textAlign: TextAlign.start),
                  length: ScreenUtil().setWidth(20)
              ),)
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(UitlsFormatDate(DateTime.fromMillisecondsSinceEpoch(time==null?0:time*1000)),style: TextStyle(color: Colors.grey),),
          )
        ],
      )
    );
  }
  Widget RightMessageItem(String message,int time,int status){
    num width=message.length>20?600:message.length*100;
    num height=(message.length/20).ceil()*100;
    print(width);
    return Container(
        padding: EdgeInsets.only(top: 10,right: 10),
        child:Column(
          children: <Widget>[
            Row(

              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                status==0?Loading():status==1?Container():Icon(Icons.cancel),
                Container(child: BubbleWidget(
                    ScreenUtil().setWidth(width),
                    ScreenUtil().setHeight(height),
                    Colors.blue,
                    BubbleArrowDirection.right,child:Text(message,textAlign: TextAlign.start),
                    length: ScreenUtil().setWidth(20)
                ),),
                ClipOval(child: Image.network(testImage,fit:BoxFit.fill,width: 52,height: 52,),),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(UitlsFormatDate(DateTime.fromMillisecondsSinceEpoch(time==null?0:time*1000)),style: TextStyle(color: Colors.grey),),
            )
          ],
        )
    );
  }
  _handleSubmitted(String valeu){
    if(valeu!=""){
      var rek=Int64(int.parse(3.toString()+DateTime.now().toLocal().millisecondsSinceEpoch.toString()));
      print(rek);
      var time=(DateTime.now().toLocal().millisecondsSinceEpoch/1000).toInt();
      NetWorkManage.Instance().pushOneMessage(valeu, 3, widget.uid,rek,time);
      _textController.text="";
      var one=OneMessage();
      one.sender=3;
      one.body=valeu;
      one.rek=rek.toInt();
      one.time=time;
      one.receiver=widget.uid;
      one.msgtype=1;
      OneMessage.inster(rek.toInt(), 3, widget.uid, 1, valeu, time,0);
      list.add(one);
      setState(() {
        scrollController();
      });
    }
  }

  Widget _buildTextComposer(){
    return new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
            children: <Widget> [
              new Flexible(
                  child: new TextField(
                    controller: _textController,
                    onSubmitted: _handleSubmitted,
                    decoration: new InputDecoration.collapsed(hintText: '发送消息'),
                  )
              ),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(Icons.send,color: Colors.blue,),
                    onPressed: () => _handleSubmitted(_textController.text)
                ),
              )
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    // TODO: implement build
    return Scaffold(
      appBar:this.titleArea() ,
      body:

          Column(
            children: <Widget>[

            Flexible(
          child:RefreshIndicator(child:
          ListView.builder(
            controller: _scrollController,
            itemCount: list.length,
            itemBuilder: (context,i){
              var message=list[i];
              var me=3;
              if (message.sender==me){

                return this.RightMessageItem(message.body,message.time,message.status);
              }else{
                return this.LeftMessageItem(message.body,message.time);
              }
            },

          ) , onRefresh:this._handleRefresh)
           ),


            Container(
              child:_buildTextComposer() ,
            ),
          ],),
      resizeToAvoidBottomPadding: true,


    );
  }
  Future<Null> _handleRefresh() async {
    // 模拟数据的延迟加载
    await this.getmessage();
  }

}

class Loading extends StatefulWidget{
  State<StatefulWidget> createState()=>_Loading();
}
class _Loading extends State<Loading> with SingleTickerProviderStateMixin{

  AnimationController controller;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =AnimationController(duration: const Duration(seconds: 1), vsync: this);
    //动画开始、结束、向前移动或向后移动时会调用StatusListener
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //动画从 controller.forward() 正向执行 结束时会回调此方法
        controller.reset();
        controller.forward();
      } else if (status == AnimationStatus.dismissed) {
        //动画从 controller.reverse() 反向执行 结束时会回调此方法

      } else if (status == AnimationStatus.forward) {

        //执行 controller.forward() 会回调此状态
      } else if (status == AnimationStatus.reverse) {
        //执行 controller.reverse() 会回调此状态

      }
    });
    controller.forward();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      RotationTransition(child:  Icon(Icons.update,color: Colors.lightBlue,),
      turns:controller ,
      );

  }
}