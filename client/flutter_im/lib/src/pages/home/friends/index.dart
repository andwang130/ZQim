import 'package:flutter/material.dart';
import 'package:flutter_im/src/pages/userinfo/index.dart';
import 'package:flutter_im/src/pages/addfriend/index.dart';
import 'package:flutter_im/database/friends.dart';
import 'package:flutter_im/database/user.dart';
import 'package:flutter_im/src/pages/notify/notify.dart';
import 'package:flutter_im/src/pages/addGroup/createGroup.dart';
import 'package:flutter_im/config/config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_im/component/customroute.dart';
import 'package:flutter_im/src/pages/groups/groups.dart';
class Friends extends StatefulWidget{

  State<StatefulWidget> createState()=>_Friends();

}
const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";

class _Friends extends State<Friends>{

  List<Widget> users=List<Widget>();
  initState(){

    friendsinit();
  }
  friendsinit(){
    users.clear();
    users.insert(users.length,notifytiem());
    users.insert(users.length,groupItem());
    users.insert(users.length,SizedBox(height: ScreenUtil.getInstance().setHeight(20),child:
    Container(color: Colors.grey[200],),),);
    Friend.GetFriends().then((values){
      setState(() {
        for(var user in values){
          users.insert(users.length,this.friendItem(user.uid,user.nickname,user.headimage));
        }
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

                  Navigator.push(context, CustomRoute(Addfriend()));
                }else if(value=="create"){
                  Navigator.push(context, CustomRoute(CreateGroup()));
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
            CustomRoute(UserInfo(uid))
        );
      },
      child:Container(
        height: ScreenUtil.getInstance().setHeight(120),
        child: Row(
          children: <Widget>[

            Container(
              width:ScreenUtil.getInstance().setWidth(120) ,
              height: ScreenUtil.getInstance().setHeight(100),
          child:Image.network(headimage!=null?headimage:testImage,fit:BoxFit.fill),

        ),
          Flexible(
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
              ),


          ],
        ),
      ) ,
    );
  }
  Widget notifytiem(){
    return  FlatButton(
      onPressed: (){
        Navigator.push(context,
            CustomRoute(Notify())
        );
      },
      child:Container(
        height: ScreenUtil.getInstance().setHeight(120),
        child: Row(
          children: <Widget>[

             Container(
            width:ScreenUtil.getInstance().setWidth(120) ,
             height: ScreenUtil.getInstance().setHeight(100),
              child:Image.asset("assets/images/friend.png",fit:BoxFit.fill ),

            ),
            Flexible(
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
              ),


          ],
        ),
      ) ,
    );
  }

  Widget groupItem(){
    return  FlatButton(
      onPressed: (){
        Navigator.push(context, CustomRoute(Groups())
        );
      },
      child:Container(
        height: ScreenUtil.getInstance().setHeight(120),
        child: Row(
          children: <Widget>[

           Container(
              width:ScreenUtil.getInstance().setWidth(120) ,
              height: ScreenUtil.getInstance().setHeight(100),
              child:Image.asset("assets/images/group.png",fit:BoxFit.fill ),

            ),
            Flexible(
              child:Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(children: <Widget>[
                    Expanded(child: Container(
                      alignment:Alignment.centerLeft,
                      child: Text("群组",style: TextStyle(
                          fontSize: 16
                      )),)
                      ,flex: 3,),

                    Expanded(child:
                    Container(
                      alignment: Alignment.bottomCenter,
                      child:
                      Divider(color: Colors.grey,),),flex: 1)

                  ],)),
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

          Flexible(
//              height:ScreenUtil.getInstance().height-1500,
            child:
            RefreshIndicator(child:    ListView.builder(
                itemCount: users.length,
                padding: EdgeInsets.only(top: 0),
                itemBuilder:(context,i){
                  var itme=users[i];
                  return itme;
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