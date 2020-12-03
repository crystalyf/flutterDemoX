import 'feel_check_tag_enum.dart';
import 'feel_check_time_tag_enum.dart';

final String columnId = '_id';
final String tableFeelCheck = 'feelCheck';
final String columnRelax = 'relax';
final String columnActive = 'active';
final String columnHeartRate = 'heartRate';
final String columnBodyDegreeValue = 'bodyDegreeValue';
final String columnDateTime = 'dateTime';
final String columnTag = 'tag';
final String columnTimeType = 'timeType';

class FeelCheckData {
  int id;
  int relax;
  int active;
  int heartRate;
  int bodyDegreeValue = 0;
  String dateTime;
  FeelCheckTag tag;
  FeelCheckTimeTag timeType;

  FeelCheckData();

  //sqlite数据库，表数据要转成Map再存储。
  Map<String, dynamic> toDbMap() {
    var map = <String, dynamic>{
      columnRelax: relax,
      columnActive: active,
      columnHeartRate: heartRate,
      columnBodyDegreeValue: bodyDegreeValue,
      columnDateTime: dateTime,
      columnTag: enumToMap(FeelCheckTag.values, tag),
      columnTimeType: enumToMap(FeelCheckTimeTag.values, timeType)
    };
    return map;
  }

  FeelCheckData.fromDbMap(Map<String, dynamic> map) {
    id = map[columnId];
    relax = map[columnRelax];
    active = map[columnActive];
    heartRate = map[columnHeartRate];
    bodyDegreeValue = map[columnBodyDegreeValue];
    dateTime = map[columnDateTime];
    tag = mapToEnum(FeelCheckTag.values, map[columnTag]);
    timeType = mapToEnum(FeelCheckTimeTag.values, map[columnTimeType]);
  }

  //Enum的转换
  T mapToEnum<T>(List<T> values, int value) {
    if (value == null) {
      return null;
    }
    return values[value];
  }

  dynamic enumToMap<T>(List<T> values, T value) {
    if (value == null) {
      return null;
    }
    var result = values.indexOf(values.firstWhere((v) => v == value));
    return result;
  }
}
