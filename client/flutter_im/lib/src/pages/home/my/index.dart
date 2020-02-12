import 'package:flutter/material.dart';
import 'package:flutter_im/component/menuitme.dart';
import 'package:flutter_im/component/toast.dart';
import 'package:flutter_im/net/handels.dart';
import 'package:flutter_im/uitls/diouitls.dart';
import 'package:flutter_im/config/config.dart';
import 'package:flutter_im/uitls/cropImage.dart';
import 'package:image_picker/image_picker.dart';
class My extends  StatefulWidget{
  State<StatefulWidget> createState()=>_My();
}
const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";
class _My extends State<My>{

  String username="";
  String headimage="";
  String nickname="";
  @override
  initState(){
    super.initState();
    getMyInfo();
  }
  getMyInfo()async{
    var url=WWW+"/user/get";
    var data=await DioUtls.get(url,queryParameters: {"uid":me});
    print(data.data);
    if(data.data["code"]==0){
      var d=data.data["data"];
      username=d["username"];
      nickname=d["nickname"];
      headimage=d["head_image"]==""?null:d["head_image"];
      setState(() {

      });
    }
  }
  updateimage(filename){
    var url=WWW+"/user/updateHeadImage";
    var data=DioUtls.post(url,data: {"head_image":filename});
    if(data.data["code"]==0){
      getMyInfo();
    }
  }
  opimage()async{
    var file=await ImagePicker.pickImage(source: ImageSource.gallery);
    var filename=await cropImage(file);
    if(filename!=""){
      updateimage(filename);
    }
  }
  Widget HeadAare(){
    return Container(
      padding: EdgeInsets.only(left: 30,right: 30),
      alignment: Alignment.topLeft,
      child: Row(
        children: <Widget>[
        Expanded(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("名称:${nickname}"),
              Text("账号:${username}"),
            ],
          ),
          flex: 7,
        ),


          Expanded(

            child: FlatButton(
              padding: EdgeInsets.all(0),  
              onPressed: (){
              opimage();

            }, child: ClipOval(
              child: Image.network(headimage==null?testImage:headimage,fit: BoxFit.fill,width: 58,height: 58,),
            )),
            flex: 2,
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(

      child: Column(
        children: <Widget>[
          SizedBox(height: 80,),
          this.HeadAare(),
          SizedBox(height: 20,),
          SizedBox(height: 10,child:
          Container(color: Colors.grey[200],),),
          MenuAare("我的广播",Icons.all_out,(){
            Toast.toast(context, "该功能还在开发中");
          }),
          MenuAare("附近的群",Icons.accessibility_new,(){
            Toast.toast(context, "该功能还在开发中");

          }),
//          MenuAare("钱包",Icons.attach_money,(){}),

          SizedBox(height: 10,child:
            Container(color: Colors.grey[200],),),
          MenuAare("游戏",Icons.games,(){
            Toast.toast(context, "该功能还在开发中");
          }),
          SizedBox(height: 20,child:
          Container(color: Colors.grey[200],),),
          MenuAare("设置",Icons.settings,(){
            Toast.toast(context, "该功能还在开发中");
          }),
        ],
      ),
    );
  }
}