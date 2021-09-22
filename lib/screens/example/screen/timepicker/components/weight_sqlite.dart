import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'weight_data.dart';
///体重 sqlite
class WeightSqlite {
  Database db;

  final String tableWeight = 'weight';
  final String columnId = '_id';
  final String columnWeightYear = 'weightYear';
  final String columnWeightMonth = 'weightMonth';
  final String columnWeightDay = 'weightDay';
  final String columnWeightValue = 'weightValue';

  openSqlite() async {
    // 获取数据库文件的存储路径
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

///根据数据库文件路径和数据库版本号创建数据库表
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE $tableWeight (
            $columnId INTEGER PRIMARY KEY, 
            $columnWeightYear INTEGER, 
            $columnWeightMonth INTEGER, 
            $columnWeightDay INTEGER, 
            $columnWeightValue INTEGER)
          ''');
        });
  }


  ///Sqlite数据入库都是以Map的形式，查出也是Map的形式

  // 插入一条书籍数据
  Future<WeightData> insert(WeightData weight) async {
    weight.id = await db.insert(tableWeight, weight.toDbMap());
    return weight;
  }

  // 查找所有书籍信息
  Future<List<WeightData>> queryAll() async {
    List<Map> maps = await db.query(tableWeight, columns: [
      columnId,
      columnWeightYear,
      columnWeightMonth,
      columnWeightDay,
      columnWeightValue,
    ]);
    if (maps == null || maps.length == 0) {
      return null;
    }
    List<WeightData> datas = [];
    for (int i = 0; i < maps.length; i++) {
      datas.add(WeightData.fromDbMap(maps[i]));
    }
    return datas;
  }

  // 记得及时关闭数据库，防止内存泄漏
  close() async {
    await db.close();
  }
}

