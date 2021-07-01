import 'package:ras/models/Project.dart';

class ProjectBuilderArgs {
  bool isNew;
  Project? project;

  ProjectBuilderArgs(this.isNew, {this.project});
}
