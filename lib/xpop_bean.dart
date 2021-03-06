import 'package:flutter/material.dart';

class XPopBean{
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

  //src锚点大小
  num anSrcWidth = 14;
  num anSrcHeight = 14;
  num marginTop = 10;

  //左右边距
  double marginLeft ;
  double marginRight;

  //画笔大小
  double strokeWidth = 1.0;

  //是否是全屏
  bool isWidthAll = true;

  //阴影大小
  num shadowSize;

  //三角形顶部还是底部
  bool isAnchorTop;

  XPopBean(this.drawAnchor, this.anchorColor, this.isAnchorFill,
      this.anchorSize, this.drawContentBg, this.contentBg, this.radiusX,
      this.radiusY, this.isContentFill, this.anSrcWidth, this.anSrcHeight,
      this.marginTop,this.marginLeft,this.marginRight,this.strokeWidth,this.isWidthAll,this.shadowSize,this.isAnchorTop);


}