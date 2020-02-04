import 'package:flutter/material.dart';
import 'package:flutter_im/src/pages/chat/component/bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_im/src/pages/chatinfo/index.dart';
import 'package:flutter_im/database/message.dart';
class Chat extends StatefulWidget{
  int uid;
  Chat(this.uid);
  State<StatefulWidget> createState()=>_Chat();
}
const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";

class _Chat extends State<Chat>{
  TextEditingController _textController=TextEditingController();

  int page=1;
  List<OneMessage> list=List<OneMessage>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getmessage();
  }


  void getmessage()async{
    var data=await OneMessage.GetOneMessage(1, 2, page);
    list.insertAll(0,data);
    setState(() {
      page++;
    });
  }
  Widget titleArea(){
    return AppBar(
      centerTitle:true ,
      title: Text("聊天页面",style: TextStyle(color: Colors.black),),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.settings,color: Colors.black,),onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>Chatinfo(1,widget.uid)));
        },)
      ],
    );
  }
  Widget LeftMessageItem(String message){
    num width=message.length>20?600:message.length*40;
    num height=(message.length/20).ceil()*100;
    return Container(
      padding: EdgeInsets.only(top: 10,left: 10),
      child:Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipOval(child: Image.network(testImage,fit:BoxFit.fill,width: 52,height: 52,),),
              Container(child: BubbleWidget(
                  ScreenUtil().setWidth(width),
                  ScreenUtil().setHeight(height),
                  Colors.white,
                  BubbleArrowDirection.left,child:Text(message,textAlign: TextAlign.start),
                  length: ScreenUtil().setWidth(20)
              ),)
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text("2020-1-3 15:24:33",style: TextStyle(color: Colors.grey),),
          )
        ],
      )
    );
  }
  Widget RightMessageItem(String message){
    num width=message.length>20?600:message.length*40;
    num height=(message.length/20).ceil()*100;
    print(width);
    return Container(
        padding: EdgeInsets.only(top: 10,right: 10),
        child:Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[

                Container(child: BubbleWidget(
                    ScreenUtil().setWidth(width),
                    ScreenUtil().setHeight(height),
                    Colors.blue,
                    BubbleArrowDirection.right,child:Text(message,textAlign: TextAlign.start),
                    length: ScreenUtil().setWidth(20)
                ),),
                ClipOval(child: Image.network(testImage,fit:BoxFit.fill,width: 52,height: 52,),),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Text("2020-1-3 15:24:33",style: TextStyle(color: Colors.grey),),
            )
          ],
        )
    );
  }
  _handleSubmitted(String valeu){

  }

  Widget _buildTextComposer(){
    return new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
            children: <Widget> [
              new Flexible(
                  child: new TextField(
                    controller: _textController,
                    onSubmitted: _handleSubmitted,
                    decoration: new InputDecoration.collapsed(hintText: '发送消息'),
                  )
              ),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(Icons.send,color: Colors.blue,),
                    onPressed: () => _handleSubmitted(_textController.text)
                ),
              )
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    // TODO: implement build
    return Scaffold(
      appBar:this.titleArea() ,
      body:
          Column(children: <Widget>[
           Flexible(
          child:RefreshIndicator(child:  ListView.builder(
          itemCount: list.length,
            itemBuilder: (context,i){
              var message=list[i];
              var me=1;
              if (message.sender==me){

                return this.RightMessageItem("12321312231312312312321312312321349");
              }else{
                return this.LeftMessageItem(message.rek.toString());
              }
            },

          ) , onRefresh:this._handleRefresh)
           ),


            Container(
              child:_buildTextComposer() ,
            ),
          ],)




    );
  }
  Future<Null> _handleRefresh() async {
    // 模拟数据的延迟加载
    await this.getmessage();
  }

}

