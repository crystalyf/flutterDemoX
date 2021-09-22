import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';

///日历画面dialog的时间item复用布局

class ReusableTimeType extends StatefulWidget {
  ReusableTimeType({this.onPress, this.content1, this.content2});

  final void Function() onPress;
  String content1;
  String content2;

  @override
  _ReusableTimeTypeState createState() => _ReusableTimeTypeState();
}

class _ReusableTimeTypeState extends State<ReusableTimeType> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: Container(
          child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(color: BeautyColors.blue01)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            child: Text(widget.content1,
                textAlign: TextAlign.center,
                style:
                    Styles.text6.merge(TextStyle(color: BeautyColors.blue01))),
          ),
          Container(
            child: Text(widget.content2,
                textAlign: TextAlign.center,
                style:
                    Styles.text6.merge(TextStyle(color: BeautyColors.blue02))),
          ),
        ]),
      )),
    );
  }
}
