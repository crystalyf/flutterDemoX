import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demox/screens/example/chart/chartcolumn/extension/CanvasExtension.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';

import 'ImageLoader.dart';

enum ChartLayoutType {
  day,
  week,
  month,
  year,
}

class ColumnData {
  final int mount;
  final String date;

  ColumnData({this.mount = 0, this.date});
}

class CustomChartPaint extends CustomPainter {
  Paint _columnPaint;
  Paint _linePaint;
  Paint _backgroundPaint;
  Paint _imagePaint;

  List<double> graduationText = [0, 500, 1000, 1500, 2000, 2500];

  static const bottomTextTopMargin = 16.0;

  static const bottomTextHeight = 20.0;

  static const bottomTextAreaHeight = 36.0;

  static const outLineWidth = 10;

  static const outOfRangeTopRegionHeight = 22.0;

  static const popTextHeight = 44.0;

  static const Map<int, String> weekBottomText = {
    1: '日',
    2: '月',
    3: '火',
    4: '水',
    5: '木',
    6: '金',
    7: '土'
  };

  static const Map<int, String> dayBottomText = {
    1: '0:00',
    4: '',
    7: '6:00',
    10: '',
    13: '12:00',
    16: '',
    19: '18:00',
    22: ''
  };

  static const Map<int, String> monthBottomText = {
    7: '7日',
    14: '14日',
    21: '21日',
    28: '28日'
  };

  static const Map<int, String> yearBottomText = {
    1: '',
    2: '',
    3: '3月',
    4: '',
    5: '',
    6: '6月',
    7: '',
    8: '',
    9: '9月',
    10: '',
    11: '',
    12: '12月'
  };

  double columnWidth = 22.0;

  double columnPadding = 20.0;

  double columnTopPadding = 20.0;

  double pagePadding = 20.0;

  double rightTextWidth;

  double topGraphHeight;

  BuildContext context;

  ChartLayoutType currentChartLayoutType;

  Rect columnRect;

  ///图片区域的最大相对表示范围。比如总共150步，设置成300，那么柱状图顶部显示为图表的一半位置。设置成600，柱状图顶部显示为图表1/4的位置
  double maxRange = 2500;

  var maxColumnCount = 0;

  ui.RRect columnRoundRect;

  TapDownDetails tabDownloadDetails;

  ui.Image imageCenter;
  ui.Image imageLeft;
  ui.Image imageRight;
  ui.Image imageTriangle;

  List<ColumnData> columnDataList;

  Map<int, String> bottomTextList = {};

  CustomChartPaint(this.context, this.columnDataList,
      {this.currentChartLayoutType = ChartLayoutType.day,
      this.tabDownloadDetails}) {
    var maxStep = 0;
    if (currentChartLayoutType == ChartLayoutType.day) {
      maxRange = 250;
    } else {
      maxRange = 250;
    }
    if (columnDataList != null && columnDataList.isNotEmpty) {
      columnDataList.forEach((element) {
        maxStep = max(element.mount, maxStep);
      });
    }

    while (maxRange < maxStep) {
      maxRange += 250;
    }

    ///纵轴分成6份。
    graduationText = [
      0,
      maxRange / 5.0,
      maxRange / 5 * 2,
      maxRange / 5 * 3,
      maxRange / 5 * 4,
      maxRange
    ];

    initPaint();
    initData();
  }

  void initData() {
    imageCenter = ImageLoader.getInstance().getImage(ImageLoader.markUpCenter);
    imageLeft = ImageLoader.getInstance().getImage(ImageLoader.markUpLeft);
    imageRight = ImageLoader.getInstance().getImage(ImageLoader.markUpRight);
    imageTriangle =
        ImageLoader.getInstance().getImage(ImageLoader.markUpTriangle);
    switch (currentChartLayoutType) {
      case ChartLayoutType.day:
        columnWidth = 7.0;
        pagePadding = 16;
        bottomTextList = dayBottomText;
        maxColumnCount = 24;
        break;
      case ChartLayoutType.week:
        columnWidth = 15.0;
        pagePadding = 28;
        bottomTextList = weekBottomText;
        maxColumnCount = 7;

        break;
      case ChartLayoutType.month:
        columnWidth = 5.0;
        pagePadding = 7;
        bottomTextList = monthBottomText;
        maxColumnCount = 31;

        break;
      case ChartLayoutType.year:
        columnWidth = 13.0;
        pagePadding = 20;
        bottomTextList = yearBottomText;
        maxColumnCount = 12;
        break;
    }
  }

