import 'package:flutter/material.dart';
import 'package:flutter_im/src/pages/chat/component/bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_im/src/pages/chatinfo/index.dart';
import 'package:flutter_im/database/message.dart';
import 'package:flutter_im/database/dialogue.dart';
import 'package:flutter_im/config/config.dart';
import 'package:flutter_im/uitls/eventbus.dart';
import 'package:flutter_im/database/message.dart' as dbmessage;
import 'package:flutter_im/proto/message.pb.dart' as proto;
import 'package:flutter_im/net/networkmanage.dart';
import 'package:fixnum/fixnum.dart';
import 'dart:async';
import 'package:flutter_im/uitls/uitls.dart';
import 'package:flutter_im/src/pages/chat/component/loding.dart';
class Chat extends StatefulWidget{
  List<OneMessage> list=List<OneMessage>();
  Function(String val) handleSubmitted;
  Function getmessage;
  String title;
  Function NavigatorPush;
  Chat(this.list,this.handleSubmitted,this.getmessage,this.title,this.NavigatorPush);
  State<StatefulWidget> createState()=>_Chat();
}
const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";

class _Chat extends State<Chat> with SingleTickerProviderStateMixin {
  TextEditingController _textController=TextEditingController();
  ScrollController _scrollController=ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bus.on("scrojump", scrollController);
    bus.on("ack",ackevent);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textController.dispose();
    _scrollController.dispose();
    bus.off("scrojump", scrollController);
    bus.off("ack",ackevent);

  }
  ackevent(arg) {
    var ackmessag = (arg as proto.AckMessage);

    for (var i = 0; i < widget.list.length; i++) {

      if (widget.list[i].rek == ackmessag.rek.toInt()) {
        print("ack status"+ackmessag.status.toString());
        widget.list[i].status = ackmessag.status == 0 ? 1 : 2;
        if (mounted) {
          setState(() {});
        }
        break;
      }
    }
  }
  scrollController(arg){
    if (mounted) {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }
  _handleSubmitted(String valeu){
    if(valeu!=""){
      widget.handleSubmitted(valeu);
      _textController.text="";
      setState(() {
        scrollController("");
      });
    }
  }
  Widget titleArea(){
    return AppBar(
      centerTitle:true ,
      title: Text(widget.title,style: TextStyle(color: Colors.black),),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.settings,color: Colors.black,),onPressed: (){
        widget.NavigatorPush();
        },)
      ],
    );
  }
  Widget LeftMessageItem(int uid,String message,int time){
    var user= getUserCache(uid);

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
                itemCount: widget.list.length,
                itemBuilder: (context,i){
                  var message=widget.list[i];
                  if (message.sender==me){

                    return this.RightMessageItem(message.body,message.time,message.status);
                  }else{
                    return this.LeftMessageItem(message.sender,message.body,message.time);
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
    await widget.getmessage();
  }

}