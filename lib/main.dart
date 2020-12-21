import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/calendar/month_task_page.dart';
import 'package:flutter_demox/screens/example/chart/chartpolyline/poly_line_page.dart';
import 'package:flutter_demox/screens/example/chart/demo/poly_line_page_try.dart';
import 'package:flutter_demox/screens/example/recordtop/record_top.dart';
import 'package:flutter_demox/screens/example/tutorial/step_tutorial.dart';
import 'package:flutter_demox/screens/input_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/example/batchdelete/weight_check_history.dart';
import 'screens/example/chart/chartcolumn/step_check_page.dart';
import 'screens/example/dbpage/db_page.dart';
import 'screens/example/dialog/dialog_page.dart';
import 'screens/example/timepicker/weight_record.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja')
  ];

  //重写build方法
  @override
  Widget build(BuildContext context) {
    //返回一个Material风格的组件
    return MaterialApp(
      title: 'Flutter Demo',
      //为了时间选择器增加如此配置
      supportedLocales: supportedLocales,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //创建一个Bar，并添加文本
      appBar: AppBar(
        title: Text(widget.title),
      ),
      //在主体的中间区域，添加Text的文本
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlineButton(
                onPressed: () {
                  _transferToRecordTop();
                },
                child: Text('记录Top Page')),
            OutlineButton(
                onPressed: () {
                  _transferToStepTutorial();
                },
                child: Text('引导页 Page')),
            OutlineButton(
                onPressed: () {
                  _transferToCalendar();
                },
                child: Text('日历 Page')),
            OutlineButton(
                onPressed: () {
                  _transferToDbPage();
                },
                child: Text('Sqlite Page')),
            OutlineButton(
                onPressed: () {
                  _transferToDialog();
                },
                child: Text('Dialog Page')),
            OutlineButton(
                onPressed: () {
                  _transferToColumnChartPage(context);
                },
                child: Text('chart Column Page')),
            OutlineButton(
                onPressed: () {
                  _transferToPolylinePage(context);
                },
                child: Text('chart PolyLine Page')),
            OutlineButton(
                onPressed: () {
                  _transferToWeightRecordPage();
                },
                child: Text('时间选择器 Page')),

            OutlineButton(
                onPressed: () {
                  _transferToWeightCheckHistory();
                },
                child: Text('批量删除 page ')),
            OutlineButton(
                onPressed: () {
                  _transferToPolylinePageTry(context);
                },
                child: Text('chart PolyLine Try Page'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add_alarm),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _incrementCounter() {
    // /**
    //  *   调用 setState() 方法通知 flutter framework 状态发生改变，重新调用 build 方法构建 widget 树，来进行更新操作
    //  */
    // setState(() {
    //   _counter++;
    // });

    Navigator.pushReplacement<MaterialPageRoute, MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => InputPage(), fullscreenDialog: true));
  }

  ///跳转到recordTop
  void _transferToRecordTop() {
    Navigator.pushReplacement<MaterialPageRoute, MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => RecordTop(), fullscreenDialog: true));
  }

  ///跳转到stepTutorial
  void _transferToStepTutorial() {
    Navigator.pushReplacement<MaterialPageRoute, MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => StepTutorial(), fullscreenDialog: true));
  }

  ///跳转到stepTutorial
  void _transferToCalendar() {
    Navigator.pushReplacement<MaterialPageRoute, MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => MonthTaskPage(), fullscreenDialog: true));
  }

  ///跳转到Dialog Page
  void _transferToDbPage() {
    Navigator.pushReplacement<MaterialPageRoute, MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => DbPage(), fullscreenDialog: true));
  }

  ///跳转到Dialog Page
  void _transferToDialog() {
    Navigator.pushReplacement<MaterialPageRoute, MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => DialogPage(), fullscreenDialog: true));
  }

  ///跳转到柱状图Page
  void _transferToColumnChartPage(BuildContext context2) {
    Navigator.pushReplacement<MaterialPageRoute, MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => StepCheckPage(
                  baseContext: context2,
                ),
            fullscreenDialog: true));
  }

  ///跳转到折线图Page
  void _transferToPolylinePage(BuildContext context2) {
    Navigator.pushReplacement<MaterialPageRoute, MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => PolyLinePage(
                  baseContext: context2,
                ),
            fullscreenDialog: true));
  }

  ///跳转到折线图Page
  void _transferToPolylinePageTry(BuildContext context2) {
    Navigator.pushReplacement<MaterialPageRoute, MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => PolyLinePageTry(
                  baseContext: context2,
                ),
            fullscreenDialog: true));
  }

  ///批量删除 Page
  void _transferToWeightCheckHistory() {
    Navigator.pushReplacement<MaterialPageRoute, MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => WeightCheckHistory(), fullscreenDialog: true));
  }

  ///跳转到时间选择器 Page
  void _transferToWeightRecordPage() {
    Navigator.pushReplacement<MaterialPageRoute, MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => WeightRecord(), fullscreenDialog: true));
  }
}
