import 'dart:async';
//import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createtable(sql.Database database) async {
    await database.execute("""CREATE TABLE table(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('database.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await (createtable(database));
    });
  }

  static Future<int> insertItem(String title) async {
    final db = await SQLHelper.db();
    final data = {'title': title};
    final id = await db.insert('table', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('table', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('table', where: "id=?", whereArgs: [id], limit: 1);
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('table', where: "id=?", whereArgs: [id]);
    } catch (err) {}
  }
}
