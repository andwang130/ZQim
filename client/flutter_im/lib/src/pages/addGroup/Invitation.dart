import 'package:flutter/material.dart';
import 'package:flutter_im/config/config.dart';
import 'package:flutter_im/database/user.dart';
import 'package:flutter_im/uitls/diouitls.dart';
import 'package:flutter_im/component/toast.dart';
import 'package:flutter_im/database/dialogue.dart';
import 'package:flutter_im/src/pages/chat/grouochat.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Invitation extends StatefulWidget {
  int gid;
  Invitation(this.gid);
  State<Invitation> createState() => _Invitation();
}

class _Invitation extends State<Invitation> {

  var members=List<int>();
  var users=List<User>();
  var checklist=List<int>();
  @override
  initState(){
    super.initState();
    allmeembers();
    friendsinit();
  }


  friendsinit(){
    User.GetUsers().then((values){
      setState(() {
        users=values;
      });
    });
  }
  bool inside(int uid){
    for(var v in members){
      if(v==uid){
        return true;
      }
    }
    return false;
  }
  allmeembers()async{
    var url=WWW+"/group/allmembers";
    var data=await DioUtls.get(url,queryParameters: {"id":widget.gid});
    if(data.data["code"]==0){
      print(data.data["data"]);
      for(var d in data.data["data"]){
        members.add(d);
      }
      setState(() {

      });
    }
  }
  bool ischeck(int uid){
    for(var i in checklist){
      if(i==uid){
        return true;
      }
    }
    return false;
  }

  Widget chckefriendsItem(){

    return
      Container(
          color: Colors.grey[100],
          child:  ListView.builder(
              itemCount: users.length,

              itemBuilder: (contex, i) {
                var user=users[i];
                var isde=inside(user.uid);
                return Container(
                  height: ScreenUtil.getInstance().setHeight(160),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child:
                        Container(child:  Checkbox(
                          value:isde==true?true:ischeck(user.uid),
                          checkColor: isde==true?Colors.grey:Colors.white,

                          onChanged:isde==true?null: (val){
                            if(val){
                              checklist.add(user.uid);
                            }else{
                              checklist.remove(user.uid);
                            }
                            setState(() {

                            });
                          },
                        ), ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          width: ScreenUtil.getInstance().setWidth(45),
                          height: ScreenUtil.getInstance().setHeight(140),
                          child: Image.network(user.headimage,
                              fit: BoxFit.fill, width: ScreenUtil.getInstance().setWidth(45), height: ScreenUtil.getInstance().setHeight(140)),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(user.nickname, style: TextStyle(fontSize: 16)),
                                  ),
                                  flex: 3,
                                ),
                                Expanded(
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      child: Divider(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    flex: 1)
                              ],
                            )),
                        flex: 6,
                      ),
                    ],
                  ),
                );
              }));
  }
  Submit()async{

      try{
        var url=WWW+"/group/invitation";
        var data= await DioUtls.post(url,data:{"id":widget.gid,"members":checklist});
        if(data.data["code"]==0){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>GroupChat(widget.gid)));
        }else{
          Toast.toast(context, data.data["msg"]);
        }
      }catch(e){
        Toast.toast(context, "网络错误");
      }

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("选择联系人"),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: FlatButton(
                disabledColor: Colors.grey,
                color: Colors.orange,
                onPressed: checklist.length>0?Submit:null,
                child: Text("确定(${checklist.length})",
                ),
              ) ,
            )
          ],
        ),
        body: Container(
            child:Column(
              children: <Widget>[
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(80),
                  child: Container(
                    padding:  EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    color: Colors.grey[200],
                    child: Text("选择好友",style: TextStyle(fontSize: 15,color: Colors.grey),),
                  ),),
                Flexible(child:   chckefriendsItem(),)


              ],
            )
        )
    );
  }
}
