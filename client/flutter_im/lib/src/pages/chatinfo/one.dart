import 'package:flutter/material.dart';
import 'package:flutter_im/component/menuitme.dart';
import 'package:flutter_im/database/message.dart';
import 'package:flutter_im/config/config.dart';
import 'package:flutter_im/uitls/diouitls.dart';
import 'package:flutter_im/database/user.dart';
const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";

class OneChatInfo extends StatefulWidget{
  int  sender;
  OneChatInfo(this.sender);

  State<OneChatInfo> createState()=>_OneChatInfo();

}
class _OneChatInfo extends State<OneChatInfo>{
  String nickanme="";
  String explain="";
  String headimage="";
  String greet="";
  Widget title(){
    return AppBar(
      title: Text("聊天详情",style: TextStyle(color: Colors.black),),

    );
  }

  void getuser()async{
    const String url=WWW+"/user/get";
    var data=await DioUtls.get(url,queryParameters: {"uid":widget.sender});
    if(data.data["code"]==0){
      var d=data.data["data"];
      nickanme=d["nickname"];
      headimage=d["head_image"];
      explain=d["expl"];
      User.updateUser(widget.sender, nickanme, headimage);
      setState(() {

      });
    }

  }

  Widget piepoitem(String headimage,name,int uid){
   return FlatButton(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: 62,
                child: Row(
                  children: <Widget>[
                    ClipOval(child: Image.network(headimage,fit:BoxFit.fill,width: 52,height: 52,),),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(name,style:TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),),),
                      flex: 4,
                    ),

                    Container(

                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_ios),),
                  ],
                )),
            Divider(color: Colors.grey,height: 1,)
          ],
        ),
        onPressed: (){ });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:this.title() ,
      body: Column(
        children: <Widget>[

//          this.userList(15),
        piepoitem(testImage,"王晶",1),
          SizeBoxGrey(20),
//        MenuAare("查看聊天记录", null, (){}),
          MenuAare("清除聊天记录",  Icons.arrow_forward_ios, (){

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
                       OneMessage.deleteUserOneMessage(widget.sender, me);
                      Navigator.of(context).pop();

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
          MenuAare("导出聊天记录", Icons.arrow_forward_ios, (){}),
          SizeBoxGrey(20),
          MenuAare("聊天背景", Icons.arrow_forward_ios, (){}),
          MenuAare("投诉", Icons.arrow_forward_ios, (){}),
        ],
      ),
    );
  }
}
