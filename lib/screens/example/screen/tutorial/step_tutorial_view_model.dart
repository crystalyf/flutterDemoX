import 'package:flutter/material.dart';

class StepTutorialViewModel extends ChangeNotifier {
  StepTutorialViewModel() {
    controller.addListener(() {
      currentPageNotifier.value = controller.page.round();
      notifyListeners();
    });
  }

  final controller = PageController(initialPage: 0);

  //小圆点的当前current Page
  final currentPageNotifier = ValueNotifier<int>(0);
}
