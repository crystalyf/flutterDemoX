import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';
import 'package:provider/provider.dart';

import '../weight_check_history_view_model.dart';

class WeightCheckHistoryTopPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: BeautyColors.blue04,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: Opacity(
                  opacity:
                      context.watch<WeightCheckHistoryViewModel>().isEditMode
                          ? 0
                          : 1,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                    margin: EdgeInsets.only(left: 100),
                    child: Image(
                      image: AssetImage('assets/ic_calender_back.png'),
                    ),
                  ),
                ),
                onTap: () {
                  context.read<WeightCheckHistoryViewModel>().toFrontPage();
                },
              ),
              Text(
                context
                    .watch<WeightCheckHistoryViewModel>()
                    .getCurrentDateString(),
                style:
                    Styles.text12.merge(TextStyle(color: BeautyColors.blue01)),
              ),
              GestureDetector(
                  child: Opacity(
                    opacity: context
                                .watch<WeightCheckHistoryViewModel>()
                                .isRightArrowVisible &&
                            !context
                                .watch<WeightCheckHistoryViewModel>()
                                .isEditMode
                        ? 1
                        : 0,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.transparent),
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(right: 100),
                      child: Image(
                        image: AssetImage('assets/ic_calender_next.png'),
                      ),
                    ),
                  ),
                  onTapDown: (_) {
                    context.read<WeightCheckHistoryViewModel>().toNextPage();
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
