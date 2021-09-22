import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';

import '../step_tutorial_view_model.dart';

///自定义View的指示器，使用的是3个图片做的小圆点布局。
///
///  带边缘的透明色原生的做不到, 圆圈最底部有白色
///
class StepTutorialCustomIndicator extends StatelessWidget {

  StepTutorialCustomIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Selector<StepTutorialViewModel, ValueNotifier>(
        selector: (context, viewModel) => viewModel.currentPageNotifier,
        // ignore: missing_return
        builder: (context, pageNotifier, child) {
          if (context
              .watch<StepTutorialViewModel>()
              .currentPageNotifier
              .value ==
              0) {
            return Container(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    child: Image.asset('assets/ic_tutorial_point2.png'),
                  ),
                  Container(
                    width: 14,
                    height: 14,
                    child: Image.asset('assets/ic_tutorial_point1.png'),
                  ),
                  Container(
                    width: 14,
                    height: 14,
                    child: Image.asset('assets/ic_tutorial_point1.png'),
                  ),
                ],
              ),
            );
          } else if (context
              .watch<StepTutorialViewModel>()
              .currentPageNotifier
              .value ==
              1) {
            return Container(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    child: Image.asset('assets/ic_tutorial_point1.png'),
                  ),
                  Container(
                    width: 14,
                    height: 14,
                    child: Image.asset('assets/ic_tutorial_point2.png'),
                  ),
                  Container(
                    width: 14,
                    height: 14,
                    child: Image.asset('assets/ic_tutorial_point1.png'),
                  ),
                ],
              ),
            );
          } else if (context
              .watch<StepTutorialViewModel>()
              .currentPageNotifier
              .value ==
              2) {
            return Container(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    child: Image.asset('assets/ic_tutorial_point1.png'),
                  ),
                  Container(
                    width: 14,
                    height: 14,
                    child: Image.asset('assets/ic_tutorial_point1.png'),
                  ),
                  Container(
                    width: 14,
                    height: 14,
                    child: Image.asset('assets/ic_tutorial_point2.png'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
