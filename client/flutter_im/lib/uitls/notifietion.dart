import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as $notifications;
import 'package:flutter_im/src/pages/chat/index.dart';
import 'dart:convert';
$notifications.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
GlobalKey<NavigatorState> navigatorKey=GlobalKey();
bool IsBack=false;
notifietioninit()async{
  flutterLocalNotificationsPlugin = $notifications.FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = new $notifications.AndroidInitializationSettings('app_icon');

  var initializationSettingsIOS = new $notifications.IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);

  var initializationSettings = new $notifications.InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification);
}

//通知栏被点击时执行的方法
Future onSelectNotification(String payload)async{
  if (payload != null) {
    debugPrint('notification payload: ' + payload);
  }
  try {
    var pjson = jsonDecode(payload);
    if(pjson["msgtype"]==1){

     await navigatorKey.currentState.push(MaterialPageRoute(builder:(_)=> Chat(pjson["id"])));
    }
    if(pjson["msgtype"]==2){
      
    }
  }catch(e){
    
  }
  
//payload 可作为通知的一个标记，区分点击的通知。
  if(payload != null && payload == "complete") {
    print(payload);
  }
}

Future<void> onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  await showDialog(
    builder: (BuildContext context) => Container(
      child: Text(title),
//        content: Text(body),
//        actions: [
//          CupertinoDialogAction(
//            isDefaultAction: true,
//            child: Text('Ok'),
//            onPressed: () async {
//              Navigator.of(context, rootNavigator: true).pop();
//              await Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => SecondScreen(payload),
//                ),
//              );
//            },
//          )
//        ],
    ),
  );
}

class Notifications {
  static oneMessageNotification(int uid,String name,msg,String head)async{
    
    var pyload=jsonEncode({"id":uid,"msgtype":1});
    _show(uid, name, msg, head,pyload);
   

  }
  static groupMessageNotification(int gid,String name,msg,String head){
    var pyload=jsonEncode({"id":gid,"msgtype":2});
    _show(gid, name, msg, head,pyload,channelId: "group",channelName:"group message",channelDescription:"群聊推送");
  }
  static _show(int id,String  title,msg,String head,pyload,{String channelId="one",channelName="one message",channelDescription="单聊推送"})async{
    if(!IsBack){
      return;
    }
    var androidPlatformChannelSpecifics = new $notifications.AndroidNotificationDetails(
        channelId, channelName,channelDescription,visibility:$notifications.NotificationVisibility.Public,
        icon:head,
        enableLights:true,
        importance: $notifications.Importance.Max, priority: $notifications.Priority.Max);
    //IOS的通知配置
    var iOSPlatformChannelSpecifics = new $notifications.IOSNotificationDetails();
    var platformChannelSpecifics = new $notifications.NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    //显示通知，其中 0 代表通知的 id，用于区分通知。
    await flutterLocalNotificationsPlugin.show(
        id, title, msg, platformChannelSpecifics,
        payload: pyload);
  }
  static otherNotification()async {

  }
}

