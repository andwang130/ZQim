import 'package:flutter/material.dart';
import 'package:flutter_im/config/config.dart';
import 'package:flutter_im/uitls/diouitls.dart';

import 'package:flutter_im/database/user.dart';
import 'package:flutter_im/component/customroute.dart';
import 'package:flutter_im/src/pages/userinfo/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class MebersAll extends StatefulWidget{

  int gid;
  MebersAll(this.gid);
  State<MebersAll> createState()=>_MebersAll();
}

class _MebersAll extends State<MebersAll>{
  ScrollController _scrollController = ScrollController(); //listview的控制器
  var members=List<int>();
  var users=List<User>();
  var page=1;
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


  Widget chckefriendsItem(){

    return
      Container(
          color: Colors.grey[100],

          child:  ListView.builder(
              itemCount: users.length,
              controller: _scrollController,
              itemBuilder: (contex, i) {
                var user=users[i];
                return
                  FlatButton(child:Container(
                    padding: EdgeInsets.only(left: 10),
                    height: ScreenUtil.getInstance().setHeight(150),
                    child: Row(
                      children: <Widget>[

                        Expanded(
                          child: Container(
                            width: ScreenUtil.getInstance().setWidth(55),
                            height: ScreenUtil.getInstance().setHeight(130),
                            child: Image.network(user.headimage,
                                fit: BoxFit.fill, width: ScreenUtil.getInstance().setWidth(55), height: ScreenUtil.getInstance().setHeight(140)),
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
                  ),onPressed: (){
                    Navigator.push(context, CustomRoute(UserInfo(user.uid)));
                  },);

              }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("全部成员"),

        ),
        body: Container(
            child:Column(
              children: <Widget>[

                Flexible(child:   chckefriendsItem(),)


              ],
            )
        )
    );
  }
}
