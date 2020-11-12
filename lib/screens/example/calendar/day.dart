import 'package:flutter/material.dart';

class DayBox extends StatelessWidget {
  final double screenWidth;
  final DateTime date;
  final bool showNoteIcon;
  final bool noteActive;
  final bool selected;
  final bool baskgroundGrey;
  final bool isToday;
  final List<TextSpan> gregorianStrs;
  final List<TextSpan> lunarStrs;
  final Function(DateTime, bool) onSelectCallback;

  DayBox(this.date, this.screenWidth,
      {this.showNoteIcon = false,
      this.noteActive = true,
      this.selected = false,
      this.baskgroundGrey = false,
      this.isToday = false,
      this.gregorianStrs,
      this.lunarStrs,
      this.onSelectCallback});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (true == isToday) {
      backgroundColor = selected ? Colors.yellowAccent : Colors.yellow;
    } else if (baskgroundGrey) {
      backgroundColor = Colors.grey[300];
    }

    return GestureDetector(
      onTap: () {
        if (null != onSelectCallback) {
          onSelectCallback(date, !selected);
        }
      },
      child: Container(
        //每个日期单元格,因为有border,所以在整数7的基础上多除0.2,留有余地。
        width: screenWidth / 7.2,
        height: 95,
        child: Stack(children: [
          // 用一个单独的Container来处理选中时候的效果
          // 如果直接在显示层处理选中效果，点击选中的时候显示内容会有细微的大小变化
          Container(
              decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
                width: selected ? 2.0 : 0.1,
                color: selected ? Colors.red : Colors.black38),
            borderRadius: BorderRadius.all(Radius.circular(4.0)), //边缘圆角4
          )),
          Container(
            //每个日期单元格
            width: 55,
            height: 95,
            // child: Stack(children: stackChildren)
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //日期数字
                Container(
                    margin: EdgeInsets.only(top: 10.0),
                    alignment: Alignment.center,
                    child: Text("${date.day}",
                        style: new TextStyle(
                            fontSize: screenWidth / 20, color: Colors.black))),
                //kcal icon
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Icon(Icons.event_note,
                              size: screenWidth / 27,
                              color: noteActive ? Colors.orange : Colors.grey)),
                      Container(
                          child: Text('70',
                              style: new TextStyle(
                                  fontSize: 20, color: Colors.red)))
                    ],
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}

// class TitleDay extends StatelessWidget {
//   final double screenWidth;
//
//   TitleDay(this.num, this.screenWidth)
//       : assert(1 <= num),
//         assert(num <= 7);
//   final int num;
//
//   final List<String> _weekDayName = ["日", "月", "火", "水", "木", "金", "土"];
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: screenWidth / 8,
//       height: screenWidth / 8 / 10 * 6,
//       decoration: BoxDecoration(
//         color: Colors.blue[300],
//         border: Border.all(width: 0.5, color: Colors.black38),
//         borderRadius: BorderRadius.all(Radius.circular(6.0)),
//       ),
//       child: Center(
//         child: FittedBox(
//           child: Text(
//             _weekDayName[num - 1],
//             style: TextStyle(fontSize: screenWidth / 20, color: Colors.black),
//           ),
//         ),
//       ),
//     );
//   }
// }
