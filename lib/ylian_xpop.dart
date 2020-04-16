import 'dart:ui';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui show TextStyle;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ylian_xpop/xpop_bean.dart';

class YLianXPoP extends StatefulWidget {
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
  num radiusX;
  num radiusY;

  //是否实心
  bool isContentFill;

  //边距
  double marginLeft = 45.0;
  double marginRight = 45.0;

  double strokeWidth = 1.0;
  bool isWidthAll = true;

  num shadowSize;

  //三角形顶部还是底部
  bool isAnchorTop;

  YLianXPoP(this.offset, this.wrapWidget,
      {this.drawAnchor,
      this.anchorColor,
      this.isAnchorFill,
      this.anchorSize,
      this.drawContentBg,
      this.contentBg,
      this.radiusX,
      this.radiusY,
      this.isContentFill,
      this.anSrcWidth,
      this.anSrcHeight,
      this.marginTop,
      this.marginLeft,
      this.marginRight,
      this.strokeWidth,
      this.isWidthAll,this.shadowSize,this.isAnchorTop});

  @override
  State<StatefulWidget> createState() {
    return _TipState();
  }
}

GlobalKey anchorKeyWrap = GlobalKey();

class _TipState extends State<YLianXPoP> {
  Offset offset;
  Widget wrapWidget;
  XPopBean xPopBean;

