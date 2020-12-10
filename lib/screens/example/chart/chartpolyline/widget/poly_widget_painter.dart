import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demox/screens/example/chart/chartcolumn/extension/CanvasExtension.dart';
import 'package:flutter_demox/screens/example/chart/chartcolumn/widget/ImageLoader.dart';
import 'package:flutter_demox/screens/example/chart/chartpolyline/weight_top_view_model.dart';
import 'package:flutter_demox/screens/example/chart/chartpolyline/widget/poly_line_data.dart';
import 'package:flutter_demox/screens/example/chart/chartpolyline/widget/poly_type_enum.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';

class PolyWidgetPainter extends CustomPainter {
  Paint _linePaint;
  Paint _backgroundPaint;
  Paint _imagePaint;

  static const bottomTextTopMargin = 16.0;

  static const bottomTextHeight = 20.0;

  static const bottomTextAreaHeight = 36.0;

  static const outLineWidth = 10;

  static const outOfRangeTopRegionHeight = 22.0;

  static const popTextHeight = 44.0;

  //Y轴默认的6份默认值
  List<double> yText = [0, 500, 1000, 1500, 2000, 2500];

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

  PolyLayoutType currentPolyLayoutType;

  Rect columnRect;

  ///图片区域的最大相对表示范围。比如总共150步，设置成300，那么柱状图顶部显示为图表的一半位置。设置成600，柱状图顶部显示为图表1/4的位置
  double maxRange = 150;
  var maxWeightValue = 0.0;
  var minWeightValue = 0.0;

  var maxColumnCount = 0;

  ui.RRect columnRoundRect;

  TapDownDetails tapDownDetails;

  ui.Image imageCenter;
  ui.Image imageLeft;
  ui.Image imageRight;
  ui.Image imageTriangle;

  List<PolyLineData> polyDataList;

  Map<int, String> bottomTextList = {};

  WeightTopViewModel weightTopViewModel;

  PolyWidgetPainter(this.context, this.polyDataList,
      {this.currentPolyLayoutType = PolyLayoutType.week,
      this.tapDownDetails,
      this.weightTopViewModel}) {
    if (polyDataList.isNotEmpty && polyDataList.length > 1) {
      minWeightValue = polyDataList[0].mount;
      polyDataList.forEach((element) {
        if (element.mount > maxWeightValue) {
          maxWeightValue = element.mount;
        }
        if (element.mount < minWeightValue) {
          minWeightValue = element.mount;
        }
      });
    }
    setYTextValues();
    initPaint();
    initData();
  }

  ///设置Y轴刻度
  // ignore: slash_for_doc_comments
  /**
   * 如果体重记录只有一个数据：
   * 那么最开始绘制的时候，将数据画在第二段，以这个数据的值作为第二段的刻度，并且上下依次+0.5绘制完整个的Y轴刻度。

      如果体重记录有多个数据：
      那么顶让3，底让2，以数据源最小值为底让2为最小刻度值，以数据源最大值为顶让3为最大刻度值。

   */
  void setYTextValues() {
    if (polyDataList.length == 1) {
      yText = [
        polyDataList[0].mount - 0.5,
        polyDataList[0].mount,
        polyDataList[0].mount + 0.5,
        polyDataList[0].mount + 1,
        polyDataList[0].mount + 1.5,
        polyDataList[0].mount + 2
      ];
    } else if (polyDataList.length > 1) {
      var yScale = (maxWeightValue - minWeightValue + 5.0) / 5;
      yText = [
        minWeightValue - 2.0,
        minWeightValue - 2.0 + yScale,
        minWeightValue - 2.0 + yScale * 2,
        minWeightValue - 2.0 + yScale * 3,
        minWeightValue - 2.0 + yScale * 4,
        minWeightValue - 2.0 + yScale * 5
      ];
    }
  }

  void initData() {
    imageCenter = ImageLoader.getInstance().getImage(ImageLoader.markUpCenter);
    imageLeft = ImageLoader.getInstance().getImage(ImageLoader.markUpLeft);
    imageRight = ImageLoader.getInstance().getImage(ImageLoader.markUpRight);
    imageTriangle =
        ImageLoader.getInstance().getImage(ImageLoader.markUpTriangle);
    switch (currentPolyLayoutType) {
      case PolyLayoutType.week:
        //日图被分成了7份
        columnWidth = 15.0;
        pagePadding = 28;
        bottomTextList = weekBottomText;
        maxColumnCount = 7;

        break;
      case PolyLayoutType.month:
        //月图设置成了31份
        columnWidth = 5.0;
        pagePadding = 7;
        bottomTextList = monthBottomText;
        maxColumnCount = 31;

        break;
      case PolyLayoutType.year:
        //年图设置成了12份
        columnWidth = 13.0;
        pagePadding = 20;
        bottomTextList = yearBottomText;
        maxColumnCount = 12;
        break;
    }
  }

