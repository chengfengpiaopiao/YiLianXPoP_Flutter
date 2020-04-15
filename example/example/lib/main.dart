import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:example/example.dart';
import 'package:ylian_xpop/PopRoute.dart';
import 'package:ylian_xpop/Popup.dart';
import 'package:ylian_xpop/ylian_xpop.dart';

void main() => runApp( new MaterialApp(
  home: MyApp(),
));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  GlobalKey anchorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('YLian XPOP 弹窗',style: new TextStyle(color: Colors.black),),
      ),
      body: new Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text('1.假设您的锚点是右侧的?号 --> ',style: new TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
              new SizedBox(width: 5,),
              new GestureDetector(
                onTap: (){
                  RenderBox renderBox = anchorKey.currentContext.findRenderObject();
                  var offset = renderBox.localToGlobal(Offset.zero);
                  Navigator.push(context, PopRoute(child: Popup(
                    child: YLianXPoP(offset,new Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      child: new Text("区块链是一个信息技术领域的术语。从本质上讲，它是一个共享数据库，存储于其中的数据或信息，"
                          "具有“不可伪造”“全程留痕”“可以追溯”“公开透明”“集体维护”等特征。"
                          "",style: new TextStyle(color: Colors.white,fontSize: 12),),
                    ),
                      drawAnchor: true,
                        anchorColor:Colors.red,
                      drawContentBg: true,
                      contentBg: Colors.red,
                    ),
                    onClick: (){
                      print("exit");
                    },
                  )));
                },
                child: Image(image: new AssetImage("static/images/question.png"),width: 14,height: 14, key: anchorKey,),
              )
            ],
          ),
//       _createAnyPosition()
      ],
      ),
    );
  }

//  Widget _createAnyPosition(){
//    return new Positioned(
//      top: 100,
//      left: 100,
//      child: ,
//    );
//  }
}