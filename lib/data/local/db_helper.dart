// Multiple instance is not create of single database because a database is single
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

//why singelton Singleton class create for database
// only create a static single instance of database
class DBHelper {
  // singleton   --private constructer to achive
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();

  // table name and column name
  static final String TABLE_NOTE = "note";
  static final String COL_NOTE_SN = "s_no";
  static final String COL_NOTE_TITLE = "title";
  static final String COL_NOTE_DESC = "desc";

  Database? myDB;

  // Open DB
  //ifexist    --check open
  //not exist  --crete
  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    // get db path
    Directory appDir = await getApplicationDocumentsDirectory();

    // check if not exist and create or exist open
    return await openDatabase(join(appDir.path, "noteDB.db"),
        onCreate: (db, version) {
      // //
      db.execute(
          "CREATE TABLE $TABLE_NOTE ($COL_NOTE_SN INTEGER PRIMARY KEY AUTOINCREMENT, $COL_NOTE_TITLE TEXT, $COL_NOTE_DESC TEXT)");
      // n number of table
    }, version: 1);
  }

  // all queries
  // 1.insertion add node
  Future<bool> addNote({required String mTitle, required String mDesc}) async {
    return await (await getDB()).insert(
            TABLE_NOTE, {COL_NOTE_TITLE: mTitle, COL_NOTE_DESC: mDesc}) >
        0;
  }

  // 2.fetch    get notes
  Future<List<Map<String, Object?>>> getNotes() async {
    // select * from table
    return await (await getDB()).query(TABLE_NOTE);
  }

  // 3.update
  Future<bool> updateNotes(
      {required int sno, required String title, required String desc}) async {
    return await (await getDB()).update(
            TABLE_NOTE, {COL_NOTE_TITLE: title, COL_NOTE_DESC: desc},
            where: "$COL_NOTE_SN = ?", whereArgs: ['$sno']) >
        0;
  }

  // 4.delete
  Future<bool> deleteNotes({required int sno}) async {
    return await (await getDB()).delete(TABLE_NOTE,
            where: "$COL_NOTE_SN = ?", whereArgs: ["$sno"]) >
        0;
  }
}

// How to get instance of data
// DBHelper db=DBHelper.getInstance();
