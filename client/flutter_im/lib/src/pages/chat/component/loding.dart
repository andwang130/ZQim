import 'package:flutter/material.dart';
class Loading extends StatefulWidget{
  State<StatefulWidget> createState()=>_Loading();
}
class _Loading extends State<Loading> with SingleTickerProviderStateMixin{

  AnimationController controller;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =AnimationController(duration: const Duration(seconds: 1), vsync: this);
    //动画开始、结束、向前移动或向后移动时会调用StatusListener
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //动画从 controller.forward() 正向执行 结束时会回调此方法
        controller.reset();
        controller.forward();
      } else if (status == AnimationStatus.dismissed) {
        //动画从 controller.reverse() 反向执行 结束时会回调此方法

      } else if (status == AnimationStatus.forward) {

        //执行 controller.forward() 会回调此状态
      } else if (status == AnimationStatus.reverse) {
        //执行 controller.reverse() 会回调此状态

      }
    });
    controller.forward();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      RotationTransition(child:  Icon(Icons.update,color: Colors.lightBlue,),
        turns:controller ,
      );

  }
}