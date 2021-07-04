import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final String databaseName = "database.sqlite";

  static Future<Database> dbConnection() async {
    String databasePath = join(await getDatabasesPath(), databaseName);

    if (await databaseExists(databasePath)) {
      print("Database is ready in place.No need to push.");
    } else {
      ByteData data = await rootBundle.load("database/${databaseName}");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(databasePath).writeAsBytes(bytes, flush: true);
      print("Database Copied.");
    }

    return openDatabase(databasePath);
  }
}
