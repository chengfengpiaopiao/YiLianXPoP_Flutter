import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui show TextStyle;

import 'package:flutter/material.dart';
import 'package:ylian_xpop/xpop_bean.dart';

class YLianXPoP extends StatefulWidget{

  //索引位置
  Offset offset;
  Widget wrapWidget;

  //是否需要绘制锚点
  bool drawAnchor = true;
  //锚点的颜色
  Color anchorColor = Colors.black;
  //是否空心
  bool isAnchorFill = true;
  //锚点的宽度和高度
  var anchorSize = [];

  //是否需要绘制背景
  bool drawContentBg;
  //内容背景色
  Color contentBg;
  //圆角
  num radiusX; num radiusY;
  //是否实心
  bool isContentFill;


  YLianXPoP(this.offset,this.wrapWidget,{this.drawAnchor,this.anchorColor,this.isAnchorFill,this.anchorSize,this.drawContentBg,this.contentBg,this.radiusX,this.radiusY,this.isContentFill});

  @override
  State<StatefulWidget> createState() {
    return _TipState();
  }
}

GlobalKey anchorKey2 = GlobalKey();


class _TipState extends State<YLianXPoP>{
  Offset offset;
  Widget wrapWidget;
  XPopBean xPopBean;

  @override
  void initState() {
    offset = widget.offset;
    wrapWidget = widget.wrapWidget;
    xPopBean = XPopBean(widget.drawAnchor,widget.anchorColor,widget.isAnchorFill,widget.anchorSize,widget.drawContentBg,widget.contentBg,widget.radiusX,widget.radiusY,widget.isContentFill);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widget = new Container(
      key:anchorKey2,
      child: wrapWidget,
    );

    var widgetPainer = CustomPaint(painter: _Painter(offset,context,widget,xPopBean));

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
  XPopBean xPopBean;

  PaintingStyle mode = PaintingStyle.fill;

  GlobalKey globalKey = GlobalKey();

  _Painter(this.offset,this.context,this.wrapWidget,this.xPopBean);

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

    if(xPopBean?.drawAnchor??true){
      Color anchorColor = xPopBean?.anchorColor??Colors.black;
      num startTranX = offset.dx + anchorArray[0]/2 - 2.5;
      num endTranX = offset.dx + anchorArray[0]/2 + 2.5;
      num tranY = startY - 5;
      canvas.drawPath(
          Path()
            ..moveTo(startTranX, startY)..lineTo(offset.dx + anchorArray[0]/2, tranY)
            ..lineTo(endTranX, startY)
            ..close(),
          Paint()
            ..color = anchorColor..strokeWidth = 1.0
            ..style = PaintingStyle.fill);
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
