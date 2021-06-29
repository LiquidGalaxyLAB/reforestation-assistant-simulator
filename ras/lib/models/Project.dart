import 'package:ras/models/Seed.dart';

class Project {
  // BASIC INFORMATION
  String projectName;
  DateTime dateOfProject;
  String sownMode;
  String region;

  // SOWING WINDOW TIME
  DateTime minSwtDate;
  DateTime maxSwtDate;
  double minSwtTemp;
  double maxSwtTemp;
  int avgNumberOfRains;
  int totalNumberOfRains;

  // SEEDS
  List<Seed> seeds;

  // AREA ATTRIBUTES
  double validSurface;
  double notValidSurface;
  double emptyLand;
  String orientation;
  double minAltTerrain;
  double maxAltTerrain;
  double maxDistance;

  // SOIL ATTRIBUTES
  double depth;
  int ph;
  bool fractured;
  int hummus;
  double inclination;

  Project(
    this.projectName,
    this.dateOfProject,
    this.sownMode,
    this.region,
    this.minSwtDate,
    this.maxSwtDate,
    this.minSwtTemp,
    this.maxSwtTemp,
    this.avgNumberOfRains,
    this.totalNumberOfRains,
    this.seeds,
    this.validSurface,
    this.notValidSurface,
    this.emptyLand,
    this.orientation,
    this.minAltTerrain,
    this.maxAltTerrain,
    this.maxDistance,
    this.depth,
    this.ph,
    this.fractured,
    this.hummus,
    this.inclination,
  );

  @override
  String toString() {
    return 'Name=> ${this.projectName}; Date=> ${this.dateOfProject}; Seeds=> ${this.seeds}';
  }
}
