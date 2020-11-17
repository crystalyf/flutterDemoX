import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../feel_calendar_view_model.dart';
import 'day_box.dart';
import 'mathview_date_info.dart';

// ignore: must_be_immutable
class PageMonth extends StatelessWidget {
  MonthViewDateInfo monthViewDate;

  PageMonth(this.monthViewDate);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Selector<FeelCalendarViewModel, List<DayBox>>(
          selector: (context, viewModel) => viewModel.dayList(monthViewDate),
          builder: (context, pageNotifier, child) {
            return GridView.count(
              shrinkWrap: true,
              primary: false,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 7,
              childAspectRatio: 7 / 13,
              children: context.select<FeelCalendarViewModel, List<DayBox>>(
                  (viewModel) => viewModel.dayList(monthViewDate)),
            );
          }),
    );
  }
}
