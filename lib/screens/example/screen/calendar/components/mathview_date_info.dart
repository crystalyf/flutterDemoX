import 'month_info.dart';

class MonthViewDateInfo {
  // 分别是上个月，当前月，下个月的数据
  final List<MonthInfo> data = [MonthInfo(), MonthInfo(), MonthInfo()];
  final DateTime dt;
  final int showFirstWeekday = 7; // 从周几开始显示
  int calendarShowDaysCount;  // 月历中需要显示的天数

  MonthViewDateInfo(this.dt) {
    assert(7 == showFirstWeekday);  //目前只处理了从周日开始显示
    calendarShowDaysCount = 0;

    ///    拿2020年11月份举例子，2020年11月份，上个月灰色的日子在第一行从26到31，6个小格，
    ///下个月的日子在最后一行，从1号到6号，也为6个小格
    var thisMonthFirstWeedday = DateTime(dt.year, dt.month, 1).weekday;
    if (showFirstWeekday != thisMonthFirstWeedday) {
      var lastMonthInfo = data[0];
      var lastMonth = DateTime(dt.year, dt.month, 0);
      lastMonthInfo.year = lastMonth.year;
      lastMonthInfo.month = lastMonth.month;
      lastMonthInfo.daysCount = lastMonth.day;
      //日曜日から並べ替え
      if (7 == showFirstWeekday) {
        lastMonthInfo.showCount = thisMonthFirstWeedday - 0;
        //加减数量，使得上个月的页面，小格正好铺满整行
        lastMonthInfo.firstShowDay =
            lastMonthInfo.daysCount - lastMonthInfo.showCount + 1;
        lastMonthInfo.lastShowDay = lastMonth.day;
      }
      calendarShowDaysCount += lastMonthInfo.showCount;
    }
    var thisMonth = DateTime(dt.year, dt.month + 1, 0);
    var thisMonthInfo = data[1];
    thisMonthInfo.year = thisMonth.year;
    thisMonthInfo.month = thisMonth.month;
    thisMonthInfo.daysCount = thisMonth.day;
    thisMonthInfo.firstShowDay = 1;
    thisMonthInfo.lastShowDay = thisMonth.day;
    thisMonthInfo.showCount = thisMonth.day;
    calendarShowDaysCount += thisMonthInfo.showCount;
    var nextMonthFirstWeekday = DateTime(dt.year, dt.month + 1, 1).weekday;
    if (showFirstWeekday != nextMonthFirstWeekday) {
      var nextMonthInfo = data[2];
      var nextMonth = DateTime(dt.year, dt.month + 2, 0);
      nextMonthInfo.year = nextMonth.year;
      nextMonthInfo.month = nextMonth.month;
      nextMonthInfo.daysCount = nextMonth.day;
      if (7 == showFirstWeekday) {
        nextMonthInfo.firstShowDay = 1;
        //加减数量，使得下个月的页面，小格正好铺满整行
        nextMonthInfo.showCount = 7 - nextMonthFirstWeekday + 0;
        nextMonthInfo.lastShowDay = nextMonthInfo.showCount;
      }
      calendarShowDaysCount += nextMonthInfo.showCount;
    }
  }
}
