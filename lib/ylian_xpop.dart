import 'dart:ui';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui show TextStyle;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ylian_xpop/xpop_bean.dart';

class YLianXPoP extends StatefulWidget{

  //索引位置
  Offset offset;
  Widget wrapWidget;

  //src锚点大小
  num anSrcWidth = 14;
  num anSrcHeight = 14;
  num marginTop = 10;

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

  //边距
  double marginLeft  = 45.0;
  double marginRight= 45.0;

  YLianXPoP(this.offset,this.wrapWidget,{
    this.drawAnchor,this.anchorColor,this.isAnchorFill,this.anchorSize,this.drawContentBg,this.contentBg,
    this.radiusX,this.radiusY,this.isContentFill,this.anSrcWidth,this.anSrcHeight,this.marginTop,this.marginLeft,this.marginRight});

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
    xPopBean = XPopBean(
        widget.drawAnchor, widget.anchorColor, widget.isAnchorFill,
        widget.anchorSize, widget.drawContentBg, widget.contentBg, widget.radiusX,
        widget.radiusY, widget.isContentFill, widget.anSrcWidth, widget.anSrcHeight,
        widget.marginTop,widget.marginLeft,widget.marginRight);
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
            margin: EdgeInsets.fromLTRB(xPopBean.marginLeft??45, offset.dy + (xPopBean?.anSrcHeight??14) + (xPopBean?.marginTop??10) + ((xPopBean?.anchorSize) != null ? xPopBean?.anchorSize[1] : 10), xPopBean.marginLeft??45, 0),
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

  XPopBean xPopBean;


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

    num anSrcWidth = xPopBean?.anSrcWidth??14;
    num anSrcHeight = xPopBean?.anSrcHeight??14;
    num marginTop = xPopBean?.marginTop??10;

    num anchorHeight  = (xPopBean?.anchorSize) != null ? xPopBean?.anchorSize[1] : 10;
    num startY = offset.dy + anSrcHeight;

    PaintingStyle mode = PaintingStyle.fill;
    if(xPopBean.isContentFill??true){
      mode =  PaintingStyle.fill;
    }else{
      mode =  PaintingStyle.stroke;
    }
    Color contentColor = xPopBean.contentBg ?? Colors.black;

    Paint paint = Paint();
    if(xPopBean?.drawAnchor??true){
      Color anchorColor = xPopBean?.anchorColor??Colors.black;
      bool isAnchorFill = xPopBean?.isAnchorFill??true;
      var anchorSize = xPopBean?.anchorSize ??[10,10];

      num centerPX = offset.dx + anSrcWidth/2;
      num startTranX = centerPX - anchorSize[0]/2;
      num endTranX = centerPX+ anchorSize[0]/2;
      Path path = Path();
      path..moveTo(startTranX, startY + marginTop + anchorHeight)..lineTo(centerPX,  startY + marginTop +anchorHeight - anchorHeight);
      path..lineTo(endTranX, startY + marginTop + anchorHeight);
      path.close();
      if(isAnchorFill){
        path.close();
      }
      canvas.drawPath(
          path,
          paint
            ..color = anchorColor..strokeWidth = 1.0
            ..style = isAnchorFill?PaintingStyle.fill:PaintingStyle.stroke);

      canvas.drawRRect(
          RRect.fromLTRBXY(xPopBean.marginLeft??40, startY + marginTop + anchorHeight-1 , MediaQuery.of(context).size.width - (xPopBean.marginRight??40), startY + marginTop + contentHeight +anchorHeight, xPopBean?.radiusX??8, xPopBean?.radiusY??8),
          paint..color = contentColor..strokeWidth = 1.0..style = mode);


      paint.blendMode = BlendMode.srcOut;
      if(!(xPopBean.isContentFill??true)){
        Path newPath = Path();
        newPath..moveTo(startTranX+0.5, startY + marginTop + anchorHeight)..lineTo(endTranX-0.5, startY + marginTop + anchorHeight);
        canvas.drawPath(
            newPath,
            paint
              ..color = Colors.transparent..strokeWidth = 1.0
              ..style = isAnchorFill?PaintingStyle.fill:PaintingStyle.stroke);
      }
    }





  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
