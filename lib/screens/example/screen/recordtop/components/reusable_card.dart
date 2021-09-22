import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter/material.dart';

///  记录Top画面，复用显示下方的同等小格布局

class ReusableCard extends StatelessWidget {
  ReusableCard({this.cardChild, this.onPress});

  //自定义的子布局属性，便区分
  final Widget cardChild;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: cardChild,
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        decoration: BoxDecoration(
          color: BeautyColors.white01,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
