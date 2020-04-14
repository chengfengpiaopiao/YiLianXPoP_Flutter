import 'dart:ui';

import 'dart:ui' as ui show TextStyle;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YLianXPopview extends StatefulWidget{

  Offset offset;
  String content;
  num srcX;
  num srcY;

  YLianXPopview(this.offset,this.content,this.srcX,this.srcY);

  @override
  State<StatefulWidget> createState() {
    return _TipState();
  }
}

class _TipState extends State<YLianXPopview>{
  Offset offset;
  String content;
  num srcX;
  num srcY;
  final GlobalKey paintKey = GlobalKey();

  @override
  void initState() {
    offset = widget.offset;
    content = widget.content;
    srcX = widget.srcX;
    srcY = widget.srcY;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child:  CustomPaint(
              key: paintKey,
              painter: _Painter(offset,context,content,srcX,srcY),
            ),
          ),
        ],
      ),
    );
  }

}

class _Painter extends CustomPainter {
  Offset offset;
  String content;
  num srcX;
  num srcY;
  BuildContext context;

  _Painter(this.offset,this.context,this.content,this.srcX,this.srcY);

  @override
  void paint(Canvas canvas, Size size) {
    num startY = offset.dy + srcY + 15;
    ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.center,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      fontSize: 12,
    ))
      ..pushStyle(ui.TextStyle(color: Colors.black))
      ..addText(
          content);
    ParagraphConstraints pc = ParagraphConstraints(width: MediaQuery.of(context).size.width - 2 * 50);
    Paragraph paragraph = pb.build()..layout(pc);
    canvas.drawParagraph(paragraph, Offset(50, startY));

    print(paragraph.height);

    canvas.drawRRect(
        RRect.fromLTRBXY(40, startY, MediaQuery.of(context).size.width-40, startY + paragraph.height + 10, 8.0, 8.0),
        Paint()..color = Colors.black..strokeWidth = 4.0..style = PaintingStyle.fill);


    num startTranX = offset.dx + srcX - 2.5;
    num endTranX = offset.dx + srcX + 2.5;
    num tranY = startY - 5;
    canvas.drawPath(
        Path()
          ..moveTo(startTranX, startY)..lineTo(offset.dx + srcX, tranY)
          ..lineTo(endTranX, startY)
          ..close(),
        Paint()
          ..color = Colors.black..strokeWidth = 1.0
          ..style = PaintingStyle.fill);
    _createTxt(canvas,startY);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  num _createTxt(Canvas canvas ,num startY){
    //计算文字高度大小
    ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.left,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      fontSize: 12,
    ))
      ..pushStyle(ui.TextStyle(color: Colors.white))
      ..addText(
          content);
    ParagraphConstraints pc = ParagraphConstraints(width: MediaQuery.of(context).size.width - 2 * 50);
    Paragraph paragraph = pb.build()..layout(pc);
    canvas.drawParagraph(paragraph, Offset(50, startY+5));
    print(paragraph.height.toString());
    return paragraph.height;
  }
}
