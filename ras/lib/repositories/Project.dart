import 'package:ras/models/Project.dart';
import 'package:ras/services/Database.dart';

class ProjectRepository {
  final String _storeName = 'projects';
  final DatabaseService _db = DatabaseService();

  Future create(Project project) {
    return _db.createEntry(_storeName, project.toMap());
  }

  Future update(Project project, String id) {
    return _db.updateEntry(_storeName, id, project.toMap());
  }

  Future<List<Project>>getAll() async {
    List<dynamic> entries = await _db.getAllEntries(_storeName);
    return Project.toList(entries);
  }

  getOne(String id) {
    return _db.getEntry(_storeName, id);
  }

  delete(String id) {
    return _db.deleteEntry(_storeName, id);
  }
}