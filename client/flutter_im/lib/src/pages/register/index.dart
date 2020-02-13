import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_im/config/config.dart';
import 'package:flutter_im/component/customroute.dart';
import 'package:flutter_im/component/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:flutter_im/src/pages/login/index.dart';
import 'package:flutter_im/uitls/cropImage.dart';
class Register extends StatefulWidget {
  State<StatefulWidget> createState() => _Register();
}

class _Register extends State<Register> {
  GlobalKey<FormState> RegisterKey = GlobalKey<FormState>();
  bool _isShowPwd = false;
  bool hasError = false;
  String headImage = "";
  String username;
  String password;
  String nickname;
  TextEditingController _pinEditingController =
      TextEditingController(text: '123');



  void register()async{
    var url=WWW+"/register";
    RegisterKey.currentState.save();
    if(RegisterKey.currentState.validate()){

      if(headImage==""){
        Toast.toast(context, "请上传您的头像");
        return;
      }
      var dio=Dio();
      var data=await dio.post(url,data: {
        "username":username,
        "passwd":password,
        "nickname":nickname,
        "head_image":headImage,
      });
      if(data.data["code"]==0){
        Navigator.pushAndRemoveUntil(context, CustomRoute(Login()),(route)=>route==null);
      }else{
        Toast.toast(context, data.data["msg"]);
      }

    }
  }
  opimage()async{
    var file=await ImagePicker.pickImage(source: ImageSource.gallery);
    var filename=await cropImage(file);
   if(filename!=""){
     headImage=filename;
     setState(() {

     });
   }
  }
  Widget InputArea() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Form(
        key: RegisterKey,
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[


          FlatButton(
            onPressed: () {
              opimage();
            },
            child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(60))),
                child: headImage == ""
                    ? Image.asset("assets/images/Local Upload.png")
                    : ClipOval(
                        child: Image.network(
                          headImage,
                          fit: BoxFit.fill,
                        ),
                      )),
          ),
          TextFormField(
              decoration: InputDecoration(
            labelText: "账号",
            hintText: "请输入您的登录账号",
            prefixIcon: Icon(Icons.person),

          ),
            onSaved: (text){
              username=text;
            },
            validator: (value){
              return value.trim().length > 0 ? null : "用户名不能为空";

            },
           ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "昵称",
              hintText: "请输入一个昵称",
              prefixIcon: Icon(Icons.person),

            ),
            onSaved: (text){
              nickname=text;
            },
            validator: (value){
              return value.trim().length > 0 ? null : "昵称不能为空";

            },
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: "密码",
                hintText: "请输入密码",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                      (_isShowPwd) ? Icons.visibility : Icons.visibility_off),
                  // 点击改变显示或隐藏密码
                  onPressed: () {
                    setState(() {
                      _isShowPwd = !_isShowPwd;
                    });
                  },
                )),
            obscureText: !_isShowPwd,
            onSaved: (text){
              password=text;
            },
            validator: (value) {
              return value.length < 6 ? '密码长度不够 6 位' : null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: "重复密码",
                hintText: "请输入密码",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                      (_isShowPwd) ? Icons.visibility : Icons.visibility_off),
                  // 点击改变显示或隐藏密码
                  onPressed: () {
                    setState(() {
                      _isShowPwd = !_isShowPwd;
                    });
                  },
                )),
            obscureText: !_isShowPwd,
            onSaved: (text){

            },
            validator: (value) {

              return value!=password ? '密码不一致' : null;
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
//          PinInputTextField(
//            pinLength: 4,
//
//             controller: _pinEditingController,
//            textInputAction: TextInputAction.go,
//            onSubmit: (pin) {
//              debugPrint('submit pin:$pin');
//            },
//          ),
//          Container(
//            padding: EdgeInsets.only(top: 10),
//            alignment: Alignment.topRight,
//            child:     FlatButton(
//              child: Text(
//                "获取验证码",
//                style: TextStyle(
//                  color: Colors.blue[400],
//                  fontSize: 20,
//                ),
//              ),
//              //点击快速注册、执行事件
//              onPressed: () {},
//            )
//          )
        ],
      )),
    );
  }

  Widget LoginButtonArea() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        height: 45.0,
        width: 400,
        child: RaisedButton(
          onPressed: () { register();},
          child: Text(
            "立即注册",
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.blue[300],
        ));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.getInstance().init(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("注册"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          this.InputArea(),
          SizedBox(
            height: 30,
          ),
          this.LoginButtonArea(),
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