  void initPaint() {
    _columnPaint = Paint()..isAntiAlias = true;
    _linePaint = Paint()..strokeWidth = 1;
    _backgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    _imagePaint = Paint()..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //calculate data we need
    _viewPreCalculate(size);
    //draw black-white area
    _drawBackgroundAndRightText(canvas, size);

    bottomTextList.forEach((key, value) {
      _drawBottomText(canvas, size, key, value);
      _drawVerticalDashLine(canvas, key, value);
    });

    if (columnDataList != null && columnDataList.isNotEmpty) {
      //循环遍历画所有柱状图数据源
      for (var i = 1; i <= columnDataList.length; i++) {
        if (columnDataList[i - 1].mount > 0) {
          _calculateColumnRect(i, size);
          var from = Offset(columnRect.left, columnRect.top);
          var to = Offset(columnRect.right, columnRect.bottom);

          _drawAllColumn(canvas, from, to);

          // tab down action
          if (tabDownloadDetails != null &&
              tabDownloadDetails.localPosition.dx >
                  columnRect.left - columnPadding / 2 &&
              tabDownloadDetails.localPosition.dx <
                  columnRect.right + columnPadding / 2) {
            _drawSelectColumn(canvas, from, to, i);
            _drawPopMessage(canvas, size, i);
          }
        }
      }
    }

    // draw bottom line
    _drawBottomLine(canvas, size);
  }

  void _viewPreCalculate(Size size) {
    rightTextWidth = calculateTextSize(true);
    topGraphHeight = size.height - bottomTextAreaHeight;
    columnPadding = ((size.width - rightTextWidth - 4) -
            2 * pagePadding -
            (maxColumnCount - 1) * columnWidth) /
        (maxColumnCount - 1);
  }

  //计算单条矩形数据的显示位置
  void _calculateColumnRect(int i, Size size) {
    //矩形的左边缘
    var rectLeft =
        pagePadding + columnPadding * (i - 1) + columnWidth * (i - 1);
    //矩形的上边缘
    var rectTop = outOfRangeTopRegionHeight +
        popTextHeight +
        (size.height -
                bottomTextAreaHeight -
                outOfRangeTopRegionHeight -
                popTextHeight) *
            (maxRange - columnDataList[i - 1].mount) /
            maxRange;
    //矩形的右边缘
    var rectRight = pagePadding + columnWidth * i + columnPadding * (i - 1);
    columnRect = Rect.fromLTRB(rectLeft, rectTop, rectRight, topGraphHeight);
  }

  ///画柱状图数据源
  void _drawAllColumn(ui.Canvas canvas, Offset from, Offset to) {
    _columnPaint.shader = ui.Gradient.linear(from, to, [
      BeautyColors.colorColumnBackground1st,
      BeautyColors.colorColumnBackgroundSec,
      BeautyColors.colorColumnBackgroundTrd
    ], [
      0,
      0.5,
      1
    ]);
    _columnPaint.style = PaintingStyle.fill;
    columnRoundRect = RRect.fromRectAndCorners(columnRect,
        topLeft: ui.Radius.circular(10), topRight: Radius.circular(10));
    //画柱状图数据源
    canvas.drawRRect(columnRoundRect, _columnPaint);
    // _columnPaint.shader = ui.Gradient.linear(from, to, [
    //   BeautyColors.colorColumn1st,
    //   BeautyColors.colorColumnSec,
    //   BeautyColors.colorColumnTrd
    // ], [
    //   0,
    //   0.5,
    //   1
    // ]);
    // //绘制渐变效果
    // canvas.drawRRect(columnRoundRect, _columnPaint);
    // _columnPaint.shader = ui.Gradient.linear(
    //     from, to, [BeautyColors.blue01, BeautyColors.blue01]);
    // _columnPaint.style = PaintingStyle.stroke;
    // _columnPaint.strokeWidth = 1.0;
    // //绘制一层border效果
    // canvas.drawRRect(columnRoundRect, _columnPaint);
  }

