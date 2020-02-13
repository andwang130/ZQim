import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_im/component/customroute.dart';
import 'package:flutter_im/database/user.dart';
import 'package:flutter_im/config/config.dart';
import 'package:flutter_im/src/pages/chat/grouochat.dart';
class Groups extends StatefulWidget{
  State<Groups> createState()=>_Groups();
}
class _Groups extends State<Groups>{

  List<Widget> users=List<Widget>();

  @override
  initState(){

    super.initState();
    groupsinit();
  }
  groupsinit(){
    User.GetGroups().then((values){

      for(var user in values){
        users.insert(users.length,this.friendItem(user.uid,user.nickname,user.headimage));
      }
      setState(() {

      });
    });
  }


  Widget Title(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(80),left: 20,right: 20,bottom: 0),
      alignment: Alignment.centerLeft,
      height: ScreenUtil.getInstance().setHeight(200),
      color: Colors.blueAccent,

      child: Text("所有群组",style: TextStyle(color: Colors.white,fontSize: ScreenUtil.getInstance().setSp(50)),),


      );

  }
  Widget friendItem(int uid,String nickname,String headimage){

    return  FlatButton(
      onPressed: (){
        Navigator.push(context,
            CustomRoute(GroupChat(uid,nickname))
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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("群组"),),
      body: Container(child:  ListView.builder(
          itemCount: users.length,
          itemBuilder:(context,i){
            var itme=users[i];
            print(itme.toString());
            return itme;
          }

      ),),
    );
  }
  Future<Null> _handleRefresh() async {
    // 模拟数据的延迟加载

  }
}