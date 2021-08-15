import 'dart:convert';
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/utils/sembast_import_export.dart';
import 'package:ras/@fakedb/Database.dart';

class DatabaseService {
  final String _dbName = 'ras.db';
  final DatabaseFactory _dbFactory = databaseFactoryIo;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future createEntry(String storeName, data) async {
    String path = (await _localPath) + '/$_dbName';
    Database db = await _dbFactory.openDatabase(path);
    var store = stringMapStoreFactory.store(storeName);
    return await store.add(db, data);
  }

  updateEntry(String storeName, String key, data) async {
    String path = (await _localPath) + '/$_dbName';
    Database db = await _dbFactory.openDatabase(path);
    var store = stringMapStoreFactory.store(storeName);
    Finder finder = Finder(filter: Filter.byKey(key));
    return await store.update(db, data, finder: finder);
  }

  Future getEntry(String storeName, String key) async {
    String path = (await _localPath) + '/$_dbName';
    Database db = await _dbFactory.openDatabase(path);
    var store = stringMapStoreFactory.store(storeName);

    return await store.record(key).get(db);
  }

  Future<List> getAllEntries(String storeName) async {
    String path = (await _localPath) + '/$_dbName';
    Database db = await _dbFactory.openDatabase(path);
    var store = stringMapStoreFactory.store(storeName);
    List<RecordSnapshot<String, Map<String, dynamic>>> recordSnapshot =
        await store.find(db);
    return recordSnapshot.map((RecordSnapshot snapshot) {
      return snapshot;
    }).toList();
  }

  Future deleteEntry(String storeName, String key) async {
    String path = (await _localPath) + '/$_dbName';
    Database db = await _dbFactory.openDatabase(path);
    var store = stringMapStoreFactory.store(storeName);
    Finder finder = Finder(filter: Filter.byKey(key));
    return await store.delete(db, finder: finder);
  }

  Future exportDB() async {
    try {
      final downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
      String path = (await _localPath) + '/$_dbName';
      Database db = await _dbFactory.openDatabase(path);
      var content = await exportDatabase(db);
      // Save as text
      var saved = jsonEncode(content);
      var savePath = downloadsDirectory.path;
      final file = File("$savePath/ras-database.txt");
      await file.writeAsString(saved);
      return Future.value(file);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future importDB() async {
    // Import the data
    var map = FakeDatabase.data;
    var importedDb = await importDatabase(map, _dbFactory, (await _localPath) + '/$_dbName');
    print(importedDb);
  }
}
