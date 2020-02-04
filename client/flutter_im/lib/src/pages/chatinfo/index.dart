import 'package:flutter/material.dart';
import 'package:flutter_im/component/menuitme.dart';
import 'package:flutter_im/database/message.dart';
class Chatinfo extends StatefulWidget{
  int  receiver,sender;
  Chatinfo(this.sender,this.receiver);
  State<StatefulWidget> createState()=>_Chatinfo();

}
const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";

class _Chatinfo extends State<Chatinfo>{
  Widget title(){
    return AppBar(
      backgroundColor: Colors.white,
      title: Text("聊天信息(6)",style: TextStyle(color: Colors.black),),

    );
  }
Widget userList(int count ){
    double hight=count/5*83;
    return    Container(
      height: hight,
      child: GridView.count(
        crossAxisCount: 5,
        children: <Widget>[
          this.piepoitem(),
          this.piepoitem(),
          this.piepoitem(),
          this.piepoitem(),
          this.piepoitem(),
          this.piepoitem(),
          this.piepoitem(),
          this.piepoitem(),
          this.piepoitem(),
          this.piepoitem(),
          this.piepoitem(),
          this.piepoitem(),
          this.piepoitem(),
          this.piepoitem(),
          this.piepoitem(),
        ],),
    );
}
Widget piepoitem(){

    return Container(
      child:Column(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(testImage,fit:BoxFit.fill,width: 60,height: 60,)
          ),
          Text("用户名称")


        ],
      ),
    );
}
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:this.title() ,
      body: Column(
        children: <Widget>[
          SizedBox(height: 20,),
        this.userList(15),
        SizeBoxGrey(20),
//        MenuAare("查看聊天记录", null, (){}),
        MenuAare("清除聊天记录", null, (){

          showDialog(context: context,builder: (BuildContext context){
            return AlertDialog(
              title: Text("删除确认"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("取消")
                ),
                RaisedButton(
                  onPressed: () {
                    OneMessage.deleteUserOneMessage(widget.sender, widget.receiver);

                  },
                  child: Text(
                    "确定",
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                ),
              ],
            );
          });
        }),
        SizeBoxGrey(20),
        MenuAare("投诉", null, (){}),
        SizeBoxGrey(20),
        ],
      ),
    );
  }
}