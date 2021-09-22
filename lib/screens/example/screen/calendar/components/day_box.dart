import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';

///每一个日期小格的组件
class DayBox extends StatelessWidget {
  final double screenWidth;
  final DateTime date;
  final bool backgroundGrey;
  final bool isToday;
  final Function(DateTime, bool) onSelectCallback;

  DayBox(this.date, this.screenWidth,
      {this.backgroundGrey = false,
      this.isToday = false,
      this.onSelectCallback});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (true == isToday) {
      backgroundColor = BeautyColors.blue04.withOpacity(0.5);
    } else if (backgroundGrey) {
      backgroundColor = BeautyColors.gray03.withOpacity(0.4);
    }

    return GestureDetector(
      onTap: () {
        if (null != onSelectCallback) {
          onSelectCallback(date, false);
        }
      },
      child: Container(
        //GridView里设置里宽高比，所以不用设大小
        child: Stack(children: [
          // 用一个单独的Container来处理选中时候的效果
          // 如果直接在显示层处理选中效果，点击选中的时候显示内容会有细微的大小变化
          Container(
              decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(width: 0.1, color: Colors.black38),
            borderRadius: BorderRadius.all(Radius.circular(4.0)), //边缘圆角4
          )),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //日期数字
                Container(
                    margin: EdgeInsets.only(top: 10.0),
                    alignment: Alignment.center,
                    child: Text('${date.day}',
                        style: TextStyle(fontSize: 13, color: Colors.black))),
                //心率layout
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Icon(Icons.event_busy,
                              size: screenWidth / 27,
                              //TODO: 一个临时的bool变量
                              color: false ? Colors.orange : Colors.grey)),
                      Container(
                          child: Text('70',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.red)))
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
