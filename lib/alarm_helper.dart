import 'dart:math';

import 'package:clock_app/models/alarm_info.dart';
import 'package:sqflite/sqflite.dart';

class AlarmHelper {
  static Database? _database;
  static AlarmHelper? _alarmHelper;
  final String tableName = 'alarm';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnDateTime = 'alarmDateTime';
  final String columnPending = 'isPending';
  final String columnColorIndex = 'gradientColorIndex';

  Future<Database> get database async {
    if (_database == null) {
      _database = await initialzeDatabase();
    }
    return _database!;
  }

  Future<Database> initialzeDatabase() async {
    final dir = await getDatabasesPath();
    final dbPath = dir + 'alarm.db';
    final database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''CREATE TABLE $tableName(
              $columnId integer PRIMARY KEY  AUTOINCREMENT,
            $columnTitle TEXT not null, 
            $columnDateTime TEXT not null, 
            $columnPending integer, 
            $columnColorIndex integer
      
            )''');
      },
    );
    return database;
  }

  void insertAlarm(AlarmInfo alarmInfo) async {
    final db = await database;

    final result = await db.insert(tableName, alarmInfo.toMap());
  }

  Future<List<AlarmInfo>> getAlarms() async {
    List<AlarmInfo> _alarms = [];
    final db = await database;
    final result = await db.query(tableName);

    result.forEach((row) {
      final alarmInfo = AlarmInfo.fromMap(row);
      _alarms.add(alarmInfo);
    });
    return _alarms;
  }

  Future<int?> getLastAlarmid() async {
    AlarmInfo lastAlarm;
    final db = await database;
    final result = await db.query(tableName);
    lastAlarm = AlarmInfo.fromMap(result.last);

    return lastAlarm.id;
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(tableName, where: '$columnId =?', whereArgs: [id]);
  }
}
