import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_im/src/pages/login/index.dart';
import 'package:flutter_im/src/pages/register/index.dart';
import 'package:flutter_im/src/pages/home/index.dart';
import 'package:flutter_im/src/pages/chat/index.dart';
import 'package:flutter_im/src/pages/chatinfo/index.dart';
import 'package:flutter_im/src/pages/userinfo/index.dart';
import 'package:flutter_im/src/pages/addfriend/index.dart';
import 'package:flutter_im/net/networkmanage.dart';
import 'package:flutter_im/database/dbmange.dart';
import 'package:flutter_im/database/dialogue.dart';
import 'package:flutter_im/database/user.dart';
import 'package:flutter_im/database/message.dart';
import 'package:flutter_im/src/pages/notify/notify.dart';
import 'package:flutter_im/net/handels.dart';
import 'package:flutter_im/src/pages/addGroup/createGroup.dart';
import 'package:flutter_im/uitls/notifietion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_im/uitls/diouitls.dart';
import 'package:flutter_im/config/config.dart';
void main()async {
   WidgetsFlutterBinding.ensureInitialized();

   await notifietioninit();
  runApp(MyApp());

}
class MyApp extends StatefulWidget{
  State<MyApp> createState()=>_MyApp();
}
class _MyApp extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed:// 应用程序可见，前台
        IsBack=false;
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        IsBack=true;
        break;
      case AppLifecycleState.detached:
        break;
    }

    setState(() {

    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var headimage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";
    var nickname="王晶";


//    User.inster(1, "张飞", headimage);
//    User.inster(2, "王晶", headimage);
//
//    for (var i=300;i<1000;i++) {
//      OneMessage.inster(i, 1, 2, 1, "你好张飞",DateTime.now().millisecondsSinceEpoch );
//
//    }
//    for(var i=1001;i<1300;i++){
//      OneMessage.inster(i, 2, 1, 1, "你好李四",DateTime.now().millisecondsSinceEpoch );
//
//    }

    return MaterialApp(

        navigatorKey:navigatorKey,
      home: SplashScreen()
    );
  }
}

//启动页面
class SplashScreen extends StatefulWidget{

  State<SplashScreen> createState()=>_SplashScreen();
}
class _SplashScreen extends State<SplashScreen>{

  _chekcisLogin()async{
    SharedPreferences prefs = await  SharedPreferences.getInstance();
    var token=prefs.get("token");
    if(token!=""){
      var url=WWW+"/checklogin";

      try {
        var data = await DioUtls.get(url);
        print(data);
        if(data.data["code"]==0){
          await Init(data.data);
          Navigator.push(context, MaterialPageRoute(builder: (_)=>Home()));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (_)=>Login()));
        }
      }catch(e){
        print(e);
      }
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (_)=>Login()));
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var timer=Timer(Duration(seconds: 1),_chekcisLogin);

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Image.network("http://b-ssl.duitang.com/uploads/item/201601/30/20160130164648_axyPe.thumb.700_0.jpeg",fit: BoxFit.contain,),
      ),
    );
  }
}