  void initPaint() {
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

    if (polyDataList != null && polyDataList.isNotEmpty) {
      //循环遍历画所有折线图数据源
      for (var i = 1; i <= maxColumnCount; i++) {
        _calculateColumnRect(i, size);
        var from = Offset(columnRect.left, columnRect.top);
        var to = Offset(columnRect.right, columnRect.bottom);
        // tap down action
        if (tapDownDetails != null &&
            tapDownDetails.localPosition.dx >
                columnRect.left - columnPadding / 2 &&
            tapDownDetails.localPosition.dx <
                columnRect.right + columnPadding / 2) {
          _drawSelectColumn(canvas, from, to, i);
          _drawPopMessage(canvas, from, to, size, i);
        }
      }
      //i=1画第一个折线
      _drawAllPoly(canvas);
      //画所有的点
      _drawAllPoint(canvas);
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

  List<Rect> calculatedRectList = [];

  //计算单条矩形数据的显示位置,i=1传的是第一柱。
  void _calculateColumnRect(int i, Size size) {
    //矩形的左边缘
    var rectLeft =
        pagePadding + columnPadding * (i - 1) + columnWidth * (i - 1);
    //矩形的右边缘
    var rectRight = pagePadding + columnWidth * i + columnPadding * (i - 1);

    //矩形的上边缘
    ///(size.height -bottomTextAreaHeight - outOfRangeTopRegionHeight -popTextHeight)是网格背景的高度
    /// (maxRange - polyDataList[i - 1].mount) /maxRange是圆点纵向高度占背景的高度比例。
    //月,年都是从1开始（1日，1月），唯独周的开始不一定
    var rectTop = outOfRangeTopRegionHeight + popTextHeight;
    if (currentPolyLayoutType == PolyLayoutType.week) {
      polyDataList.forEach((pointData) {
        var tempIndex = int.parse(pointData.date.split(".")[1]) -
            weightTopViewModel.weightSundayDateTime.day;
        if (tempIndex == i - 1) {
          rectTop = outOfRangeTopRegionHeight +
              popTextHeight + //+点构成的柱高
              (size.height -
                      bottomTextAreaHeight -
                      outOfRangeTopRegionHeight -
                      popTextHeight) *
                  (1 -
                      (pointData.mount - minWeightValue + 2) /
                          (maxWeightValue - minWeightValue + 5));
        }
      });
    } else {
      polyDataList.forEach((pointData) {
        var tempIndex = int.parse(pointData.date.split(".")[1]);
        if (tempIndex == i) {
          rectTop = outOfRangeTopRegionHeight +
              popTextHeight + //+点构成的柱高
              (size.height -
                      bottomTextAreaHeight -
                      outOfRangeTopRegionHeight -
                      popTextHeight) *
                  (pointData.mount - minWeightValue + 2) /
                  (maxWeightValue - minWeightValue + 5);
        }
      });
    }
    columnRect = Rect.fromLTRB(rectLeft, rectTop, rectRight, topGraphHeight);
    calculatedRectList.add(columnRect);
    //去重
    calculatedRectList = calculatedRectList.toSet().toList();
  }

  ///画柱状图数据源
  void _drawAllPoly(ui.Canvas canvas) {
    Paint _linePaint = new Paint()
      ..color = BeautyColors.pink01
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    var resultList = [];
    resultList = calculatedRectList.where((item) => item.top != 66).toList();
    for (int index = 0; index < resultList.length - 1; index++)
      canvas.drawLine(
          Offset(
              resultList[index].right -
                  (resultList[index].right - resultList[index].left) / 2,
              resultList[index].top),
          Offset(
              resultList[index + 1].right -
                  (resultList[index + 1].right - resultList[index + 1].left) /
                      2,
              resultList[index + 1].top),
          _linePaint);
  }

  void _drawAllPoint(ui.Canvas canvas) {
    //带边缘的圆
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..color = BeautyColors.pink01
      ..invertColors = false;
    //实心白色圆
    var paint2 = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill
      ..color = BeautyColors.white01
      ..invertColors = false;

    int dayOffset = 1;
    if (currentPolyLayoutType == PolyLayoutType.week) {
      dayOffset = weightTopViewModel.weightSundayDateTime.day;
    }
    //取到的这个天数，就是第一个X轴第一个圆点可以画的起始index,等同于index 0
    polyDataList.forEach((pointData) {
      var tempIndex = int.parse(pointData.date.split(".")[1]) - dayOffset;
      var rect = calculatedRectList[tempIndex];
      pointData.showOnXLineIndex = tempIndex;
      //画柱状图数据源，参数是：offset(左，上)，半径，画笔
      canvas.drawCircle(
          Offset(rect.right - (rect.right - rect.left) / 2, rect.top),
          6,
          paint);
      canvas.drawCircle(
          Offset(rect.right - (rect.right - rect.left) / 2, rect.top),
          5,
          paint2);
    });
  }

  void _drawSelectColumn(ui.Canvas canvas, Offset from, Offset to, int i) {
    _linePaint.color = BeautyColors.pink01;
    double lineEnd;
    if (bottomTextList[i] != null && bottomTextList[i].isNotEmpty) {
      lineEnd = columnRect.bottom + outLineWidth;
    } else {
      lineEnd = columnRect.bottom;
    }
    if (calculatedRectList.isNotEmpty) {
      calculatedRectList.forEach((element) {
        if (element.left == from.dx &&
            element.right == to.dx &&
            from.dy != 66) {
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
      });
    }
  }

  void _drawPopMessage(
      Canvas canvas, Offset from, Offset to, Size size, int i) {
    if (calculatedRectList.isNotEmpty && polyDataList.isNotEmpty) {
      calculatedRectList.forEach((element) {
        if (element.left == from.dx &&
            element.right == to.dx &&
            from.dy != 66) {
          double messageWidth;
          double messageLeft;
          var target = polyDataList
              .where((element) => element.showOnXLineIndex == i - 1)
              .first;
          var startText = '';
          if (target != null) {
            var stepText = '${target.mount}kg';
            switch (currentPolyLayoutType) {
              case PolyLayoutType.week:
                startText = int.parse(target.date.split('.')[0]).toString() +
                    '月' +
                    int.parse(target.date.split('.')[1]).toString() +
                    '日';
                break;
              case PolyLayoutType.month:
                startText = int.parse(target.date.split('.')[0]).toString() +
                    '月' +
                    int.parse(target.date.split('.')[1]).toString() +
                    '日';
                break;
              case PolyLayoutType.year:
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
        }
      });
    }
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
          yText[n - 1].toString(),
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
