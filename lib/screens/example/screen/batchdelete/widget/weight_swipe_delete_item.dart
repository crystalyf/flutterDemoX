import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';
import 'package:provider/provider.dart';

import '../weight_check_history_view_model.dart';

class WeightSwipeItemWidget extends StatefulWidget {
  final int pageIndex;
  final int cellIndex;

  WeightSwipeItemWidget({this.pageIndex, this.cellIndex});

  @override
  State<StatefulWidget> createState() {
    return WeightSwipeItemWidgetState(
        pageIndex: pageIndex, cellIndex: cellIndex);
  }
}

class WeightSwipeItemWidgetState extends State<WeightSwipeItemWidget>
    with TickerProviderStateMixin {
  AnimationController animationController;
  var deleteWidgetWidth = 100.0;
  var isSwipeOut = false;
  var translateX = 0.0;
  final int pageIndex;
  final int cellIndex;

  WeightSwipeItemWidgetState({this.pageIndex, this.cellIndex});

  @override
  void initState() {
    super.initState();
    initAnimController();
  }

  void initAnimController() {
    print('initAnimController is $translateX');
    animationController = AnimationController(
        lowerBound: 0,
        upperBound: deleteWidgetWidth,
        vsync: this,
        duration: Duration(milliseconds: 150),
        reverseDuration: Duration(milliseconds: 150))
      ..addListener(() {
        translateX = animationController.value;
        print('translateX is $translateX');
        setState(() {});
      });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WeightSwipeItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (context.read<WeightCheckHistoryViewModel>().swipeOpenPos == -1) {
      animationController.reset();
    } else if (context.read<WeightCheckHistoryViewModel>().swipeOpenPos !=
        cellIndex) {
      print('i am close$cellIndex');
      animationController.reverse();
      isSwipeOut = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(children: [
      Transform.translate(
        offset: Offset(-translateX, 0),
        child: Container(
          width: width,
          child: Row(
            children: [
              Visibility(
                visible:
                    context.watch<WeightCheckHistoryViewModel>().isEditMode,
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: _getPlatFormDeleteView(context),
                ),
              ),
              Visibility(
                visible:
                    !context.watch<WeightCheckHistoryViewModel>().isEditMode,
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: ImageIcon(
                    AssetImage('assets/ic_drawer_weight.png'),
                    color: BeautyColors.blue01,
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 0, top: 15, bottom: 15),
                                child: Container(
                                  height: 29,
                                  width: 250,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: Row(
                                        textBaseline: TextBaseline.alphabetic,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 4),
                                            child: Text(
                                              context
                                                  .watch<
                                                      WeightCheckHistoryViewModel>()
                                                  .getListForMonth(pageIndex)
                                                  .elementAt(cellIndex)
                                                  .getDayTime(),
                                              style: Styles.text7.merge(
                                                  TextStyle(
                                                      color:
                                                          BeautyColors.gray02)),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 4),
                                            child: Text(
                                              '(火)',
                                              style: Styles.text7.merge(
                                                  TextStyle(
                                                      color:
                                                          BeautyColors.gray02)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 18),
                                child: Text(
                                  '50kg',
                                  style: Styles.text7.merge(
                                      TextStyle(color: BeautyColors.gray02)),
                                ),
                              ),
                            ],
                          ),
                          //底线
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
      Offstage(
        child: GestureDetector(
          onTap: () {
            context
                .read<WeightCheckHistoryViewModel>()
                .removeCurrentData(pageIndex, cellIndex);
            context.read<WeightCheckHistoryViewModel>().setSwipeOpenPos(-1);
          },
          child: Container(
            color: Colors.red,
            height: 59,
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: width - translateX),
            width: deleteWidgetWidth,
            child: Text(
              '删除',
              style: Styles.text6.merge(TextStyle(color: BeautyColors.white01)),
              maxLines: 1,
            ),
          ),
        ),
        offstage: false,
      ),
    ]);
  }

  Widget _getPlatFormDeleteView(BuildContext context) {
    if (Platform.isIOS) {
      return IconButton(
        icon: Icon(
          Icons.remove_circle,
          color: BeautyColors.red01,
        ),
        onPressed: () {
          if (isSwipeOut) {
            animationController.reverse();
            context.read<WeightCheckHistoryViewModel>().setSwipeOpenPos(-2);
            isSwipeOut = false;
            print('i am reverse');
          } else {
            animationController.forward();
            context
                .read<WeightCheckHistoryViewModel>()
                .setSwipeOpenPos(cellIndex);
            isSwipeOut = true;
            print('i am forward');
          }
        },
      );
    } else if (Platform.isAndroid) {
      return IconButton(
        icon: ImageIcon(
          AssetImage('assets/navi_trush.png'),
          color: BeautyColors.blue01,
        ),
        onPressed: () {
          _showDeleteDialog(context, pageIndex, cellIndex);
        },
      );
    } else {
      return null;
    }
  }

  void _showDeleteDialog(BuildContext context, int pageIndex, int dataIndex) {
    showDialog<AlertDialog>(
        context: context,
        barrierDismissible: false,
        builder: (contextInside) => AlertDialog(
              title: Text(('dialog标题')),
              content: Text((context
                  .read<WeightCheckHistoryViewModel>()
                  .getDeleteTitleMessage(pageIndex, dataIndex))),
              actions: <Widget>[
                FlatButton(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.pop(contextInside);
                    //result
                  },
                ),
                FlatButton(
                  child: Text('确定'),
                  onPressed: () {
                    context
                        .read<WeightCheckHistoryViewModel>()
                        .removeCurrentData(pageIndex, dataIndex);
                    Navigator.pop(contextInside);
                  },
                ),
              ],
            ));
  }
}
