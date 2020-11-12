import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        width: screenWidth * 7 / 10,
        child: Text(
          "${showMonth.year}年" +
              ((showMonth.month < 10) ? "  " : "") +
              "${showMonth.month}月 " +
              ((showMonth.day < 10) ? " " : "") +
              "${showMonth.day}日",
          style: TextStyle(fontSize: screenWidth / 15, color: Colors.black),
        ),
      ),
    );

    var lineAction = <Widget>[];
    lineAction.add(
      Container(
        //color: Colors.orange,
        child: RaisedButton(
          color: Colors.cyan,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(child: Icon(Icons.arrow_back_ios)),
              Text("上一月", style: TextStyle(fontSize: screenWidth / 25)),
            ],
          ),
          onPressed: () {
            var lastMonth =
                DateTime(showMonth.year, showMonth.month - 1, showMonth.day);
            if (lastMonth.day != showMonth.day) {
              lastMonth = DateTime(showMonth.year, showMonth.month, 0);
            }

            onDateChangeFn(lastMonth);
          },
        ),
      ),
    );
    lineAction.add(SizedBox(width: screenWidth / 500));
    lineAction.add(
      Container(
//        color: Colors.orange,
        child: RaisedButton(
          color: Colors.cyan,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text("下一月", style: TextStyle(fontSize: screenWidth / 25)),
            Icon(Icons.arrow_forward_ios),
          ]),
          onPressed: () {
            var nextMonth =
                DateTime(showMonth.year, showMonth.month + 1, showMonth.day);
            if (nextMonth.day != showMonth.day) {
              nextMonth = DateTime(showMonth.year, showMonth.month + 2, 0);
            }
            onDateChangeFn(nextMonth);
          },
        ),
      ),
    );

    return FittedBox(
      child: Container(
        width: screenWidth * 8 / 9,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          //color: Colors.redAccent,
          border: Border.all(width: 0.5, color: Colors.black38),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: FittedBox(
            child: Column(
          children: [
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: lineAction),
            ),
            Stack(
              alignment: AlignmentDirectional.center,
              children: lineTitle,
            ),
          ],
        )),
      ),
    );
  }
}
