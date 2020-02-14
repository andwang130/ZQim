import 'package:flutter/material.dart';
import 'package:flutter_im/src/pages/chat/onechat.dart';
import 'package:flutter_im/src/pages/chat/grouochat.dart';
import 'package:flutter_im/net/networkmanage.dart';
import 'package:flutter_im/database/dialogue.dart';
import 'package:flutter_im/uitls/eventbus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_im/proto/message.pb.dart';
import 'package:flutter_im/component/customroute.dart';
import 'package:flutter_im/uitls/uitls.dart';
import 'package:flutter_im/config/config.dart';
class Messages extends StatefulWidget{
  State<StatefulWidget> createState()=>_Messages();

}

const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";
class _Messages extends State<Messages>{

  List<Dialogue> dialogues=List<Dialogue>();
  @override
  initState(){
    bus.on("NetStatusChange",(arg){
      if (mounted) {
        Dialogue.GetDialogues().then((values){
          setState(() {
            dialogues=values;
          });
        });
      }
    });
    bus.on("message", messagecallback);
    bus.on("group message",groupmessagecallback);
    bus.on("zeroing", (arg){
      var id=(arg as int);
      for(var i=0;i<dialogues.length;i++){
        if(dialogues[i].uid==(arg as int)){
          if(dialogues[i].dtype==1) {
            Dialogue.dialoguesZeroing(id);
          }else{
            Dialogue.diagroupZeroing(id);
          }
          if (mounted) {
            Dialogue.GetDialogues().then((values){
              setState(() {
                dialogues=values;
              });
            });
          }
          break;
        }
      }
    });
    Dialogue.GetDialogues().then((values){
      setState(() {
        dialogues=values;
      });
    });

  }

  groupmessagecallback(arg){
    var message=(arg as GroupMessage);
    if (mounted) {
      Dialogue.GetDialogues().then((values){
        setState(() {
          dialogues=values;
        });
      });

  }
  }
  messagecallback(arg){
    var message=(arg as OneMessage);
    if (mounted) {
      Dialogue.GetDialogues().then((values){
        setState(() {
          dialogues=values;
        });
      });
    }


  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //取消监听
    bus.off("message",messagecallback);
    bus.off("group message",groupmessagecallback);
    bus.off("zeroing");
    bus.off("NetStatusChange");
  }
  Widget Title(){
    return Container(
      padding: EdgeInsets.only(top: 30,left: 20,right: 20,bottom: 0),
      height: ScreenUtil.getInstance().setHeight(200),
      color: Colors.blueAccent,
      child: Row(
        children: <Widget>[
          Text("消息(${dialogues.length})",style: TextStyle(color: Colors.white,fontSize: 16),)
        ],
      ),
    );
  }
  Widget meassgeItem(int uid,String nickname,String talk,String ctime,String headimage,int unread,int dtype){

    var time=0;
    try{
      time=int.parse(ctime);
    }catch(e){

    }

    return  FlatButton(
      onLongPress: (){},
      onPressed: (){
        if(dtype==1){
          Navigator.push(context,CustomRoute( OneChat(uid,nickname)));
        }else{
          Navigator.push(context,CustomRoute(GroupChat(uid,nickname)));

        }
      },
      child:Container(
        height: ScreenUtil.getInstance().setHeight(160),
        child: Row(
          children: <Widget>[

            Expanded(child:

              Stack(
                  overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    width: ScreenUtil.getInstance().setWidth(122),
                    height: ScreenUtil.getInstance().setHeight(100),
//                    child: Image.network(testImage,fit:BoxFit.fill ,width:62 ,height: 62),
                  child:Image.network(headimage!=null?headimage:testImage,fit:BoxFit.fill ,width:ScreenUtil.getInstance().setWidth(62),height: ScreenUtil.getInstance().setHeight(62)),

                ),
                  unread!=0?Positioned(
                    child: Container(
                    width: ScreenUtil.getInstance().setWidth(50),
                    height: ScreenUtil.getInstance().setHeight(50),
                    alignment: Alignment.center,
                    decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(360)),color: Colors.deepOrange),
                    child: Text(unread.toString()),) ,
                    top: -5,
                    right:-5 ,
                  ):Positioned(child: Container(width: 0,height: 0,),)

                ],
              )
              ,flex: 1,),
            Expanded(
              child:Container(
                padding: EdgeInsets.only(top: 10,left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Row(children: <Widget>[
                      Expanded(
                        child: Text(nickname,style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(45)

                        ),),flex: 3,),
                      Expanded(child: Text(UitlsFormatDate(DateTime.fromMillisecondsSinceEpoch(time*1000)),style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(30),color: Colors.grey
                      ),) ,flex: 2,),
                    ],),

                    SizedBox(height: 5,),
                    Text(talk,style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(35),color: Colors.grey
                    ),)
                  ],),
              ),
              flex: 6,
            ),
           Container(
             alignment: Alignment.center,
             width:ScreenUtil.getInstance().setWidth(80) ,
             child:  PopupMenuButton(
               onSelected: (value){
                 if(value=="delete"){
                   if(dtype==1){
                     Dialogue.deleteUserdDialogue(uid);

                   }else{
                     Dialogue.deleteGroupdDialogue(uid);
                   }
                   Dialogue.GetDialogues().then((values){
                     setState(() {
                       dialogues=values;
                     });
                   });
                 }
               },
                 itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                   PopupMenuItem(
                     child: new Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: <Widget>[
                         new Text('删除'),

                       ],
                     ),
                     value: 'delete',
                   ),

                 ]),
           )

          ],
        ),
      ) ,
    );
  }
  Widget NetErrorItem(){

    return Container(
      color: Colors.pink[100],
      padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(100)),
      height: ScreenUtil.getInstance().setHeight(100),
      child:Row(
        children: <Widget>[
          Icon(Icons.error,color: Colors.red,),
          Text("网络连接不可用"),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(

        children: <Widget>[
          Title(),
        NetStaus==false?NetErrorItem():Container(height: 1,),
          Flexible(
            child:  ListView.builder(
              itemCount:dialogues.length,
              padding: EdgeInsets.only(top: 0),
              itemBuilder:(context,i){
                var dia=dialogues[i];
                return this.meassgeItem(dia.uid,dia.user.nickname,dia.talkcontent,dia.ctime,dia.user.headimage,dia.unread,dia.dtype);
              },
            ) ,
          )

        ],
      ),


    );
  }
}