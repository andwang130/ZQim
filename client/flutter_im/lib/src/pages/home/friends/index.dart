import 'package:flutter/material.dart';
import 'package:flutter_im/src/pages/userinfo/index.dart';
import 'package:flutter_im/src/pages/addfriend/index.dart';
import 'package:flutter_im/database/friends.dart';
import 'package:flutter_im/database/user.dart';
import 'package:flutter_im/src/pages/notify/notify.dart';
import 'package:flutter_im/src/pages/addGroup/createGroup.dart';
import 'package:flutter_im/config/config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Friends extends StatefulWidget{

  State<StatefulWidget> createState()=>_Friends();

}
const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";

class _Friends extends State<Friends>{

  List<User> users=List<User>();
  initState(){
    friendsinit();
  }
  friendsinit(){
    Friend.GetFriends().then((values){
      setState(() {
        users=values;
      });
    });
  }
  getfriends()async{
      friendInit();
      friendsinit();


  }

  Widget Title(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(80),left: 20,right: 20,bottom: 0),
      alignment: Alignment.centerLeft,
      height: ScreenUtil.getInstance().setHeight(200),
      color: Colors.blueAccent,
      child: Row(
        children: <Widget>[
          Expanded(child:Text("通信录",style: TextStyle(color: Colors.white,fontSize: ScreenUtil.getInstance().setSp(50)),) ,flex: 6,),
          Expanded(child: Container(
            alignment: Alignment.topRight,
            child: PopupMenuButton(
              onSelected:(String value){
                if(value=="add"){

                  Navigator.push(context, MaterialPageRoute(builder: (_)=>Addfriend()));
                }else if(value=="create"){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateGroup()));
                }
              },
                icon: Icon(Icons.add_circle_outline,),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Text('添加好友'),
                        new Icon(Icons.add_circle)
                      ],
                    ),
                    value: 'add',
                  ),
                  PopupMenuItem(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Text('创建群聊'),
                        new Icon(Icons.add_circle)
                      ],
                    ),
                    value: 'create',
                  ),
                ]
            )
          ),flex: 1,)
        ],
      ),
    );
  }
  Widget friendItem(int uid,String nickname,String headimage){

    return  FlatButton(
      onPressed: (){
        Navigator.push(context,
        MaterialPageRoute(builder: (_)=>UserInfo(uid))
        );
      },
      child:Container(
        height: ScreenUtil.getInstance().setHeight(150),
        child: Row(
          children: <Widget>[

            Expanded(child: Container(
          width: ScreenUtil.getInstance().setWidth(60),
          height: ScreenUtil.getInstance().setHeight(142),
          child:Image.network(headimage!=null?headimage:testImage,fit:BoxFit.fill ,width:ScreenUtil.getInstance().setWidth(25) ,height: ScreenUtil.getInstance().setHeight(42)),

        ), flex: 1,),
          Expanded(
            child:Container(
              padding: EdgeInsets.only(left: 10),
              child: Column(children: <Widget>[
                Expanded(child: Container(
                  alignment:Alignment.centerLeft,
                  child: Text(nickname!=null?nickname:"",style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(45)
                )),)
                ,flex: 3,),

                Expanded(child:
                Container(
                  alignment: Alignment.bottomCenter,
                  child:
                  Divider(color: Colors.grey,),),flex: 1)

              ],)),
              flex: 6,),


          ],
        ),
      ) ,
    );
  }
  Widget notifytiem(){
    return  FlatButton(
      onPressed: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (_)=>Notify())
        );
      },
      child:Container(
        height: ScreenUtil.getInstance().setHeight(150),
        child: Row(
          children: <Widget>[

            Expanded(child: Container(
              width: 25,
              height: 42,
              child:Image.network(testImage,fit:BoxFit.fill ,width:ScreenUtil.getInstance().setWidth(25) ,height: ScreenUtil.getInstance().setHeight(42)),

            ), flex: 1,),
            Expanded(
              child:Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(children: <Widget>[
                    Expanded(child: Container(
                      alignment:Alignment.centerLeft,
                      child: Text("好友通知",style: TextStyle(
                          fontSize: 16
                      )),)
                      ,flex: 3,),

                    Expanded(child:
                    Container(
                      alignment: Alignment.bottomCenter,
                      child:
                      Divider(color: Colors.grey,),),flex: 1)

                  ],)),
              flex: 6,),


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
          notifytiem(),
          SizedBox(height: ScreenUtil.getInstance().setHeight(10),child:
          Container(color: Colors.grey[200],),),
          Flexible(
//              height:ScreenUtil.getInstance().height-1500,
            child:
            RefreshIndicator(child:    ListView.builder(
                itemCount: users.length,
                padding: EdgeInsets.only(top: 0),
                itemBuilder:(context,i){
                  var user=users[i];
                  return this.friendItem(user.uid,user.nickname,user.headimage);
                }

            ) , onRefresh: _handleRefresh)

          )

        ],
      ),


    );
  }
  Future<Null> _handleRefresh() async {
    // 模拟数据的延迟加载
    await this.getfriends();
  }

}