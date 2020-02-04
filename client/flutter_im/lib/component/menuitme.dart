import 'package:flutter/material.dart';
Widget MenuAare(String title,IconData icon,Function() cb){
  return
    FlatButton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              height: 47,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(title,style:TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),),),
                    flex: 4,
                  ),

                  Container(

                    alignment: Alignment.centerRight,
                    child: Icon(icon),),
                ],
              )),
          Divider(color: Colors.grey,height: 1,)
        ],
      ),
      onPressed: (){ cb();},);
}
Widget SizeBoxGrey(double hight){
  return    SizedBox(height: hight,child:
Container(color: Colors.grey[200],),);
}