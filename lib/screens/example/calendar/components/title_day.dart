import 'package:flutter/material.dart';

class TitleDay extends StatelessWidget {
  final double screenWidth;

  TitleDay(this.num, this.screenWidth)
      : assert(1 <= num),
        assert(num <= 7);
  final int num;

  final List<String> _weekDayName = ['日', '月', '火', '水', '木', '金', '土'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth / 8,
      height: screenWidth / 8 / 10 * 6,
      child: Center(
        child: FittedBox(
          child: Text(
            _weekDayName[num - 1],
            style: TextStyle(fontSize: 13, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
