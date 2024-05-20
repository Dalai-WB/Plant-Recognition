import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static late Database _database;

  DatabaseHelper._internal();

  Future<Database> _openDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'plants.db');
    bool exists = await databaseExists(path);
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load('assets/plants.db');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }

    _database = await openDatabase(path);
    return _database;
  }

  Future<List<Map<String, dynamic>>> getData(String scientificName) async {
    Database db = await _openDatabase();
    return await db.rawQuery('''
    SELECT plantDetails.*
    FROM plantDetails
    JOIN plants ON plants.id = plantDetails.plantId
    WHERE plants.scientificName = ?
  ''', [scientificName]);
  }

  Future<List<Map<String, dynamic>>> getDatas(
      String scientificName) async {
    Database db = await _openDatabase();
    return await db.rawQuery('''
      SELECT plantDetails.*, plants.scientificName
      FROM plantDetails
      JOIN plants ON plants.id = plantDetails.plantId
      WHERE plants.scientificName LIKE ?
      LIMIT 5
    ''', ['%$scientificName%']);
  }
}
