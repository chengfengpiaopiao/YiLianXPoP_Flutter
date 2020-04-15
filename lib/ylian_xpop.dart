import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui show TextStyle;

import 'package:flutter/material.dart';

class YLianXPoP extends StatefulWidget{

  //索引位置
  Offset offset;
  Widget wrapWidget;

  YLianXPoP(this.offset,this.wrapWidget);

  @override
  State<StatefulWidget> createState() {
    return _TipState();
  }
}

GlobalKey anchorKey2 = GlobalKey();


class _TipState extends State<YLianXPoP>{
  Offset offset;
  Widget wrapWidget;

  @override
  void initState() {
    offset = widget.offset;
    wrapWidget = widget.wrapWidget;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widget = new Container(
      key:anchorKey2,
      child: wrapWidget,
    );

    var widgetPainer = CustomPaint(painter: _Painter(offset,context,widget),);

    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child:  widgetPainer,
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(45, offset.dy + 25, 45, 0),
            child: widget,
          ),
        ],
      ),
    );
  }

}

class _Painter extends CustomPainter {
  Offset offset;
  BuildContext context;
  Widget wrapWidget;
  //锚点的 宽 高 离锚点的距离
  var anchorArray = [10,10,15,8.0];
  num margin = 40;

  PaintingStyle mode = PaintingStyle.fill;

  GlobalKey globalKey = GlobalKey();

  _Painter(this.offset,this.context,this.wrapWidget);

  @override
  void paint(Canvas canvas, Size size) {

    RenderBox renderBox = anchorKey2.currentContext.findRenderObject();
    var offset2 = renderBox.localToGlobal(Offset.zero);
    print(offset2.dx);

    final contentWidth = anchorKey2.currentContext.size.width;
    final contentHeight = anchorKey2.currentContext.size.height;

    print(contentWidth);

    num startY = offset.dy +  anchorArray[2] + anchorArray[1];

    canvas.drawRRect(
        RRect.fromLTRBXY(40, startY, MediaQuery.of(context).size.width - 40, startY + contentHeight, anchorArray[3], anchorArray[3]),
        Paint()..color = Colors.black..strokeWidth = 4.0..style = mode);

    num startTranX = offset.dx + anchorArray[0]/2 - 2.5;
    num endTranX = offset.dx + anchorArray[0]/2 + 2.5;
    num tranY = startY - 5;
    canvas.drawPath(
        Path()
          ..moveTo(startTranX, startY)..lineTo(offset.dx + anchorArray[0]/2, tranY)
          ..lineTo(endTranX, startY)
          ..close(),
        Paint()
          ..color = Colors.black..strokeWidth = 1.0
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
