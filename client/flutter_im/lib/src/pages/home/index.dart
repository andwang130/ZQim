import 'package:flutter/material.dart';
import 'package:flutter_im/src/pages/home/messages/index.dart';
import 'package:flutter_im/src/pages/home/friends/index.dart';
import 'package:flutter_im/src/pages/home/my/index.dart';

class Home extends StatefulWidget{
  State<StatefulWidget> createState()=>_Home();
}
 var tabs=[
  Messages(),
   Friends(),
   My(),
 ];
class _Home extends State<Home>{

  int index=0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

     body:tabs[index] ,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index){
          setState(() {
          this.index=index;
          });

        },
      currentIndex: this.index,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.message),title: Text("消息")
      ),
      BottomNavigationBarItem(
      icon: Icon(Icons.people),title: Text("好友")
      ),

      BottomNavigationBarItem(
      icon:Icon(Icons.face),title: Text("我的")
      ),
      ],
      ),

    );

  }
}