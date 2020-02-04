import 'package:flutter/material.dart';
import 'package:flutter_im/src/pages/chat/index.dart';
import 'package:flutter_im/net/networkmanage.dart';
import 'package:flutter_im/database/dialogue.dart';
class Messages extends StatefulWidget{
  State<StatefulWidget> createState()=>_Messages();

}

const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";
class _Messages extends State<Messages>{

  List<Dialogue> dialogues=List<Dialogue>();
  @override
  initState(){
    Dialogue.GetDialogues(2).then((values){
      setState(() {
        dialogues=values;
      });
    });
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
  Widget meassgeItem(int uid,String nickname,String talk,String ctime,String headimage){


    return  FlatButton(
      onPressed: (){
        Message message=Message();
//        message.ty=2;
//        message.flag=1;
//        message.body=[1,2,3,4,5,6,7];
//        message.len=message.body.length;
//
//        message.ty=1;
        Navigator.push(context,MaterialPageRoute(builder:(_)=> Chat(uid)));
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
                  child:Image.network(headimage!=null?headimage:testImage,fit:BoxFit.fill ,width:62 ,height: 62),

                ),
                  Positioned(
                    child: Container(
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(360)),color: Colors.deepOrange),
                    child: Text("99"),) ,
                    top: -5,
                    right:-5 ,
                  )

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
                print(dia.user.headimage);
                return this.meassgeItem(dia.uid,dia.user.nickname,dia.talkcontent,dia.ctime,dia.user.headimage);
              },
            ) ,
          )

        ],
      ),


    );
  }
}