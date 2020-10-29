import 'package:flutter/material.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Layout组件'),
      ),
      body: Column(
        children: [
          Text("圆角渐变layout:"),
          //圆角渐变layout
          Container(
            width: 300,
            height: 30,
            decoration: BoxDecoration(
              //背景
              image: DecorationImage(
                image: AssetImage('assets/gauge.png'),
                fit: BoxFit.contain,
              ),
            ),
            child: Container(
              //外变局设置
              margin: EdgeInsets.fromLTRB(2, 9, 2, 9),
              decoration: BoxDecoration(
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff61ccde),
                    Color(0x7fD864A8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
