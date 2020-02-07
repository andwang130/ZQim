import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:flutter_im/uitls/notifietion.dart';

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
      home: Login()
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

