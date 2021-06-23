import 'package:ras/models/Seed.dart';
import 'package:ras/services/Database.dart';

class SeedRepository {
  final String _storeName = 'seeds';
  final DatabaseService _db = DatabaseService();

  create(Seed seed) {
    return _db.createEntry(_storeName, seed.toMap());
  }

  update(Seed seed, String id) {
    return _db.updateEntry(_storeName, id, seed.toMap());
  }

  getAll() {
    return _db.getAllEntries(_storeName);
  }

  getOne(String id) {
    return _db.getEntry(_storeName, id);
  }

  delete(String id) {
    return _db.deleteEntry(_storeName, id);
  }
}
