import 'package:flutter/material.dart';
import 'package:flutter_im/config/config.dart';
import 'package:flutter_im/database/user.dart';
import 'package:flutter_im/uitls/diouitls.dart';
class CreateGroup extends StatefulWidget {
  State<CreateGroup> createState() => _CreateGroup();
}



class _CreateGroup extends State<CreateGroup> {

  var users=List<User>();
  var checklist=List<int>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String groupname="";
  @override
  initState(){
    super.initState();
    friendsinit();
  }

  friendsinit(){
    User.GetUsers().then((values){
      setState(() {
        users=values;
      });
    });
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
            return Container(
              height: 52,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child:
                    Container(child:  Checkbox(
                      value:ischeck(user.uid),
                      onChanged: (val){
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
    var form = formKey.currentState;
    if(form.validate()){
      form.save();
      try{
        var url=WWW+"/group/create";
        print(groupname);
        var data= await DioUtls.post(url,data:{"group_name":groupname,"members":checklist});
        if(data.data["code"]==0){

        }else{
          print(data.data);
        }
      }catch(e){

      }


    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("创建群聊"),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
          child: FlatButton(
            disabledColor: Colors.grey,
            color: Colors.orange,
            onPressed: checklist.length>1?Submit:null,
            child: Text("确定(${checklist.length})",
            ),
          ) ,
      )
        ],
      ),
      body: Container(
        child:Column(
          children: <Widget>[
          Container(
            alignment: Alignment.bottomLeft,
            height: 50,

          child:
          Form(
           key: formKey,
          child:
          TextFormField(
            decoration: InputDecoration(
              labelText: "群聊名称",
            ),
            onSaved: (text){
              groupname=text;
            },
            validator: (value) {
              return value.length < 1 ? '请输入群聊名称' : null;
            },
          ),),


            ),

        SizedBox(
          height: 30,
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
