import 'package:flutter/material.dart';
import 'package:flutter_im/src/pages/userinfo/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter_im/database/user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Addfriend extends StatefulWidget{

  State<StatefulWidget> createState()=>_Addfriend();
}
const String testImage="https://bkimg.cdn.bcebos.com/pic/4b90f603738da97784eaf36dba51f8198718e3ab@wm_1,g_7,k_d2F0ZXIvYmFpa2U4MA==,xp_5,yp_5";

class _Addfriend extends State<Addfriend>{

  ScrollController _scrollController = ScrollController(); //listview的控制器
  var page=1;
  String key="";
  List<User> users=List<User>();
  void getUsers()async{
    var dio=Dio();
    var data=await dio.get("http://192.168.0.106:8080/friend/serach",queryParameters:{"page":page,"key":key});
    if (data.data["code"]==0){

     for (var d in  data.data["data"]){
       print(d);
       var user=User();
        user.uid=d["ID"];
        user.nickname=d["nickname"];
        user.useranme=d["username"];
        user.headimage=d["head_image"];
        print(user.headimage);
        users.add(user);
     }
     setState(() {
    page++;
     });
      
    }
    
    
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("_scrollController");
        getUsers();
      }
    });

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  Widget friendItem(int uid,String nickname,String useranem,String headimage){
    return FlatButton(
      onPressed: (){

        Navigator.push(context, MaterialPageRoute(builder: (_)=>UserInfo(uid)));
      },
      child: Container(
        height: ScreenUtil.getInstance().setHeight(55),

        child:Row(

          children: <Widget>[
            Expanded(
              child:Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.network(headimage!=null?headimage:testImage,fit:BoxFit.fill,width: 45,height: 45,),
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child:Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(nickname!=null?nickname:"",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w300),),
                    Text("账号:"+(useranem!=null?useranem:"")),
                    Divider(height: 10,thickness:1)
                  ],
                ) ,
              ),
              flex: 6,
            ),




          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title:Container(
        height: 40,

        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Expanded(
            child:    TextField(
            textAlign: TextAlign.left,
              decoration: InputDecoration(
                  hintText: "输入用户名",
                  contentPadding: EdgeInsets.only(left: 20,top: 10),
                  fillColor: Colors.white,
                  filled: true,
                  border:OutlineInputBorder(

                    borderRadius: BorderRadius.all(Radius.circular(45)),

                  )
              ),
              onChanged: (text){
                key=text;
              },
              onSubmitted: (text){
                users.clear();
                page=1;
                this.getUsers();
              },
            ),
              flex: 6,
        ),
            Expanded(
              child: FlatButton(
                  padding: EdgeInsets.only(left: 0,right: 0),
                  onPressed: (){
                    users.clear();
                    page=1;
                    this.getUsers();
                  },
                  child:Text("搜索",style: TextStyle(fontSize: 16,color: Colors.white),)),
              flex: 1,
            )

          ],
        )
      )),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context,i){
          var user=users[i];
          return this.friendItem(user.uid,user.nickname,user.useranme,user.headimage);
        },
        controller: _scrollController,
      ),
    );
  }
}