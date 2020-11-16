import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';

///月份切换动作bar
class MonthViewActionBar extends StatelessWidget {
  final double screenWidth;
  final DateTime showMonth;
  final Function(DateTime month) onDateChangeFn;
  final String Function() getFestivalText;
  final String Function(String) onSaveFn;

  MonthViewActionBar({
    this.screenWidth,
    this.showMonth,
    this.onDateChangeFn,
    this.getFestivalText,
    this.onSaveFn,
  });

  @override
  Widget build(BuildContext context) {
    var lineTitle = <Widget>[];
    lineTitle.add(
      Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: IconButton(
                icon: Image(image: AssetImage('assets/ic_calender_back.png')),
                onPressed: () {
                  var lastMonth = DateTime(
                      showMonth.year, showMonth.month - 1, showMonth.day);
                  if (lastMonth.day != showMonth.day) {
                    lastMonth = DateTime(showMonth.year, showMonth.month, 0);
                  }
                  onDateChangeFn(lastMonth);
                },
              ),
            ),
            Text(
                '${showMonth.year}年' +
                    ((showMonth.month < 10) ? '  ' : '') +
                    '${showMonth.month}月 ',
                style:
                    Styles.text11.merge(TextStyle(color: BeautyColors.blue01))),
            Container(
              child: IconButton(
                icon: Image(image: AssetImage('assets/ic_calender_next.png')),
                onPressed: () {
                  var nextMonth = DateTime(
                      showMonth.year, showMonth.month + 1, showMonth.day);
                  if (nextMonth.day != showMonth.day) {
                    nextMonth =
                        DateTime(showMonth.year, showMonth.month + 2, 0);
                  }
                  onDateChangeFn(nextMonth);
                },
              ),
            )
          ],
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
          //color: Colors.redAccent,
          ),
      child: FittedBox(
          child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: lineTitle,
          ),
        ],
      )),
    );
  }
}
