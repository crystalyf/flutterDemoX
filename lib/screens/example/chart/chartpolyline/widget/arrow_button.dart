import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../weight_top_view_model.dart';

class ArrowButton extends StatefulWidget {
  ArrowButton({this.isNextButton});

  final bool isNextButton;

  @override
  State<StatefulWidget> createState() {
    return ArrowButtonState(isNextButton: isNextButton);
  }
}

class ArrowButtonState extends State<ArrowButton> {
  ArrowButtonState({this.isNextButton});

  bool isNextButton;

  @override
  Widget build(BuildContext context) {
    Image iconImage;
    if (isNextButton) {
      iconImage = Image(
        image: AssetImage('assets/ic_calender_next.png'),
      );
    } else {
      iconImage = Image(
        image: AssetImage('assets/ic_calender_back.png'),
      );
    }
    var hasNextButton = context.select<WeightTopViewModel, bool>(
        (viewModel) => viewModel.hasNextButton);
    var hasBackButton = context.select<WeightTopViewModel, bool>(
        (viewModel) => viewModel.hasBackButton);
    if (isNextButton) {
      if (!hasNextButton) {
        return SizedBox();
      }
    } else {
      if (!hasBackButton) {
        return SizedBox();
      }
    }

    return IconButton(
      constraints: BoxConstraints(),
      alignment: isNextButton ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.zero,
      icon: iconImage,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () =>
          context.read<WeightTopViewModel>().changeDuration(isNextButton),
    );
  }
}
