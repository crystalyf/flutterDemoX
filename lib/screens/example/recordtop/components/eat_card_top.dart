import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';

///  eat top layout (界面最上端的layout)
class EatCardTop extends StatelessWidget {
  EatCardTop({this.cardChild, this.onPress});

  final Widget cardChild;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: cardChild,
        decoration: BoxDecoration(
          color: BeautyColors.white01,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
