
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Popup extends StatelessWidget{
  final Widget child;
  final Function onClick;
  final double left;
  final double top;
 
  Popup({
    @required this.child,
    this.onClick,
    this.left,
    this.top,
  });
 
  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.transparent, child: GestureDetector(child: Stack(
      children: <Widget>[
        Container(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, color: Colors.transparent,),
        GestureDetector(child: child, onTap: (){
          if(onClick != null){
            Navigator.of(context).pop();
            onClick();
          }
        })
      ],
    ),
      onTap: (){
        Navigator.of(context).pop();
      },
    ),);
  }
 
}
