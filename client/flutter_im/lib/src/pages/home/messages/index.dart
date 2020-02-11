import 'package:flutter/material.dart';
import 'package:flutter_im/src/pages/chat/onechat.dart';
import 'package:flutter_im/src/pages/chat/grouochat.dart';
import 'package:flutter_im/net/networkmanage.dart';
import 'package:flutter_im/database/dialogue.dart';
import 'package:flutter_im/uitls/eventbus.dart';
import 'package:flutter_im/proto/message.pb.dart';
class Messages extends StatefulWidget{
  State<StatefulWidget> createState()=>_Messages();

}

const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";
class _Messages extends State<Messages>{

  List<Dialogue> dialogues=List<Dialogue>();
  @override
  initState(){
    bus.on("message", messagecallback);
    bus.on("group message",groupmessagecallback);
    bus.on("zeroing", (arg){
      for(var i=0;i<dialogues.length;i++){
        if(dialogues[i].uid==(arg as int)){
          dialogues[i].unread=0;
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
    for(var i=0;i<dialogues.length;i++){
      if(dialogues[i].uid==message.groupid&&dialogues[i].dtype==2){
        dialogues[i].unread=dialogues[i].unread+1;
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

  }
  messagecallback(arg){
    var message=(arg as OneMessage);
    for(var i=0;i<dialogues.length;i++){
      if(dialogues[i].uid==message.sender){
        dialogues[i].unread=dialogues[i].unread+1;
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


  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //取消监听
    bus.off("message",messagecallback);
    bus.off("group message",groupmessagecallback);
    bus.off("zeroing");
  }
  Widget Title(){
    return Container(
      padding: EdgeInsets.only(top: 30,left: 20,right: 20,bottom: 0),
      height: 60,
      color: Colors.blueAccent,
      child: Row(
        children: <Widget>[
          Text("消息(10)",style: TextStyle(color: Colors.white,fontSize: 16),)
        ],
      ),
    );
  }
  Widget meassgeItem(int uid,String nickname,String talk,String ctime,String headimage,int unread,int dtype){

    return  FlatButton(
      onPressed: (){
        if(dtype==1){
          Navigator.push(context,MaterialPageRoute(builder:(_)=> OneChat(uid)));
        }else{
          Navigator.push(context,MaterialPageRoute(builder:(_)=> GroupChat(uid)));

        }

      },
      child:Container(
        height: 76,
        child: Row(
          children: <Widget>[

            Expanded(child:

              Stack(
                  overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    width: 62,
                    height: 62,
//                    child: Image.network(testImage,fit:BoxFit.fill ,width:62 ,height: 62),
                  child:Image.network(headimage!=null?headimage:testImage,fit:BoxFit.fill ,width:62 ,height: 62),

                ),
                  unread!=0?Positioned(
                    child: Container(
                    width: 18,
                    height: 18,
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
                            fontSize: 16

                        ),),flex: 2,),
                      Expanded(child: Text(ctime,style: TextStyle(
                          fontSize: 12,color: Colors.grey
                      ),) ,flex: 1,),
                    ],),

                    SizedBox(height: 10,),
                    Text(talk,style: TextStyle(
                        fontSize: 12,color: Colors.grey
                    ),)
                  ],),
              ),
              flex: 5,
            ),
            

          ],
        ),
      ) ,
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(

        children: <Widget>[
          Title(),
          Container(
            height:MediaQuery.of(context).size.height-120,

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