  @override
  void initState() {
    offset = widget.offset;
    wrapWidget = widget.wrapWidget;
    xPopBean = XPopBean(
        widget.drawAnchor,
        widget.anchorColor,
        widget.isAnchorFill,
        widget.anchorSize,
        widget.drawContentBg,
        widget.contentBg,
        widget.radiusX,
        widget.radiusY,
        widget.isContentFill,
        widget.anSrcWidth,
        widget.anSrcHeight,
        widget.marginTop,
        widget.marginLeft,
        widget.marginRight,
        widget.strokeWidth,
        widget.isWidthAll,widget.shadowSize,widget.isAnchorTop);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widget = new Container(
      key: anchorKeyWrap,
      child: wrapWidget,
    );
    var widgetPainter =
        CustomPaint(painter: _Painter(offset, context, widget, xPopBean));
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child: widgetPainter,
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(
                xPopBean.marginLeft ?? 45,
                offset.dy +
                    (xPopBean?.anSrcHeight ?? 14) +
                    (xPopBean?.marginTop ?? 10) +
                    ((xPopBean?.anchorSize) != null
                        ? xPopBean?.anchorSize[1]
                        : 10),
                xPopBean.marginLeft ?? 45,
                0),
            child: new Stack(
              children: <Widget>[
                Positioned(
                  child: widget,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Painter extends CustomPainter {
  Offset offset;
  Widget wrapWidget;
  BuildContext context;
  XPopBean xPopBean;

  GlobalKey globalKey = GlobalKey();

  _Painter(this.offset, this.context, this.wrapWidget, this.xPopBean);

  @override
  void paint(Canvas canvas, Size size) {
    RenderBox renderBox = anchorKeyWrap.currentContext.findRenderObject();
    var offsetNotUse = renderBox.localToGlobal(Offset.zero);
    final contentWidth = anchorKeyWrap.currentContext.size.width;
    final contentHeight = anchorKeyWrap.currentContext.size.height;
    final windowHeight = MediaQuery.of(context).size.height;

    num marginTop = xPopBean?.marginTop ?? 10;
    num anSrcWidth = xPopBean?.anSrcWidth ?? 14;
    num anSrcHeight = xPopBean?.anSrcHeight ?? 14;
    var anchorSize = xPopBean?.anchorSize ?? [10, 10];

    num anchorHeight =
        (xPopBean?.anchorSize) != null ? xPopBean?.anchorSize[1] : 10;
    num startY = offset.dy + anSrcHeight;
    Color anchorColor = xPopBean?.anchorColor ?? Colors.black;
    Color contentColor = xPopBean.contentBg ?? Colors.black;
    num centerAnchorX = offset.dx + anSrcWidth / 2;
    num startAnchorX = centerAnchorX - anchorSize[0] / 2;
    num endTranX = centerAnchorX + anchorSize[0] / 2;
    num stokeWidth = xPopBean.strokeWidth ?? 1.0;
    num suffix = (xPopBean.isContentFill ?? true) ? stokeWidth : 0;
    num totalWidth = (xPopBean.isWidthAll ?? true)
        ? MediaQuery.of(context).size.width - (xPopBean.marginRight ?? 40)
        : contentWidth + xPopBean.marginLeft;

    num radiusTop = xPopBean.radiusX ?? 8;
    num radiusBtm = xPopBean.radiusY;
    if(radiusBtm == null){
      radiusBtm = xPopBean.radiusX ?? 8;
    }
    num radius = radiusTop;
    num strokeStartX = (xPopBean.marginLeft ?? 40) + radius;
    Paint paint = Paint();
    Path path = Path();
    //内容起点Y
    num drawContentStartY = startY + marginTop + anchorHeight;
    if ((xPopBean.drawContentBg ?? true) &&
        (xPopBean.drawAnchor ?? true) &&
        !(xPopBean.isAnchorFill ?? true) &&
        !(xPopBean.isContentFill ?? true)) {
      paint.color = xPopBean.contentBg??Colors.black;
      paint.style = (xPopBean.isAnchorFill ?? true) ? PaintingStyle.fill : PaintingStyle.stroke;
      paint.strokeWidth = stokeWidth;
      const PI = 3.1415926;
      //绘制左圆弧
      Rect rectLeftArc = Rect.fromCircle(
          center: Offset(
              strokeStartX, (drawContentStartY - suffix) + radiusTop),
          radius: radius);
      canvas.drawArc(rectLeftArc, PI, PI / 2, false, paint);
      Path newPath = Path();
      newPath
        ..moveTo(strokeStartX, drawContentStartY)
        ..lineTo(startAnchorX, drawContentStartY)
        ..lineTo(centerAnchorX, drawContentStartY - anchorHeight)
        ..lineTo(endTranX, drawContentStartY)
        ..lineTo(totalWidth - radiusTop, drawContentStartY);
      Rect rectTopRightArc = Rect.fromCircle(
          center: Offset(
              totalWidth - radiusTop, (drawContentStartY - suffix) + radiusTop),
          radius: radius);
      canvas.drawArc(rectTopRightArc, 3 * PI / 2, PI / 2, false, paint);
      newPath
        ..moveTo(totalWidth, (drawContentStartY - suffix) + radiusTop)
        ..lineTo(
            totalWidth, startY + marginTop + contentHeight + anchorHeight - radiusTop);
      Rect btmRightArc = Rect.fromCircle(
          center: Offset(totalWidth - radiusTop,
              startY + marginTop + contentHeight + anchorHeight - radiusTop),
          radius: radius);
      canvas.drawArc(btmRightArc, 0, PI / 2, false, paint);
      newPath
        ..moveTo(
            totalWidth - radiusTop, startY + marginTop + contentHeight + anchorHeight)
        ..lineTo(
            strokeStartX, startY + marginTop + contentHeight + anchorHeight);
      Rect btmLeftArc = Rect.fromCircle(
          center: Offset(strokeStartX,
              startY + marginTop + contentHeight + anchorHeight - radiusTop),
          radius: radius);
      canvas.drawArc(btmLeftArc, PI / 2, PI / 2, false, paint);
      newPath
        ..moveTo(strokeStartX - radiusTop,
            startY + marginTop + contentHeight + anchorHeight - radiusTop)
        ..lineTo(
            strokeStartX - radiusTop, drawContentStartY - suffix + radiusTop);
      canvas.drawPath(newPath, paint);
    } else {
      if(xPopBean.shadowSize != null && (xPopBean?.drawAnchor ?? true) && xPopBean.drawContentBg ?? true){
        Path shadowPath = new Path();
        num shadowSize =xPopBean.shadowSize??0.0;
        //TODO 圆角
        shadowPath
          ..moveTo((xPopBean.marginLeft ?? 40)-shadowSize, drawContentStartY -2 * shadowSize)
          ..lineTo(strokeStartX-shadowSize, drawContentStartY-2 * shadowSize)
          ..lineTo(startAnchorX-shadowSize, drawContentStartY-2 * shadowSize)
          ..lineTo(centerAnchorX, drawContentStartY -anchorHeight-2 * shadowSize)
          ..lineTo(endTranX+shadowSize, drawContentStartY-2 * shadowSize)
          ..close()
          ..lineTo(totalWidth + shadowSize, drawContentStartY-2 * shadowSize)
          ..lineTo(
              totalWidth+ shadowSize, startY + marginTop + contentHeight + anchorHeight)..lineTo((xPopBean.marginLeft ?? 40)-shadowSize,
            startY + marginTop + contentHeight + anchorHeight)..lineTo((xPopBean.marginLeft ?? 40)-shadowSize, drawContentStartY - suffix )..close();
        canvas.drawShadow(shadowPath, Colors.blue, shadowSize, false);
      }
      //绘制三角形
      if (xPopBean?.drawAnchor ?? true) {
        num anchorRealY = drawContentStartY;
        if(xPopBean.isAnchorTop == null){
          xPopBean.isAnchorTop = true;
        }
        /*
        print(windowHeight - offset.dy );
        print(windowHeight - offset.dy  < marginTop + anchorHeight + contentHeight);
        if(xPopBean.isAnchorTop){
          if( windowHeight - offset.dy  < marginTop + anchorHeight + contentHeight){
            xPopBean.isAnchorTop = false;
            anchorRealY = startY - marginTop - anchorHeight;
          }
        }else{
          if(marginTop + anchorHeight + contentHeight <  offset.dy ){
            xPopBean.isAnchorTop = true;
          }
        }
        if(xPopBean.isAnchorTop == null){
          xPopBean.isAnchorTop = true;
        }
         */
        if((!xPopBean.isAnchorTop)){
          anchorRealY = startY + marginTop + contentHeight + anchorHeight;
        }
        bool isAnchorFill = xPopBean?.isAnchorFill ?? true;
        path
          ..moveTo(startAnchorX, anchorRealY)
          ..lineTo(centerAnchorX, xPopBean.isAnchorTop ? (anchorRealY - anchorHeight) : (anchorRealY + anchorHeight));
        path..lineTo(endTranX, anchorRealY);
        if (isAnchorFill) {
          path.close();
        }
        canvas.drawPath(
            path,
            paint
              ..color = anchorColor
              ..strokeWidth = stokeWidth
              ..style =
                  isAnchorFill ? PaintingStyle.fill : PaintingStyle.stroke);
      }

      if (xPopBean.drawContentBg ?? true) {
        canvas.drawRRect(
            RRect.fromLTRBXY(
                xPopBean.marginLeft ?? 40,
                drawContentStartY - suffix,
                totalWidth,
                startY + marginTop + contentHeight + anchorHeight,
                xPopBean?.radiusX ?? 8,
                xPopBean?.radiusY ?? 8),
            paint
              ..color = contentColor
              ..strokeWidth = stokeWidth
              ..style = (xPopBean?.isContentFill ?? true) ? PaintingStyle.fill : PaintingStyle.stroke);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
