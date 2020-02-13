
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_im/src/pages/home/index.dart';
import 'package:flutter_im/net/networkmanage.dart';
import 'package:flutter_im/config/config.dart';
import 'package:flutter_im/component/toast.dart';
import 'package:flutter_im/src/pages/register/index.dart';
import 'package:flutter_im/component/customroute.dart';
class Login extends StatefulWidget{
  State<StatefulWidget> createState()=>_Login();
}
class _Login extends State<Login>{
  //全局 Key 用来获取 Form 表单组件
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  final bottomsheetKey=GlobalKey<ScaffoldState>();
  String loginUrl=WWW+"/login";
  String  logo="https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1578541323&di=59cc0c9276f62ecf25810f88ecee11ca&imgtype=jpg&er=1&src=http%3A%2F%2Fa4.mzstatic.com%2Fus%2Fr1000%2F116%2FPurple%2Fcd%2Ff8%2F87%2Fmzi.dafirwah.512x512-75.png";
  bool  _isShowPwd=false;
  String username;
  String password;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget LogArea(){
    return Container(
      alignment: Alignment.topCenter,
      child: ClipOval(
        child:Image.network(logo,
        width: 120,height: 120,fit:BoxFit.fill),
      ),
    );
  }
  Widget InputArea(){

    return Container(
      margin: EdgeInsets.only(left: 20,right: 20),
      child: Form(
        key: loginKey,
      child:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
              decoration:InputDecoration(
                labelText: "用户名",
                hintText: "请输入手机号",
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
              labelText: "密码",
              hintText: "请输入密码",
              prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon((_isShowPwd) ? Icons.visibility : Icons.visibility_off),
                  // 点击改变显示或隐藏密码
                  onPressed: (){
                    setState(() {
                      _isShowPwd = !_isShowPwd;
                    });
                  },
                )
            ),
            obscureText: !_isShowPwd,
            onSaved: (text){
              password=text;
            },
            validator: (value) {
              return value.length < 6 ? '密码长度不够 6 位' : null;
            },
          ),
        ],
      )),
    );
  }
  Widget LoginButtonArea(){

    return Container(
      margin: EdgeInsets.only(left: 20,right: 20),
      height: 45.0,
      width: 400,
      child: RaisedButton(
        onPressed: SubmitLogin,
        child: Text("登录", style: Theme.of(context).primaryTextTheme.headline,),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Colors.blue[300],

      )



    );
  }
  Widget bottomArea () {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 30),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlatButton(
            child: Text(
              "忘记密码?",
              style: TextStyle(
                color: Colors.blue[400],
                fontSize: 16.0,
              ),
            ),
            //忘记密码按钮，点击执行事件
            onPressed: () {},
          ),
          FlatButton(
            child: Text(
              "快速注册",
              style: TextStyle(
                color: Colors.blue[400],
                fontSize: 16.0,
              ),
            ),
            //点击快速注册、执行事件
            onPressed: () {

              Navigator.push(context, CustomRoute(Register()));
            },
          )
        ],
      ),
    );
  }
    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return Scaffold(
        backgroundColor:Colors.white,
        body: Column(
          children: <Widget>[
            SizedBox(height: 80,),
            this.LogArea(),
            SizedBox(height: 60,),

            this.InputArea(),
            SizedBox(height: 60,),
            this.LoginButtonArea(),
            SizedBox(height: 60,),
            bottomArea()
          ],
        ),
        resizeToAvoidBottomPadding:false ,
      );
    }

  SubmitLogin()async{
    //读取当前 Form 状态
    var loginForm = loginKey.currentState;
    //验证 Form表单
    if (loginForm.validate()) {
      loginForm.save();
      try {
        Dio dio = Dio();
        var res = await dio.post(
            loginUrl, data: {"username": username, "passwd": password});

        if (res.data["code"] == 0) {
           Init(res.data);
           Navigator.pushAndRemoveUntil(context,CustomRoute( Home()),(route) => route == null);
        }else{
          Toast.toast(context, res.data["msg"]);
        }

      }catch(e){
        Toast.toast(context, "服务器错误");
      }






    }

  }

}
