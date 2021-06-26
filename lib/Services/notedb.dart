import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_doctor/Model/note.dart';

class DB{
  static Database _database;

  final String tableName = 'notes';

  Future<Database> get db async {
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }
  initDB() async{
    var dir = await getDatabasesPath();
    String  path = join( dir ,'notedb.db');
    var database =  await openDatabase(
        path,
        version: 1,
        onCreate: (Database _db, int version )async{
          await _db.execute(

              'CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT,  date INTEGER, title TEXT, content TEXT)'


          );
        }
    );
    return database;
  }

  Future<void> add(Note note) async {
    var database = await db;
    note.setDate();
    await database.insert(tableName, note.toMap());
  }

  Future<void> update(Note note) async {
    var database = await db;
    note.setDate();
    await database.update(tableName, note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> delete(Note note) async {
    var database = await db;
    await database.delete(tableName, where: 'id = ?', whereArgs: [note.id]);
  }

  Future<List<Note>> getNotes() async {
    var database = await db;
    List<Map<String, dynamic>> maps = await database.rawQuery('SELECT * FROM $tableName ORDER BY date DESC');
    List<Note> notes = new List<Note>();
    if(maps !=null){
      for(Map<String, dynamic> map in maps) {
        notes.add(Note.fromMap(map));
      }
      return notes;

    }

  }




}