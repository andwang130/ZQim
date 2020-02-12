import 'package:flutter/material.dart';
import 'package:flutter_im/config/config.dart';
import 'package:flutter_im/database/user.dart';
import 'package:flutter_im/uitls/diouitls.dart';
import 'package:flutter_im/component/toast.dart';
import 'package:flutter_im/database/dialogue.dart';
import 'package:flutter_im/src/pages/chat/grouochat.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_im/uitls/cropImage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateGroup extends StatefulWidget {
  State<CreateGroup> createState() => _CreateGroup();
}

class _CreateGroup extends State<CreateGroup> {

  var users=List<User>();
  var checklist=List<int>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String avatar="";
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
              height: ScreenUtil.getInstance().setHeight(160),
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
                      width: ScreenUtil.getInstance().setWidth(45),
                      height: ScreenUtil.getInstance().setHeight(140),
                      child: Image.network(user.headimage,
                          fit: BoxFit.fill, width: 45, height: 140),
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
      if(avatar==""){
        Toast.toast(context, "请上传一张头像");
        return;
      }
      form.save();
      try{
        var url=WWW+"/group/create";
        print(groupname);
        var data= await DioUtls.post(url,data:{"group_name":groupname,"members":checklist,"avatar":avatar});
        if(data.data["code"]==0){
          var groupchat=data.data["data"];
          await User.insterGroup(groupchat["ID"], groupchat["group_name"], groupchat["avatar"]);
          await Dialogue.CreateGroupDialogue(groupchat["ID"], "", DateTime.now().toString());
          Navigator.push(context, MaterialPageRoute(builder: (_)=>GroupChat(groupchat["ID"])));
        }else{
          Toast.toast(context, data.data["msg"]);
        }
      }catch(e){
        Toast.toast(context, "网络错误");
      }


    }
  }
  opimage()async{
    var file=await ImagePicker.pickImage(source: ImageSource.gallery);
    var filename=await cropImage(file);
    if(filename!=""){
      avatar=filename;
      setState(() {

      });
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
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(40),
              child: Container(
                padding:  EdgeInsets.only(left: 10),

              ),),
            FlatButton(
              onPressed: () {
                opimage();
              },
              child: Container(
                  height: ScreenUtil.getInstance().setHeight(300),
                  width: ScreenUtil.getInstance().setWidth(300),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(60))),
                  child: avatar == ""
                      ? Image.asset("assets/images/Local Upload.png")
                      : ClipOval(
                    child: Image.network(
                      avatar,
                      fit: BoxFit.fill,
                    ),
                  )),
            ),
          Container(
            alignment: Alignment.bottomLeft,
            height: ScreenUtil.getInstance().setHeight(150),

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
