import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';

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
}
