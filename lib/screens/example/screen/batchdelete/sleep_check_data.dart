class SleepCheckData {
  final String date;
  final String hours;
  final String minutes;
  final String startTime;
  final String endTime;
  final int beautyEffectLevel;
  final int deepSleepLevel;
  final int shallowSleepLevel;
  final int obesityPreventionLevel;
  final int deepSleepRate;
  final int awakening;

  SleepCheckData(
      {this.date,
      this.hours,
      this.minutes,
      this.startTime,
      this.endTime,
      this.beautyEffectLevel,
      this.deepSleepLevel,
      this.shallowSleepLevel,
      this.obesityPreventionLevel,
      this.deepSleepRate,
      this.awakening});

  double getProgress() {
    var hoursInt = int.parse(hours);
    if (hoursInt >= 10) {
      return 100;
    } else {
      var minutesInt = (hoursInt * 60 + int.parse(minutes));
      return (minutesInt / (10 * 60)) * 100;
    }
  }

  String getDayTime() {
    var dateStringError = date.split('.');
    var newDate = dateStringError[2];
    return newDate;
  }
}
