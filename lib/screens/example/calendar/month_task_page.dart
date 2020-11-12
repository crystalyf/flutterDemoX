import 'dart:ui';

import 'package:flutter/material.dart';

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
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
    _monthView = MonthView(
      onDateSelectedFn: (DateTime selectedDate) {
        //_todoView.setSelectedDate(selectedDate);
      },
      onMonthChangeFn: (DateTime showMonth) {},
      initDate: null,
    );
  }

  @override
  initState() {
    super.initState();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: _monthView,
    );
  }
}
