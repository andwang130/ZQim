import 'package:flutter/material.dart';
import 'package:flutter_im/component/menuitme.dart';
import 'package:flutter_im/database/message.dart';
import 'package:flutter_im/config/config.dart';
import 'package:flutter_im/uitls/diouitls.dart';
import 'package:flutter_im/src/pages/addGroup/Invitation.dart';
import 'package:flutter_im/src/pages/addGroup/delmembers.dart';
class GroupChatInfo extends StatefulWidget{
  int  gid;

  GroupChatInfo(this.gid);
  State<GroupChatInfo> createState()=>_GroupChatInfo();

}
const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";

class _GroupChatInfo extends State<GroupChatInfo>{

  String groupname;
  String notice;
  int owner;
  List<Widget> list= List<Widget>();
  @override
  initState(){
    super.initState();
    getgroupinfo();



  }
  getmembers()async{
    var url=WWW+"/group/members";
    var data=await DioUtls.get(url,queryParameters: {"id":widget.gid,"page":1});
    if(data.data["code"]==0){
     var datas=data.data["data"];
      for(var d in datas){
        list.insert(list.length,piepoitem(d["head_image"], d["nickname"], d["ID"]));
      }
     list.insert(list.length,addItem());
      print(owner);
      if(owner==me){
        list.insert(list.length,reduceItem());
      }
      setState(() {

      });

    }else{
      print(data.data);
    }
  }
  getgroupinfo()async{
    var url=WWW+"/group/get";
    var data=await DioUtls.get(url,queryParameters: {"id":widget.gid});
    if(data.data["code"]==0){
    var d=data.data["data"];
      owner=d["owner"];
      groupname=d["group_name"];
      notice=d["notice"];
    }
   await getmembers();
  }

  Widget title(){
    return AppBar(
      title: Text("聊天信息(6)",style: TextStyle(color: Colors.black),),

    );
  }
  Widget userList(int count ){
    double hight=count/5*130;
    return    Container(
      height: hight,
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 20,
            crossAxisSpacing: 0,
//              childAspectRatio: 1,
          ),
        itemCount: list.length,
         itemBuilder:(contex,index){
          var item=list[index];
          return item;

      }
    ),
    );

  }
  Widget piepoitem(String head_image,name,int uid){
    return Container(
      child:Column(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(head_image==""?testImage:head_image,fit:BoxFit.fill,width: 56,height: 52,)
          ),
          Text(name)


        ],
      ),
    );
  }

  Widget reduceItem(){
    return    FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>DeleteMembers(widget.gid)));
        }, child:   Container(
      child:Column(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset("assets/images/reduce.png",fit:BoxFit.fill,width: 56,height: 52,)
          ),
        ],
      ),
    ));
  }
  Widget addItem(){

    return
    FlatButton(
    padding: EdgeInsets.all(0),
    onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (_)=>Invitation(widget.gid)));
    }, child:   Container(
      child:Column(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset("assets/images/add.png",fit:BoxFit.fill,width: 56,height: 52,)
          ),
        ],
      ),
    ));
    
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:this.title() ,
      body: Column(
        children: <Widget>[
          SizedBox(height: 20,),
          this.userList(list.length),
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
//                      OneMessage.deleteUserOneMessage(widget.sender, widget.receiver);

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