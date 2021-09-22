import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BeautyButtonTheme extends StatelessWidget {
  final Color color;
  final Color disableColor;
  final String text;
  final TextStyle textStyle;
  final VoidCallback onPressed;

  BeautyButtonTheme({
    this.color,
    this.disableColor,
    this.text,
    this.textStyle,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: double.infinity,
      height: 50,
      child: FlatButton(
        color: color,
        disabledColor: disableColor,
        onPressed: onPressed,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
