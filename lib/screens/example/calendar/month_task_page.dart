import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';

import 'month_view.dart';

class MonthTaskPage extends StatefulWidget {
  MonthTaskPage();

  @override
  State<StatefulWidget> createState() {
    return MonthTaskPageState();
  }
}

class MonthTaskPageState extends State<MonthTaskPage>
    with SingleTickerProviderStateMixin {
  double screenWidth;
  double screenHeight;
  MonthView _monthView;

  MonthTaskPageState() {
    var mediaQuery = MediaQueryData.fromWindow(window);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
    _monthView = MonthView(
      onDateSelectedFn: (selectedDate) {
        //_todoView.setSelectedDate(selectedDate);
      },
      onMonthChangeFn: (showMonth) {
        setState(() {});
      },
    );
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg_A.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            '日历',
            //设置appBar的文本样式
            style: Styles.text10.merge(
              TextStyle(color: BeautyColors.blue01),
            ),
          ),
          leading: Container(
              child: IconButton(
                icon: Image(image: AssetImage('assets/ic_calender_back.png')),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
          actions: <Widget>[
            IconButton(
              icon: Image(image: AssetImage('assets/btn_navi_help.png')),
              onPressed: (){
                print('btnNaviHelp');
              },
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,  //阴影为0
        ),
        body: _monthView,
      ),
    );
  }
}
