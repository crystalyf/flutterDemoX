import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';
import 'package:provider/provider.dart';

import '../weight_check_history_view_model.dart';
import 'weight_swipe_delete_item.dart';

class WeightCheckHistoryListPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: PageView.builder(
            controller:
                context.watch<WeightCheckHistoryViewModel>().pageViewController,
            reverse: true,
            physics: context.watch<WeightCheckHistoryViewModel>().isEditMode
                ? NeverScrollableScrollPhysics()
                : ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return _getPageView(index, context);
            },
            itemCount: 10000,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index) {
              context
                  .read<WeightCheckHistoryViewModel>()
                  .changeDateString(index);
              context
                  .read<WeightCheckHistoryViewModel>()
                  .removePageState(index, context);
              //after page init notify action delete icon change
              context
                  .read<WeightCheckHistoryViewModel>()
                  .checkCurrentPageEmpty(index, false);
              context
                  .read<WeightCheckHistoryViewModel>()
                  .changeRightErrorVisibility(index);
            }));
  }

  Widget _getPageView(int pageIndex, BuildContext context) {
    if (context
        .read<WeightCheckHistoryViewModel>()
        .checkCurrentPageEmpty(pageIndex, false)) {
      return Container(
        color: BeautyColors.white01,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '体重記録がありません。',
              style: Styles.text8.merge(TextStyle(color: BeautyColors.gray06)),
            ),
            Text('体重を記録しましよう！',
                style:
                    Styles.text7.merge(TextStyle(color: BeautyColors.gray06))),
          ],
        ),
      );
    } else {
      return Container(
        color: BeautyColors.white01,
        child: ListView.builder(
            key: context
                .watch<WeightCheckHistoryViewModel>()
                .getPageState(pageIndex),
            shrinkWrap: true,
            itemCount: context
                .watch<WeightCheckHistoryViewModel>()
                .getListForMonth(pageIndex)
                .length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, cellIndex) {
              return Container(
                //能左滑删除的布局
                child: WeightSwipeItemWidget(
                    pageIndex: pageIndex, cellIndex: cellIndex),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: BeautyColors.gray03),
                  ),
                ),
              );
            }),
      );
    }
  }
}
