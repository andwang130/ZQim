import 'package:flutter/material.dart';
import 'package:flutter_im/component/menuitme.dart';
class My extends  StatefulWidget{
  State<StatefulWidget> createState()=>_My();
}
const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";
class _My extends State<My>{

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
              Text("名称"),
              Text("账号")
            ],
          ),
          flex: 5,
        ),


          Expanded(
            child:ClipOval(
              child: Image.network(testImage,fit: BoxFit.fill,width: 42,height: 62,),
            ),
            flex: 1,
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
          MenuAare("我的广播",Icons.all_out,(){}),
          MenuAare("附近的群",Icons.accessibility_new,(){}),
          MenuAare("钱包",Icons.attach_money,(){}),

          SizedBox(height: 10,child:
            Container(color: Colors.grey[200],),),
          MenuAare("游戏",Icons.games,(){}),
          MenuAare("加密兔",Icons.ring_volume,(){}),
          SizedBox(height: 20,child:
          Container(color: Colors.grey[200],),),
          MenuAare("设置",Icons.settings,(){}),
        ],
      ),
    );
  }
}