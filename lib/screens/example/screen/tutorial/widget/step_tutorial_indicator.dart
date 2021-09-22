import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';

import '../step_tutorial_view_model.dart';

///官方提供的PageView圆点指示器
class StepTutorialIndicator extends StatelessWidget {
  final int itemCount = 3;

  StepTutorialIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Selector<StepTutorialViewModel, ValueNotifier>(
        selector: (context, viewModel) => viewModel.currentPageNotifier,
        builder: (context, pageNotifier, child) {
          //官方提供的PageView圆点指示器
          return CirclePageIndicator(
            selectedDotColor: Colors.white,
            selectedBorderColor: Colors.white,
            borderColor: Colors.white,
            borderWidth: 1,
            dotColor: Colors.green,
            itemCount: itemCount,
            currentPageNotifier:
                context.watch<StepTutorialViewModel>().currentPageNotifier,
          );
        },
      ),
    );
  }
}
