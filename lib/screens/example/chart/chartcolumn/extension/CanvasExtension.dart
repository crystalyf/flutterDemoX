import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension Draw on ui.Canvas {
  void drawText(
      Offset offset,
      ui.TextStyle textStyle,
      String value, {
        TextAlign textAlign = TextAlign.start,
        double fontSize = 13,
        double maxWidth = 100.0,
        FontWeight fontWeight = FontWeight.normal,
      }) {
    var paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
          textAlign: textAlign, fontSize: fontSize, fontWeight: fontWeight),
    )..pushStyle(textStyle);
    paragraphBuilder.addText(value);
    var pc = ui.ParagraphConstraints(width: maxWidth);
    var textParagraph = paragraphBuilder.build()..layout(pc);
    drawParagraph(textParagraph, offset);
  }

  void drawImageLTWH(
      ui.Image image,
      double left,
      double top,
      Paint paint, {
        double width,
        double height,
      }) {
    drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(left, top, width ?? image.width.toDouble(),
            height ?? image.height.toDouble()),
        paint);
  }
}
