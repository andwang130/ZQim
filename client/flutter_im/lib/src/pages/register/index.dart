import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';




class Register extends StatefulWidget{
  State<StatefulWidget> createState()=>_Register();
}
class _Register extends State<Register>{
  bool _isShowPwd=false;
  bool hasError=false;
  TextEditingController _pinEditingController = TextEditingController(text: '123');
  Widget InputArea(){
    return Container(
      margin: EdgeInsets.only(left: 20,right: 20),
      child: Form(child:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
              decoration:InputDecoration(
                labelText: "用户名",
                hintText: "请输入手机号",
                prefixIcon: Icon(Icons.person),
              )
          ),
          TextField(
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
          ),
          TextField(
            decoration: InputDecoration(
                labelText: "重复密码",
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
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          PinInputTextField(
            pinLength: 4,

             controller: _pinEditingController,
            textInputAction: TextInputAction.go,
            onSubmit: (pin) {
              debugPrint('submit pin:$pin');
            },
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            alignment: Alignment.topRight,
            child:     FlatButton(
              child: Text(
                "获取验证码",
                style: TextStyle(
                  color: Colors.blue[400],
                  fontSize: 20,
                ),
              ),
              //点击快速注册、执行事件
              onPressed: () {},
            )
          )
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
        onPressed: (){},

        child: Text("立即注册", style: Theme.of(context).primaryTextTheme.headline,),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Colors.blue[300],

      )



    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("注册"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 60,),
          this.InputArea(),
          SizedBox(height: 30,),
          this.LoginButtonArea(),
        ],
      ),
    );
  }
}
