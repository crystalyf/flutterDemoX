import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/recordtop/record_top.dart';
import 'package:flutter_demox/screens/example/tutorial/step_tutorial.dart';
import 'package:flutter_demox/screens/input_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  //重写build方法
  @override
  Widget build(BuildContext context) {
    //返回一个Material风格的组件
    return MaterialApp(
      title: 'Flutter Demo',
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
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            OutlineButton(
                onPressed: () {
                  _transferToRecordTop();
                },
                child: Text('记录Top Page')),
            OutlineButton(
                onPressed: () {
                  _transferToStepTutorial();
                },
                child: Text('引导页 Page'))
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
}
