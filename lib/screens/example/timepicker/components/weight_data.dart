
final String columnId = '_id';
final String tableWeight = 'tableWeight';
final String columnWeightYear = 'weightYear';
final String columnWeightMonth = 'weightMonth';
final String columnWeightDay = 'weightDay';
final String columnWeightValue = 'weightValue';

class WeightData {
  int id;
  int year;
  int month;
  int day;
  int weightValue = 0;

  WeightData();

  Map<String, dynamic> toDbMap() {
    var map = <String, dynamic>{
      columnWeightYear: year,
      columnWeightMonth: month,
      columnWeightDay: day,
      columnWeightValue: weightValue,
    };
    return map;
  }

  WeightData.fromDbMap(Map<String, dynamic> map) {
    id = map[columnId];
    year = map[columnWeightYear];
    month = map[columnWeightMonth];
    day = map[columnWeightDay];
    weightValue = map[columnWeightValue];
  }
}
