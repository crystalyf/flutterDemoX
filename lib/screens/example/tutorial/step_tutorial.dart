import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/tutorial/step_tutorial_view_model.dart';
import 'package:flutter_demox/screens/example/tutorial/widget/step_tutorial_custom_indicator.dart';
import 'package:flutter_demox/screens/example/tutorial/widget/step_tutorial_indicator.dart';
import 'package:provider/provider.dart';

class StepTutorial extends StatefulWidget {
  @override
  _StepTutorialState createState() => _StepTutorialState();
}

class _StepTutorialState extends State<StepTutorial> {
  //CC01_ 歩数チュートリアル
  String stepTutorialTitle = '标题';

  String skipButtonText = '下一页';

  //viewPager的所有页面集
  List<Widget> _pages = <Widget>[
    Column(
      children: [
        Container(
            height: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '这是一段引导页的内容',
                  style: TextStyle(color: BeautyColors.blue02, fontSize: 22),
                ),
              ],
            )),
        // Image(image: AssetImage('assets/ic_tutorial_steps_1.png')),
      ],
    ),
    Column(
      children: [
        Container(
            height: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '这是一段引导页的内容',
                  style: TextStyle(color: BeautyColors.blue02, fontSize: 22),
                ),
              ],
            )),
        //  Image(image: AssetImage('assets/ic_tutorial_steps_2.png')),
      ],
    ),
    Column(
      children: [
        Container(
            height: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '这是一段引导页的内容',
                  style: TextStyle(color: BeautyColors.blue02, fontSize: 22),
                ),
              ],
            )),
        //  Image(image: AssetImage('assets/ic_tutorial_steps_3.png')),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          return StepTutorialViewModel();
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg_A.png'),
              fit: BoxFit.cover,
            ),
          ),
          child:
              Consumer<StepTutorialViewModel>(builder: (context, value, child) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  stepTutorialTitle,
                  style: TextStyle(color: BeautyColors.blue02),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Container(
                // margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: PageView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return _pages[index % _pages.length];
                        },
                        itemCount: _pages.length,
                        controller:
                            context.watch<StepTutorialViewModel>().controller,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index) {
                          setState(() {
                            if (index == 2) {
                              skipButtonText = '关闭';
                            } else {
                              skipButtonText = '下一页';
                            }
                          });
                        },
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 100,
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //自定义的圆点指示器
                                    StepTutorialCustomIndicator(),
                                    //原生圆点指示器
                                    StepTutorialIndicator(),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: 100,
                                  height: 40,
                                  child: RaisedButton(
                                    color: BeautyColors.white80,
                                    onPressed: () {
                                      if (context
                                              .read<StepTutorialViewModel>()
                                              .currentPageNotifier
                                              .value ==
                                          2) {
                                        _transferToStepTop();
                                      } else {
                                        //animateToPage方法翻到指定页面
                                        context
                                            .read<StepTutorialViewModel>()
                                            .controller
                                            .animateToPage(
                                              context
                                                      .read<
                                                          StepTutorialViewModel>()
                                                      .currentPageNotifier
                                                      .value +
                                                  1,
                                              duration: const Duration(
                                                  milliseconds: 400),
                                              curve: Curves.easeInOut,
                                            );
                                      }
                                    },
                                    child: Text(
                                      skipButtonText,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: BeautyColors.white01),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            );
          }),
        ));
  }

  ///跳转到】「CC02-02_ 歩数 TOP
  void _transferToStepTop() {}
}
