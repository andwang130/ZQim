
import 'package:flutter/material.dart';
import 'chat.dart';
import 'package:flutter_im/database/message.dart';
class GroupChat extends StatefulWidget{
  int gid;
  GroupChat(this.gid);
  State<GroupChat> createState()=>_GroupChat();
}

class _GroupChat extends State<GroupChat>{

  int page=1;
  List<OneMessage> list=List<OneMessage>();
  getmessage(){


  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  null;
  }
}