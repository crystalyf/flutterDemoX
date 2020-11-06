import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demox/screens/example/recordtop/components/eat_card_top.dart';
import 'package:flutter_demox/screens/example/recordtop/components/reusable_card.dart';
import 'package:flutter_demox/screens/example/recordtop/record_top_view_model.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/constants.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';
import 'package:provider/provider.dart';

class RecordTop extends StatefulWidget {
  @override
  _RecordTopState createState() => _RecordTopState();
}

class _RecordTopState extends State<RecordTop> {
  //当天摄入的卡路里
  int kcalValue = -1220;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return RecordTopViewModel();
      },
      child: Container(
        child: Consumer<RecordTopViewModel>(builder: (context, value, child) {
          return Scaffold(
            //透明背景的appbar
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('記録'),
              textTheme: TextTheme(
                  subtitle1: TextStyle(
                      //设置appBar的文本样式
                      color: BeautyColors.blue02)),
              centerTitle: true,
              // 标题居中
              backgroundColor: Colors.transparent,
              //把appbar的背景色改成透明
              elevation: 0, //阴影为0
            ),
            body: Container(
              //调整小格布局的整体边界
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                children: <Widget>[
                  Container(
                    //在小格布局的基础上，调整eatTop布局
                    margin: EdgeInsets.fromLTRB(5, 0, 5, 7),
                    child: EatCardTop(
                        cardChild: EatDataWidget(
                      isHaveData:
                          context.watch<RecordTopViewModel>().isHaveEatData,
                      kcalValue: kcalValue,
                    )),
                  ),
                  Expanded(
                      child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ReusableCard(
                            onPress: () {
                              _stepWidgetClick(context);
                            },
                            cardChild: StepDataWidget(
                                isHaveData: context
                                    .watch<RecordTopViewModel>()
                                    .isHaveStepData)),
                      ),
                      Expanded(
                        child: ReusableCard(
                            onPress: () {
                              setState(() {
                                print('体重：press!!!');
                              });
                            },
                            cardChild: WeightDataWidget(
                              isHaveData: context
                                  .watch<RecordTopViewModel>()
                                  .isHaveWeightData,
                            )),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ReusableCard(
                            onPress: () {
                              print('感觉：press');
                            },
                            cardChild: FeelDataWidget(
                              isHaveData: context
                                  .watch<RecordTopViewModel>()
                                  .isHaveFeelData,
                            )),
                      ),
                      Expanded(
                        child: ReusableCard(
                            onPress: () {
                              setState(() {});
                            },
                            cardChild: SleepDataWidget(
                              isHaveData: context
                                  .watch<RecordTopViewModel>()
                                  .isHaveSleepData,
                            )),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ReusableCard(
                            onPress: () {
                              print('健康年龄：press');
                            },
                            cardChild: HealthAgeDataWidget(
                              isHaveData: context
                                  .watch<RecordTopViewModel>()
                                  .isHaveHealthAgeData,
                            )),
                      ),
                      Expanded(
                        child: ReusableCard(
                          onPress: () {
                            setState(() {});
                          },
                          cardChild: HealthDiagnosisDataWidget(
                            isHaveData: context
                                .watch<RecordTopViewModel>()
                                .isHaveHealthDiagnosisData,
                          ),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _stepWidgetClick(BuildContext context) {
    if (context.read<RecordTopViewModel>().isHaveStepData) {
      _transferToStepTop(context);
    } else {
      _transferToStepTutorial(context);
    }
  }

  ///「CC02-02_ 歩数 TOP- 日表示」へ遷移
  void _transferToStepTop(BuildContext context) {
    setState(() {
      context.read<RecordTopViewModel>().isHaveStepData =
          !context.read<RecordTopViewModel>().isHaveStepData;
    });
  }

  ///「CC01-01_ 歩数計チュートリアル -01」へ遷移
  void _transferToStepTutorial(BuildContext context) {
    setState(() {
      context.read<RecordTopViewModel>().isHaveStepData =
          !context.read<RecordTopViewModel>().isHaveStepData;
    });
  }
}

///Eat数据的Widget
// ignore: must_be_immutable
class EatDataWidget extends StatelessWidget {
  EatDataWidget({this.isHaveData, this.kcalValue});

  final bool isHaveData;
  int kcalValue = -1;

  @override
  Widget build(BuildContext context) {
    if (isHaveData) {
      ///have data Widget
      return Container(
        // margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 16, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                child: Image.asset('assets/ic_drawer_meal.png'),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    '食事チェック',
                                    style: Styles.text5.merge(
                                      TextStyle(color: BeautyColors.blue01),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          child: Text(
                            context.watch<RecordTopViewModel>().currentDate,
                            style: Styles.text3.merge(TextStyle(
                              color: BeautyColors.gray06,
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(
                          kcalValue.toString(),
                          style: Styles.text1.merge(
                            TextStyle(
                              color: BeautyColors.pink01,
                              fontSize: 30.0,
                            ),
                          ),
                        ),
                        Text(
                          'kcal',
                          style: Styles.text9.merge(
                            TextStyle(
                              color: BeautyColors.pink01,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  getSeekWidget(context.watch<RecordTopViewModel>().totalKCal),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16.0, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              '累计' +
                                  context
                                      .watch<RecordTopViewModel>()
                                      .totalKCal
                                      .toString(),
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              'kcal',
                              style: TextStyle(
                                fontSize: 10.0,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 85.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              '目标3000',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              'kcal',
                              style: TextStyle(
                                fontSize: 10.0,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 15, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              child: Image.asset('assets/ic_home_morning.png'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 2.0),
                                  child: Text(
                                    '20000',
                                    style: Styles.text17.merge(
                                      TextStyle(color: BeautyColors.pink01),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'kcal',
                                    style: Styles.text1.merge(
                                      TextStyle(color: BeautyColors.pink01),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              child: Image.asset('assets/ic_home_lunch.png'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 2.0),
                                  child: Text(
                                    '20000',
                                    style: Styles.text17.merge(
                                      TextStyle(color: BeautyColors.pink01),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'kcal',
                                    style: Styles.text1.merge(
                                      TextStyle(color: BeautyColors.pink01),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              child: Image.asset('assets/ic_home_dinner.png'),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 2.0),
                              child: Text(
                                '记录停止',
                                style: Styles.text5.merge(
                                  TextStyle(color: BeautyColors.blue01),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            //自定义icon图片：
            Container(
              margin: EdgeInsets.only(right: 12.0),
              width: 24,
              height: 24,
              child: Image.asset('assets/ic_cheveron.png'),
            )
          ],
        ),
      );
    } else {
      ///no Eat data Widget
      return Container(
        height: 190,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    child: Image.asset('assets/ic_drawer_meal.png'),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 4.0),
                        child: Text(
                          '食事チェック',
                          style: Styles.text5.merge(
                            TextStyle(color: BeautyColors.blue01),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        recordItemNoData,
                        style: Styles.text7.merge(
                          TextStyle(color: BeautyColors.gray06),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 54.0),
                      child: OutlineButton(
                          onPressed: () {},
                          child: Text('登録',
                              style: Styles.text7.merge(
                                TextStyle(color: BeautyColors.gray06),
                              ))),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

///Step数据的Widget
class StepDataWidget extends StatelessWidget {
  StepDataWidget({this.isHaveData});

  final bool isHaveData;

  @override
  Widget build(BuildContext context) {
    if (isHaveData) {
      ///有Step数据时的Widget
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Container(
                  width: 120,
                  margin: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        child: Image.asset('assets/ic_drawer_steps.png'),
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 1.0),
                            child: Text(
                              '步数Check',
                              style: Styles.text5.merge(
                                TextStyle(color: BeautyColors.blue01),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 16.0),
                      child: Text(
                        '2019.4.8(日)',
                        style: Styles.text3.merge(
                          TextStyle(color: BeautyColors.gray06),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            '100002',
                            style: Styles.text1.merge(
                              TextStyle(
                                color: BeautyColors.pink01,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 4.0),
                            child: Text(
                              '步',
                              style: Styles.text9.merge(
                                TextStyle(
                                  color: BeautyColors.pink01,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            //自定义icon图片：
            Container(
              margin: EdgeInsets.only(right: 12.0),
              width: 24,
              height: 24,
              child: Image.asset("assets/ic_cheveron.png"),
            )
          ],
        ),
      );
    } else {
      ///没有Step数据时的Widget
      return Container(
        child: Column(
          children: [
            Container(
              width: 120,
              margin: EdgeInsets.fromLTRB(0, 10, 34, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    child: Image.asset('assets/ic_drawer_steps.png'),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 4.0),
                        child: Text(
                          '步数Check',
                          style: Styles.text5.merge(
                            TextStyle(color: BeautyColors.blue01),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      recordItemNoData,
                      style: Styles.text3.merge(
                        TextStyle(color: BeautyColors.gray06),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: OutlineButton(onPressed: () {}, child: Text(set)),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

/// 体重数据的Widget
class WeightDataWidget extends StatelessWidget {
  WeightDataWidget({this.isHaveData});

  final bool isHaveData;

  @override
  Widget build(BuildContext context) {
    if (isHaveData) {
      ///有体重数据时的Widget
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Container(
                  width: 120,
                  margin: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        child: Image.asset('assets/ic_drawer_weight.png'),
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 1.0),
                            child: Text(
                              '体重记录',
                              style: Styles.text5.merge(
                                TextStyle(color: BeautyColors.blue01),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 16.0),
                      child: Text(
                        '2019.4.8(日)',
                        style: Styles.text3.merge(
                          TextStyle(color: BeautyColors.gray06),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            '200',
                            style: Styles.text1.merge(
                              TextStyle(
                                color: BeautyColors.pink01,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 3.0),
                            child: Text(
                              'kg',
                              style: Styles.text9.merge(
                                TextStyle(
                                  color: BeautyColors.pink01,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            //自定义icon图片：
            Container(
              margin: EdgeInsets.only(right: 12.0),
              width: 24,
              height: 24,
              child: Image.asset("assets/ic_cheveron.png"),
            )
          ],
        ),
      );
    } else {
      ///没有体重数据时的Widget
      return Container(
        child: Column(
          children: [
            Container(
              width: 120,
              margin: EdgeInsets.fromLTRB(0, 10, 34, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    child: Image.asset('assets/ic_drawer_weight.png'),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 4.0),
                        child: Text(
                          '体重记录',
                          style: Styles.text5.merge(
                            TextStyle(color: BeautyColors.blue01),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      recordItemNoData,
                      style: Styles.text3.merge(
                        TextStyle(color: BeautyColors.gray06),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: OutlineButton(onPressed: () {}, child: Text(record)),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

/// 感觉数据的Widget
class FeelDataWidget extends StatelessWidget {
  FeelDataWidget({this.isHaveData});

  final bool isHaveData;

  @override
  Widget build(BuildContext context) {
    if (isHaveData) {
      ///有感觉数据时的Widget
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Container(
                  width: 120,
                  margin: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        child: Image.asset('assets/ic_drawer_kimoti.png'),
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 1.0),
                            child: Text(
                              '感觉如何',
                              style: Styles.text5.merge(
                                TextStyle(color: BeautyColors.blue01),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(
                    '2019.4.8(日)',
                    style: Styles.text3.merge(
                      TextStyle(color: BeautyColors.gray06),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    '74 : 26',
                    style: Styles.text1.merge(
                      TextStyle(
                        color: BeautyColors.pink01,
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
            //自定义icon图片：
            Container(
              margin: EdgeInsets.only(right: 12.0),
              width: 24,
              height: 24,
              child: Image.asset("assets/ic_cheveron.png"),
            )
          ],
        ),
      );
    } else {
      ///没有感觉数据时的Widget
      return Container(
        child: Column(
          children: [
            Container(
              width: 120,
              margin: EdgeInsets.fromLTRB(0, 10, 34, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    child: Image.asset('assets/ic_drawer_weight.png'),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 4.0),
                        child: Text(
                          '感觉如何',
                          style: Styles.text5.merge(
                            TextStyle(color: BeautyColors.blue01),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      recordItemNoData,
                      style: Styles.text3.merge(
                        TextStyle(color: BeautyColors.gray06),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: OutlineButton(
                        onPressed: () {}, child: Text(determination)),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

/// 睡眠数据的Widget
class SleepDataWidget extends StatelessWidget {
  SleepDataWidget({this.isHaveData});

  final bool isHaveData;

  @override
  Widget build(BuildContext context) {
    if (isHaveData) {
      ///有睡眠数据时的Widget
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Container(
                  width: 120,
                  margin: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        child: Image.asset('assets/ic_drawer_sleep.png'),
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 1.0),
                            child: Text(
                              '睡眠',
                              style: Styles.text5.merge(
                                TextStyle(color: BeautyColors.blue01),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(
                    '2019.4.8(日)',
                    style: Styles.text3.merge(
                      TextStyle(color: BeautyColors.gray06),
                    ),
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(top: 10.0),
                  child: Text(
                    '10时30分',
                    style: Styles.text1.merge(
                      TextStyle(
                        color: BeautyColors.pink01,
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
            //自定义icon图片：
            Container(
              margin: EdgeInsets.only(right: 12.0),
              width: 24,
              height: 24,
              child: Image.asset("assets/ic_cheveron.png"),
            )
          ],
        ),
      );
    } else {
      ///没有睡眠数据时的Widget
      return Container(
        child: Column(
          children: [
            Container(
              width: 120,
              margin: EdgeInsets.fromLTRB(0, 10, 34, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    child: Image.asset('assets/ic_drawer_weight.png'),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 4.0),
                        child: Text(
                          '睡眠',
                          style: Styles.text5.merge(
                            TextStyle(color: BeautyColors.blue01),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      recordItemNoData,
                      style: Styles.text3.merge(
                        TextStyle(color: BeautyColors.gray06),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: OutlineButton(onPressed: () {}, child: Text(record)),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

/// 健康年龄数据的Widget
class HealthAgeDataWidget extends StatelessWidget {
  HealthAgeDataWidget({this.isHaveData});

  final bool isHaveData;

  @override
  Widget build(BuildContext context) {
    if (isHaveData) {
      ///有健康年龄数据时的Widget
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Container(
                  width: 120,
                  margin: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        child: Image.asset('assets/ic_drawer_health_age.png'),
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 1.0),
                            child: Text(
                              '健康年龄',
                              style: Styles.text5.merge(
                                TextStyle(color: BeautyColors.blue01),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16.0),
                  child: Text(
                    '2019.4.8(41岁当时)',
                    style: Styles.text3.merge(
                      TextStyle(color: BeautyColors.gray06),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        '39.5',
                        style: Styles.text1.merge(
                          TextStyle(
                            color: BeautyColors.pink01,
                            fontSize: 30.0,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 3.0),
                        child: Text(
                          '岁',
                          style: Styles.text9.merge(
                            TextStyle(
                              color: BeautyColors.pink01,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            //自定义icon图片：
            Container(
              margin: EdgeInsets.only(right: 12.0),
              width: 24,
              height: 24,
              child: Image.asset("assets/ic_cheveron.png"),
            )
          ],
        ),
      );
    } else {
      ///没有健康年龄数据时的Widget
      return Container(
        child: Column(
          children: [
            Container(
              width: 120,
              margin: EdgeInsets.fromLTRB(0, 10, 34, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    child: Image.asset('assets/ic_drawer_weight.png'),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 4.0),
                        child: Text(
                          '健康年龄',
                          style: Styles.text5.merge(
                            TextStyle(color: BeautyColors.blue01),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      recordItemNoData,
                      style: Styles.text3.merge(
                        TextStyle(color: BeautyColors.gray06),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: OutlineButton(
                        onPressed: () {}, child: Text(determination)),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

/// 健康诊断数据的Widget
class HealthDiagnosisDataWidget extends StatelessWidget {
  HealthDiagnosisDataWidget({this.isHaveData});

  final bool isHaveData;

  @override
  Widget build(BuildContext context) {
    if (isHaveData) {
      ///有健康诊断数据时的Widget
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Container(
                  width: 120,
                  margin: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        child: Image.asset('assets/ic_drawer_my_health.png'),
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 1.0),
                            child: Text(
                              '健康诊断',
                              style: Styles.text5.merge(
                                TextStyle(color: BeautyColors.blue01),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  child: Text('2019.4.8',
                      style: Styles.text11
                          .merge(TextStyle(color: BeautyColors.pink01))),
                ),
                Container(
                  margin: EdgeInsets.only(top: 1.0),
                  child: Text('(41岁当时)',
                      style: Styles.text7
                          .merge(TextStyle(color: BeautyColors.pink01))),
                )
              ],
            ),
            //自定义icon图片：
            Container(
              margin: EdgeInsets.only(right: 12.0),
              width: 24,
              height: 24,
              child: Image.asset("assets/ic_cheveron.png"),
            )
          ],
        ),
      );
    } else {
      ///没有健康诊断数据时的Widget
      return Container(
        child: Column(
          children: [
            Container(
              width: 120,
              margin: EdgeInsets.fromLTRB(0, 10, 34, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    child: Image.asset('assets/ic_drawer_weight.png'),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 4.0),
                      child: Text(
                        '健康诊断',
                        style: Styles.text5.merge(
                          TextStyle(color: BeautyColors.blue01),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      recordItemNoData,
                      style: Styles.text3.merge(
                        TextStyle(color: BeautyColors.gray06),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: OutlineButton(onPressed: () {}, child: Text(login)),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

///进度layout的自定义View
Widget getSeekWidget(int totalKCal) {
  var colorColumn = Color(0x80FD70B7);
  var colorColumn1 = Color(0x80DBB0FF);
  var colorColumn2 = Color(0x8046BEE8);

  return Container(
    margin: EdgeInsets.only(left: 16),
    height: 20,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/gauge.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: Stack(
      children: [
        Container(
          //total seek length == 310，4200kcal
          margin: EdgeInsets.only(
              right: 310 - totalKCal / 4200 * 310, top: 2, bottom: 2, left: 1),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.0, 0.5, 1.0],
                colors: [colorColumn, colorColumn1, colorColumn2]),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0)),
          ),
        ),

        ///target line
        Container(
          margin: EdgeInsets.only(left: 220, top: 2, bottom: 2),
          color: BeautyColors.blue01,
          width: 1,
        )
      ],
    ),
  );
}
