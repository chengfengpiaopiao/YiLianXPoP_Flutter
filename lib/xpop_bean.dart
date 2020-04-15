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

  XPopBean(this.drawAnchor, this.anchorColor, this.isAnchorFill,
      this.anchorSize, this.drawContentBg, this.contentBg, this.radiusX,
      this.radiusY, this.isContentFill);


}