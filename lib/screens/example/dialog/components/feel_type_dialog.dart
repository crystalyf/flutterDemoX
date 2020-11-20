import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/dialog/components/reusable_scene_type.dart';
import 'package:flutter_demox/screens/example/dialog/components/reusable_time_type.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';

class FeelTypeDialog extends StatefulWidget {
  Function(String) onSelectCallback;

  FeelTypeDialog(Function(String p1) onSelectCallback){
    this.onSelectCallback = onSelectCallback;
  }

  @override
  _FeelTypeDialogState createState() => _FeelTypeDialogState();
}

class _FeelTypeDialogState extends State<FeelTypeDialog> {
  BuildContext dialogContext;
  var closeImg = AssetImage('assets/btn_menu_close.png');
  var closeImgOpacity = 1.0;
  var iconImgOpacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.only(left: 30, right: 30),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3.0))),
      //内容内边距,都设成0就是没有
      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      content: Builder(builder: (context) {
        dialogContext = context;
        return Container(
          margin: EdgeInsets.only(top: 12),
          width: MediaQuery.of(context).size.width,
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('シーン別',
                                  style: Styles.text8.merge(
                                      TextStyle(color: BeautyColors.gray02))),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTapDown: (tapDown) {
                              setState(() {
                                closeImgOpacity = 0.5;
                              });
                            },
                            onTapUp: (tapUp) {
                              closeImgOpacity = 1.0;
                              Navigator.pop(dialogContext);
                            },
                            onTapCancel: () {
                              closeImgOpacity = 1.0;
                            },
                            child: Container(
                              width: 26,
                              height: 26,
                              child: Opacity(
                                opacity: closeImgOpacity,
                                child: Image(image: closeImg),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 7),
                          child: ReusableSceneType(
                            onPress: (content) {
                              //TODO: click
                              afterSelectCell(content);
                            },
                            image: AssetImage('assets/ic_kimochi_01.png'),
                            content: '睡眠前',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 7),
                          child: ReusableSceneType(
                            onPress: (content) {
                              //TODO: click
                              afterSelectCell(content);
                            },
                            image: AssetImage('assets/ic_kimochi_02.png'),
                            content: 'お目覚め',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 7),
                          child: ReusableSceneType(
                            onPress: (content) {
                              afterSelectCell(content);
                            },
                            image: AssetImage('assets/ic_kimochi_03.png'),
                            content: '仕事・家事',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 7),
                          child: ReusableSceneType(
                            onPress: (content) {
                              //TODO: click
                              afterSelectCell(content);
                            },
                            image: AssetImage('assets/ic_kimochi_04.png'),
                            content: 'スポーツ',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 7),
                          child: ReusableSceneType(
                            onPress: (content) {
                              afterSelectCell(content);
                            },
                            image: AssetImage('assets/ic_kimochi_05.png'),
                            content: '趣味・娯楽',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 7),
                          child: ReusableSceneType(
                            onPress: (content) {
                              afterSelectCell(content);
                            },
                            image: AssetImage('assets/ic_kimochi_06.png'),
                            content: 'その他',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Center(
                    child: Text('時間帯別',
                        style: Styles.text8
                            .merge(TextStyle(color: BeautyColors.gray02))),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 7),
                          child: ReusableTimeType(
                            onPress: () {
                              //TODO: click
                            },
                            content1: '朝',
                            content2: '4:00〜11:59',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 7),
                          child: ReusableTimeType(
                            onPress: () {
                              //TODO: click
                            },
                            content1: '昼',
                            content2: '12:00〜14:59',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8, bottom: 28),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 7),
                          child: ReusableTimeType(
                            onPress: () {
                              //TODO: click
                            },
                            content1: '夕',
                            content2: '15:00〜18:59',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 7),
                          child: ReusableTimeType(
                            onPress: () {
                              //TODO: click
                            },
                            content1: '夜',
                            content2: '19:00〜3:59',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void afterSelectCell(String content) {
    widget.onSelectCallback(content);
    Navigator.pop(dialogContext);
  }
}