  void _drawSelectColumn(ui.Canvas canvas, Offset from, Offset to, int i) {
    _columnPaint.shader = ui.Gradient.linear(
        from, to, [BeautyColors.pink01, BeautyColors.pink01]);
    _columnPaint.style = PaintingStyle.fill;
    canvas.drawRRect(columnRoundRect, _columnPaint);
    _columnPaint.style = PaintingStyle.stroke;
    canvas.drawRRect(columnRoundRect, _columnPaint);
    _linePaint.color = BeautyColors.pink01;
    double lineEnd;
    if (bottomTextList[i] != null && bottomTextList[i].isNotEmpty) {
      lineEnd = columnRect.bottom + outLineWidth;
    } else {
      lineEnd = columnRect.bottom;
    }
    canvas.drawLine(
        Offset(
            pagePadding +
                columnWidth * i -
                columnWidth / 2 +
                columnPadding * (i - 1),
            popTextHeight),
        Offset(
            pagePadding +
                columnWidth * i -
                columnWidth / 2 +
                columnPadding * (i - 1),
            lineEnd),
        _linePaint);
  }

  void _drawPopMessage(Canvas canvas, Size size, int i) {
    double messageWidth;
    double messageLeft;
    //todo  not a specific text append method
    var startText = '';
    var stepText = '${columnDataList[i - 1].mount}歩';
    switch (currentChartLayoutType) {
      case ChartLayoutType.day:
        startText = '$i:00 ~ ${i + 1}:00';
        break;
      case ChartLayoutType.week:
        startText = columnDataList[i - 1].date;
        break;
      case ChartLayoutType.month:
        startText = columnDataList[i - 1].date;
        break;
      case ChartLayoutType.year:
        startText = '$i月';
        break;
    }

    var startTextWidth =
        calculateTextSize(true, fontSize: 14, value: startText);
    var startTextHeight =
        calculateTextSize(false, fontSize: 14, value: startText);
    var stepTextWidth = calculateTextSize(true,
        fontSize: 14, fontWeight: FontWeight.bold, value: stepText);
    var stepTextHeight = calculateTextSize(false,
        fontSize: 14, fontWeight: FontWeight.bold, value: stepText);
    messageWidth = startTextWidth + stepTextWidth + 2 * 6 + 8;

    if (pagePadding +
            columnWidth * i -
            columnWidth / 2 +
            columnPadding * (i - 1) <=
        (messageWidth + 12) / 2) {
      messageLeft = 0;
    } else if (pagePadding +
            columnWidth * i -
            columnWidth / 2 +
            columnPadding * (i - 1) >=
        size.width - (messageWidth + 12) / 2) {
      messageLeft = size.width - (messageWidth + 12);
    } else {
      messageLeft = pagePadding +
          columnWidth * i -
          columnWidth / 2 +
          columnPadding * (i - 1) -
          messageWidth / 2 -
          6;
    }

    if (imageCenter != null) {
      canvas.drawImageRect(
          imageCenter,
          Rect.fromLTWH(0, 0, imageCenter.width.toDouble(),
              imageCenter.height.toDouble()),
          Rect.fromLTWH(messageLeft + 6, 0, messageWidth, 34),
          _imagePaint);
    }

    if (imageLeft != null) {
      canvas.drawImageLTWH(imageLeft, messageLeft, 0, _imagePaint,
          width: 6, height: 34);
    }

    if (imageRight != null) {
      canvas.drawImageLTWH(
          imageRight, messageLeft + messageWidth + 6, 0, _imagePaint,
          width: 6, height: 34);
    }

    if (imageTriangle != null) {
      canvas.drawImageLTWH(
          imageTriangle,
          pagePadding +
              columnWidth * i -
              columnWidth / 2 +
              columnPadding * (i - 1) -
              5,
          32,
          _imagePaint,
          width: 10,
          height: 8);
    }

    var textXOffSet = messageLeft + 6 + 6;
    var textYOffset = (34 - startTextHeight) / 2;
    var leftTextOffset = Offset(textXOffSet, textYOffset);

    canvas.drawText(
      leftTextOffset,
      ui.TextStyle(color: BeautyColors.gray02),
      startText,
      fontSize: 14,
      maxWidth: startTextWidth,
    );

    var stepTextXOffSet = messageLeft + 6 + 6 + startTextWidth + 8;
    var stepTextYOffset = (34 - stepTextHeight) / 2;
    var stepTextOffset = Offset(stepTextXOffSet, stepTextYOffset);

    canvas.drawText(
      stepTextOffset,
      ui.TextStyle(color: BeautyColors.gray02),
      stepText,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      maxWidth: stepTextWidth,
    );
  }

