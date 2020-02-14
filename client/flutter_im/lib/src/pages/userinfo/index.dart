import 'package:flutter/material.dart';
import 'package:flutter_im/uitls/diouitls.dart';
import 'package:flutter_im/database/user.dart';
import 'package:flutter_im/database/friends.dart';
import 'package:flutter_im/src/pages/chat/onechat.dart';
import 'package:flutter_im/component/toast.dart';
import 'package:flutter_im/config/config.dart';
import 'package:flutter_im/database/dialogue.dart';
import 'package:flutter_im/database/message.dart';
import 'package:flutter_im/src/pages/home/index.dart';
import 'package:flutter_im/component/customroute.dart';
class UserInfo extends StatefulWidget{
  int uid;
  UserInfo(this.uid);
  State<StatefulWidget> createState()=>_UserInfo();
}

class _UserInfo extends State<UserInfo>{
  String nickanme="";
  String explain="";
  String headimage="";
  String greet="";
  bool isfirend=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuser();
  }
  
  void getuser()async{

    const String url=WWW+"/user/get";
    var data=await DioUtls.get(url,queryParameters: {"uid":widget.uid});
    if(data.data["code"]==0){
      var d=data.data["data"];
      nickanme=d["nickname"];
      headimage=d["head_image"];
      explain=d["expl"];
      User.updateUser(widget.uid, nickanme, headimage);
      isfirend= await Friend.isfriend(widget.uid);
      setState(() {

      });
    }
    
  }
  
  void Addfriend(String greet)async{

    const String addUrl=WWW+"/friend/add";
    var data=await DioUtls.post(addUrl,data:{"friendid":widget.uid,"greet":greet});
    if(data.data["code"]==0){
      Toast.toast(context, "请求成功");

    }else{
    Toast.toast(context, "已经发送请求");
    }
  }
  void deleteFriend()async{
    var url=WWW+"/friend/delete";
    var data=await DioUtls.post(url,data:{"friendid":widget.uid});
    if(data.data["code"]==0){
     await Friend.deleteFriend(widget.uid);
      await User.deleteuser(widget.uid);
      await Dialogue.deleteUserdDialogue(widget.uid);
      await OneMessage.deleteUserOneMessage(widget.uid, me);
     Navigator.push(context, CustomRoute(Home()));
    }

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            SizedBox(height: 180,),
            ClipOval(child: Image.network(headimage!=null?headimage:testImage,fit:BoxFit.fill,width: 82,height: 82,),),
            SizedBox(height: 20,),
            Text(nickanme!=null?nickanme:"",style: TextStyle(fontSize: 16,color: Colors.deepOrangeAccent),),
            SizedBox(height: 20,),
            Text("说明"),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.only(left: 30,right: 30),
              child:Text(explain!=null?explain:""),
            ),

            SizedBox(height: 20,),
        isfirend==true?
          Column(children: <Widget>[
            RaisedButton(
            color: Colors.greenAccent,
            child:Container(
              decoration: BoxDecoration(borderRadius:BorderRadius.all(Radius.circular(10))),
              alignment: Alignment.center,
              width: 200,
              height: 40,
              child: Text("聊天",style: TextStyle(fontSize: 14,color: Colors.blue),),
            ),onPressed: (){

            Navigator.push(context, MaterialPageRoute(builder: (_)=>OneChat(widget.uid,nickanme)));

          },),
            RaisedButton(
          color: Colors.greenAccent,
          child:Container(
            decoration: BoxDecoration(borderRadius:BorderRadius.all(Radius.circular(10))),
            alignment: Alignment.center,
            width: 200,
            height: 40,
            child: Text("删除好友",style: TextStyle(fontSize: 14,color: Colors.red),),
          ),onPressed: (){


              showDialog(context: context,builder:(BuildContext context){
                return SimpleDialog(
                  title: Text("删除联系人"),

                  children: <Widget>[
                    Center(
                      child: Text('将联系人"${nickanme}"删除'),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[


                          Expanded(
                            child: FlatButton(
                              child: Text('取消'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Expanded(
                            child:  FlatButton(
                              child: Text('确定'),
                              onPressed: () {
                                deleteFriend();
                                Navigator.of(context).pop();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              });

        },)
          ],)

            :RaisedButton(
              color: Colors.greenAccent,
              child:Container(
              decoration: BoxDecoration(borderRadius:BorderRadius.all(Radius.circular(10))),
              alignment: Alignment.center,
              width: 200,
              height: 40,
              child: Text("添加好友",style: TextStyle(fontSize: 14,color: Colors.blue),),
            ),onPressed: (){
              showDialog(context: context,builder:(BuildContext context)
                {

                  return SimpleDialog(title:Text("添加好友"),children: <Widget>[
                   Container(
                    child: TextField(
                      onChanged: (text){
                        greet=text;
                      },
                      decoration: InputDecoration(hintText:"打个招呼"),
                    ),
                     padding: EdgeInsets.only(left: 20),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[


                        Expanded(
                          child: FlatButton(
                            child: Text('取消'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Expanded(
                          child:  FlatButton(
                            child: Text('添加'),
                            onPressed: () {
                              Addfriend(greet);
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                  ),

                  ]);
                }
              );

            },),

          ],
        ),
      )
    );
  }
}