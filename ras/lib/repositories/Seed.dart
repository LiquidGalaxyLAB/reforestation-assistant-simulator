import 'package:ras/models/Seed.dart';
import 'package:ras/services/Database.dart';

class SeedRepository {
  final String _storeName = 'seeds';
  final DatabaseService _db = DatabaseService();

  Future create(Seed seed) {
    return _db.createEntry(_storeName, seed.toMap());
  }

  Future update(Seed seed, String id) {
    return _db.updateEntry(_storeName, id, seed.toMap());
  }

  Future<List<Seed>>getAll() async {
    List<dynamic> entries = await _db.getAllEntries(_storeName);
    return Seed.toList(entries);
  }

  getOne(String id) {
    return _db.getEntry(_storeName, id);
  }

  delete(String id) {
    return _db.deleteEntry(_storeName, id);
  }
}
