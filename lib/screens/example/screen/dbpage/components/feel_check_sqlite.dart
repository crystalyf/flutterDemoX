import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'feel_check_data.dart';

class FeelCheckSqlite {
  Database db;

  final String tableFeelCheck = 'feelCheck';
  final String columnId = '_id';
  final String columnRelax = 'relax';
  final String columnActive = 'active';
  final String columnHeartRate = 'heartRate';
  final String columnBodyDegreeValue = 'bodyDegreeValue';
  final String columnDateTime = 'dateTime';
  final String columnTag = 'tag';
  final String columnTimeType = 'timeType';

  openSqlite() async {
    // 获取数据库文件的存储路径
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

///根据数据库文件路径和数据库版本号创建数据库表
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE $tableFeelCheck (
            $columnId INTEGER PRIMARY KEY, 
            $columnRelax INTEGER, 
            $columnActive INTEGER, 
            $columnHeartRate INTEGER, 
            $columnBodyDegreeValue INTEGER, 
            $columnDateTime TEXT, 
            $columnTag INTEGER, 
            $columnTimeType INTEGER)
          ''');
        });
  }


  ///Sqlite数据入库都是以Map的形式，查出也是Map的形式

  // 插入一条书籍数据
  Future<FeelCheckData> insert(FeelCheckData book) async {
    book.id = await db.insert(tableFeelCheck, book.toDbMap());
    return book;
  }

  // 查找所有书籍信息
  Future<List<FeelCheckData>> queryAll() async {
    List<Map> maps = await db.query(tableFeelCheck, columns: [
      columnId,
      columnRelax,
      columnActive,
      columnHeartRate,
      columnBodyDegreeValue,
      columnDateTime,
      columnTag,
      columnTimeType
    ]);
    if (maps == null || maps.length == 0) {
      return null;
    }
    List<FeelCheckData> books = [];
    for (int i = 0; i < maps.length; i++) {
      books.add(FeelCheckData.fromDbMap(maps[i]));
    }
    return books;
  }

  // // 根据ID查找书籍信息
  // Future<Book> getBook(int id) async {
  //   List<Map> maps = await db.query(tableBook,
  //       columns: [
  //         columnId,
  //         columnName,
  //         columnAuthor,
  //         columnPrice,
  //         columnPublishingHouse
  //       ],
  //       where: '$columnId = ?',
  //       whereArgs: [id]);
  //   if (maps.length > 0) {
  //     return Book.fromMap(maps.first);
  //   }
  //   return null;
  // }

  // 根据ID删除书籍信息
  Future<int> delete(int id) async {
    return await db.delete(tableFeelCheck, where: '$columnId = ?', whereArgs: [id]);
  }

  // 更新书籍信息
  Future<int> update(FeelCheckData book) async {
    return await db.update(tableFeelCheck, book.toDbMap(),
        where: '$columnId = ?', whereArgs: [book.id]);
  }

  // 记得及时关闭数据库，防止内存泄漏
  close() async {
    await db.close();
  }
}

