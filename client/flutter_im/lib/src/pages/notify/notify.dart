import 'package:flutter/material.dart';
import 'package:flutter_im/uitls/diouitls.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_im/database/notify.dart';
const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";

class Notify extends StatefulWidget{
  State<StatefulWidget> createState()=>_Notify();
}

class _Notify extends State<Notify>{
  List<dynamic> notifymod= List<dynamic>();
  var page=1;
  ScrollController _scrollController = ScrollController(); //listview的控制器

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getnotifys();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getnotifys();
      }
    });

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
  agree(int nid )async{
    const String url="http://192.168.0.106:8080/friend/agree";
    var data=await DioUtls.post(url,data: {
      "notify_id":nid
    });
    if (data.data["code"]==0) {
      for (var i = 0; i < notifymod.length; i++) {
        if (notifymod[i]["ID"] == nid) {
          notifymod[i]["status"] = 2;
          break;
        }
      }

      setState(() {

      });
    }
  }
  refuse(int nid)async{
    const String url="http://192.168.0.106:8080/friend/refuse";
    var data=await DioUtls.post(url,data: {
      "notify_id":nid
    });

    if (data.data["code"]==0) {
      for (var i = 0; i < notifymod.length; i++) {
        if (notifymod[i]["ID"] == nid) {
          notifymod[i]["status"] = 3;
          break;
        }
      }
      setState(() {

      });
    }
  }
  clenr()async{
    var url="http://192.168.0.106:8080/notify/clear";
    var data=await DioUtls.post(url);

    if (data.data["code"]==0){
      notifymod.clear();
      page=1;
      setState(() {
      });
    }
  }
  getnotifys()async{
    var url="http://192.168.0.106:8080/notify/list";
    try {
      var data = await DioUtls.get(url, queryParameters: {
        "page": page
      });
      if (data.data["code"] == 0) {
        notifymod.insertAll(notifymod.length, data.data["data"]);
      }
      setState(() {
        page++;
      });
    }
    catch(e){
      print(e);
    }
  }
  Widget notifyitme(String nickname,headimge,greet,int  nid,stats){

    String text="同意";
    switch (stats){
      case 1:
        text="同意";
        break;
      case 2:
        text="已同意";
        break;
      case 3:
        text="已拒绝";
        break;


    }
    return Container(

      padding: EdgeInsets.only(left: 10),
      height: 75,
      child: Row(
        children: <Widget>[
          Expanded(
            child:Container(

              width: 55,
              height: 55,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(90)),
                child: Image.network(headimge!=""?headimge:testImage,fit:BoxFit.fill,width: 55,height: 55,),
              ),
            ),
            flex:3,
          ),
          Expanded(

            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(nickname,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                Text(greet),
              ],
            ),),
            flex: 10,
          ),
          Expanded(
            child:
            stats==1?Container(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Container(

                width: 60,
                child:   FlatButton(

                  onPressed: (){
                    agree(nid);
                  },
                  textColor: Colors.white,
                  color: Colors.green,
                  child: Text("同意"),
                ),
              ),
                  Container(
                    width: 60,
                    child:   FlatButton(
                      onPressed: (){
                        refuse(nid);
                      },
                      color: Colors.white,
                      child: Text("拒绝"),
                    ),
                  ),
              ],),
            ):
            Container(
              padding: EdgeInsets.only(right: 10),
            child:  FlatButton(
                color: Colors.green,
                child: Text(text)
            ),
            ),
            flex:7,
          ),

        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title:Text("好友通知"),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            child: Text("清空",style: TextStyle(color: Colors.white),),
            onPressed: (){
              showDialog(context: context,builder:(BuildContext context){
                return SimpleDialog(
                  title: Text("您确定要清空吗"),
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[


                          Expanded(
                            child: FlatButton(
                              child: Text('取消'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Expanded(
                            child:  FlatButton(
                              child: Text('确定'),
                              onPressed: () {
                                clenr();
                                Navigator.of(context).pop();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              });
            },
          )
        ],
      ),
      body:

      Container(
      child:ListView.builder(
        controller: _scrollController,
    itemCount: notifymod.length,
    itemBuilder:(BuildContext context, int index){
      var nt=notifymod[index];
      print(nt);
    return this.notifyitme(nt["nickname"],nt["head_image"],nt["greet"],nt["ID"],nt["status"]);
    },
        ),
      )
    );
  }
  Future<Null> _handleRefresh() async {
    // 模拟数据的延迟加载
    this.getnotifys();

  }
}