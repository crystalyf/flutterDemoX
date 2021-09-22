import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';

///日历画面dialog的场景item复用布局

class ReusableSceneType extends StatefulWidget {
  ReusableSceneType({this.onPress, this.image, this.content});

  final  Function(String) onPress;
  AssetImage image;
  String content;

  @override
  _ReusableSceneTypeState createState() => _ReusableSceneTypeState();
}

class _ReusableSceneTypeState extends State<ReusableSceneType> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> widget.onPress(widget.content),
      child: Container(
          height: 42,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                border: Border.all(color: Color(0xFF298EB1))),
            child: Row(children: [
              Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(left: 15),
                child: Image(image: widget.image),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 15),
                  child: Text(widget.content,
                      textAlign: TextAlign.center,
                      style: Styles.text6
                          .merge(TextStyle(color: BeautyColors.blue01))),
                ),
              ),
            ]),
          )),
    );
  }
}
