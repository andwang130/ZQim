
import 'package:flutter/material.dart';
import 'package:flutter_im/database/user.dart';
import 'package:flutter_im/uitls/diouitls.dart';
import 'package:flutter_im/config/config.dart';
import 'package:flutter_im/component/toast.dart';
import 'package:flutter_im/src/pages/chat/grouochat.dart';
class DeleteMembers extends StatefulWidget{
  int gid;
  DeleteMembers(this.gid);
  State<DeleteMembers> createState()=>_DeleteMembers();

}
class _DeleteMembers extends State<DeleteMembers>{

  ScrollController _scrollController = ScrollController(); //listview的控制器
  var members=List<int>();
  var users=List<User>();
  var page=1;
  var checklist=List<int>();
  @override
  initState(){
    super.initState();
    meembers();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        meembers();
      }
    });
  }


  friendsinit(){

  }
  bool inside(int uid){
    for(var v in members){
      if(v==uid){
        return true;
      }
    }
    return false;
  }
  meembers()async{
    var url=WWW+"/group/members";
    var data=await DioUtls.get(url,queryParameters: {"id":widget.gid,"page":page});
    if(data.data["code"]==0){
      print(data.data["data"]);
      for(var d in data.data["data"]["members"]){
        print(d);
        var user=User();
        user.uid=d["ID"];
        user.headimage=d["head_image"];
        user.nickname=d["nickname"];
        users.insert(users.length,user);
      }
      setState(() {
        page++;
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
              controller: _scrollController,
              itemBuilder: (contex, i) {
                var user=users[i];

                return Container(
                  height: 52,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child:
                        Container(child:  Checkbox(
                          value:ischeck(user.uid),

                          onChanged:(val){
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
                          width: 25,
                          height: 42,
                          child: Image.network(testImage,
                              fit: BoxFit.fill, width: 25, height: 42),
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
      var url=WWW+"/group/remove";
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
          title: Text("移除组员"),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: FlatButton(
                disabledColor: Colors.grey,
                color: Colors.orange,
                onPressed: checklist.length>0?Submit:null,
                child: Text("删除(${checklist.length})",
                ),
              ) ,
            )
          ],
        ),
        body: Container(
            child:Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                  child: Container(
                    padding:  EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    color: Colors.grey[200],
                    child: Text("选择",style: TextStyle(fontSize: 15,color: Colors.grey),),
                  ),),
                Flexible(child:   chckefriendsItem(),)


              ],
            )
        )
    );
  }
}