  double calculateTextSize(bool isWidth,
      {double maxWidth = 200,
      double fontSize = 13,
      String value = '12345',
      FontWeight fontWeight = FontWeight.normal,
      int maxLines = 1}) {
    var painter = TextPainter(
        locale: Localizations.localeOf(context, nullOk: true),
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            )));
    painter.layout(maxWidth: maxWidth);
    if (isWidth) {
      return painter.width;
    } else {
      return painter.height;
    }
  }

  ///绘制背景的长条灰色矩形
  void _drawBackgroundAndRightText(Canvas canvas, Size size) {
    var backgroundHeight =
        (topGraphHeight - outOfRangeTopRegionHeight - popTextHeight) / 5;
    _backgroundPaint.color = BeautyColors.gray04;
    for (var n = 1; n <= 5; n++) {
      n % 2 == 1
          ? _backgroundPaint.color = BeautyColors.gray04
          : _backgroundPaint.color = BeautyColors.white01;
      // 使用 drawRect 方法绘制背景的长条灰色矩形
      canvas.drawRect(
          Rect.fromLTRB(
              0,
              topGraphHeight - backgroundHeight * n,
              size.width - rightTextWidth - 4,
              topGraphHeight - backgroundHeight * (n - 1)),
          _backgroundPaint);
    }

    var wordsHeight = calculateTextSize(false);
    for (var n = 1; n <= 6; n++) {
      var textXOffSet = size.width - rightTextWidth;
      var textYOffset = size.height -
          bottomTextHeight -
          bottomTextTopMargin -
          backgroundHeight * (n - 1) -
          wordsHeight / 2;
      var rightTextOffset = Offset(textXOffSet, textYOffset);
      //绘制纵轴（Y轴）文字
      canvas.drawText(rightTextOffset, ui.TextStyle(color: BeautyColors.gray02),
          graduationText[n - 1].toString(),
          maxWidth: rightTextWidth, fontWeight: FontWeight.normal);
    }
  }

  ///绘制横轴（X轴）文字
  void _drawBottomText(Canvas canvas, Size size, int key, String value) {
    var bottomTextWidth =
        calculateTextSize(true, value: value, fontWeight: FontWeight.bold);
    var textHalfWidth = (bottomTextWidth / 2);
    var textXOffSet = pagePadding +
        columnPadding * (key - 1) +
        columnWidth * (key - 1) +
        columnWidth / 2 -
        textHalfWidth;
    var bottomTextOffset = Offset(textXOffSet, size.height - bottomTextHeight);
    //绘制横轴文字
    canvas.drawText(
        bottomTextOffset, ui.TextStyle(color: BeautyColors.blue01), value,
        fontWeight: FontWeight.bold,
        textAlign: TextAlign.center,
        maxWidth: bottomTextWidth);
  }

  void _drawVerticalDashLine(ui.Canvas canvas, int key, String value) {
    _linePaint.color = BeautyColors.colorChartDash;
    double dashLineHeight;
    if (value != null && value.isNotEmpty) {
      dashLineHeight = topGraphHeight + outLineWidth;
    } else {
      dashLineHeight = topGraphHeight;
    }

    var dashWidth = 2;
    var dashSpace = 1;
    var startY = popTextHeight;
    final space = (dashSpace + dashWidth);

    while (startY < dashLineHeight) {
      canvas.drawLine(
          Offset(
              pagePadding +
                  columnWidth * key -
                  columnWidth / 2 +
                  columnPadding * (key - 1),
              startY),
          Offset(
              pagePadding +
                  columnWidth * key -
                  columnWidth / 2 +
                  columnPadding * (key - 1),
              startY + dashWidth),
          _linePaint);
      startY += space;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void _drawBottomLine(ui.Canvas canvas, ui.Size size) {
    var start = ui.Offset(0, topGraphHeight);
    var end = ui.Offset(
        size.width - rightTextWidth - 4, size.height - bottomTextAreaHeight);
    _linePaint.color = BeautyColors.blue01;
    canvas.drawLine(start, end, _linePaint);
  }
}
