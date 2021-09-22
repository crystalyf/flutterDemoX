import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PolyLinePageTry extends StatelessWidget {
  final BuildContext baseContext;

  PolyLinePageTry({this.baseContext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("chart_flutter")),
      body: ListView(
        children: [
          Container(height: 200, child: _simpleLine()),
          Container(height: 200, child: _simplePie()),
          Container(height: 200, child: _simpleNull()),
        ],
      ),
    );
  }

  /*
    折线图-添加圆点/区域LineRendererConfig
 */
  Widget _simpleLine() {
    var random = Random();

    var data = [
      LinearSales(0, random.nextInt(100)),
      LinearSales(1, random.nextInt(100)),
      LinearSales(2, random.nextInt(100)),
      LinearSales(3, random.nextInt(100)),
    ];

    var seriesList = [
      charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];

    return charts.LineChart(
      seriesList,
      animate: false,
      defaultRenderer: charts.LineRendererConfig(
        // 圆点大小
        radiusPx: 5.0,
        stacked: false,
        // 线的宽度
        strokeWidthPx: 2.0,
        // 是否显示线
        includeLine: true,
        // 是否显示圆点
        includePoints: true,
        // 是否显示包含区域
        includeArea: false,
        // 区域颜色透明度 0.0-1.0
        areaOpacity: 0.0,
      ),
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: _onSelectionChanged,
        )
      ],
    );
  }

  /* 折线图 点击方法  通过 X轴下标 判断显示*/
  void _onSelectionChanged(charts.SelectionModel model) {
    var datum = model.selectedDatum[0];
    print('点击了${datum.index}');
  }

// /*
//   饼状图 自定义颜色
// */
  Widget _simplePie() {
    var random = Random();

    var data = [
      PieSales(0, random.nextInt(100),
          charts.ColorUtil.fromDartColor(Color(0xFF126610))),
      PieSales(1, random.nextInt(100),
          charts.ColorUtil.fromDartColor(Color(0xFF522210))),
      PieSales(2, random.nextInt(100),
          charts.ColorUtil.fromDartColor(Color(0xFF929910))),
      PieSales(3, random.nextInt(100),
          charts.ColorUtil.fromDartColor(Color(0xFFD26699))),
    ];

    var seriesList = [
      charts.Series<PieSales, int>(
        id: 'Sales',
        domainFn: (PieSales sales, _) => sales.year,
        measureFn: (PieSales sales, _) => sales.sales,
        colorFn: (PieSales sales, _) => sales.color,
        data: data,
        labelAccessorFn: (PieSales row, _) => '${row.year}: ${row.sales}',
      )
    ];

    return charts.PieChart(seriesList,
        animate: true,
        defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.outside)
        ]));
  }

/*
  饼状图-空心显示
*/
  Widget _simpleNull() {
    var random = Random();

    var data = [
      PieSales(0, random.nextInt(100),
          charts.ColorUtil.fromDartColor(Color(0xFF126610))),
      PieSales(1, random.nextInt(100),
          charts.ColorUtil.fromDartColor(Color(0xFF522210))),
      PieSales(2, random.nextInt(100),
          charts.ColorUtil.fromDartColor(Color(0xFF929910))),
      PieSales(3, random.nextInt(100),
          charts.ColorUtil.fromDartColor(Color(0xFFD26699))),
    ];

    var seriesList = [
      charts.Series<PieSales, int>(
        id: 'Sales',
        domainFn: (PieSales sales, _) => sales.year,
        measureFn: (PieSales sales, _) => sales.sales,
        colorFn: (PieSales sales, _) => sales.color,
        data: data,
        labelAccessorFn: (PieSales row, _) => '${row.year}: ${row.sales}',
      )
    ];

    return charts.PieChart(seriesList,
        animate: true,
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 30,
            arcRendererDecorators: [
              new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.outside)
            ]));
  }
}

//折线图-添加圆点/区域LineRendererConfig
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

//饼状图 自定义颜色
class PieSales {
  final int year;
  final int sales;
  final charts.Color color;

  PieSales(this.year, this.sales, this.color);
}
