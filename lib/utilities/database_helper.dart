import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:anime_archive/utilities/anime.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper _databaseHelper =
      DatabaseHelper._privateConstructor();
  static Database? _database;

  String animeTable = 'anime_table';
  String colId = 'id';
  String colATitleNative = 'aTitleNative';
  String colATitleRomanji = 'aTitleRomanji';

  factory DatabaseHelper() {
    return _databaseHelper;
  }

  Future<Database?> get database async {
    _database ??= await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}anime.db';

    var animeDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return animeDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
    CREATE TABLE $animeTable(
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colATitleNative TEXT,
      $colATitleRomanji TEXT
    )
  ''');
  }

  // Fetch
  Future<List<Map<String, dynamic>>> getAnimeMapList() async {
    Database? db = await database;
    try {
      var result = await db!.query(animeTable, orderBy: '$colId DESC');
      return result;
    } catch (e) {
      return [];
    }
  }

  // Insert
  Future<int> insertAnime(Anime anime) async {
    Database? db = await database;
    var result = await db!.insert(animeTable, anime.toMap());
    return result;
  }

  // Update
  Future<int> updateAnime(Anime anime) async {
    var db = await database;
    var result = await db!.update(animeTable, anime.toMap(),
        where: '$colId = ?', whereArgs: [anime.id]);
    return result;
  }

  // Delete
  Future<int> deleteAnime(int id) async {
    var db = await database;
    int result =
        await db!.rawDelete('DELETE FROM $animeTable WHERE $colId = $id');
    return result;
  }

  // Delete All
  Future<int> deleteAllAnime() async {
    var db = await database;
    int result = await db!.rawDelete('DELETE FROM $animeTable');
    return result;
  }

  // Get count
  Future<int?> getCount() async {
    Database? db = await database;
    List<Map<String, dynamic>> queryResult =
        await db!.rawQuery('SELECT COUNT (*) from $animeTable');
    int? result = Sqflite.firstIntValue(queryResult);
    return result;
  }

  // Get map list
  Future<List<Anime>> getAnimeList() async {
    var animeMapList = await getAnimeMapList();
    int count = animeMapList.length;

    List<Anime> animeList = <Anime>[];
    for (int i = 0; i < count; i++) {
      animeList.add(Anime.fromMapObject(animeMapList[i]));
    }

    return animeList;
  }
}
