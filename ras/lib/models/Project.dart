import 'package:ras/models/Gmap.dart';
import 'package:ras/models/Seed.dart';
import 'package:sembast/timestamp.dart';

class Project {
  String id;

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
  double minFlightHeight;
  double areaCovered;

  // SOIL ATTRIBUTES
  double depth;
  int ph;
  bool fractured;
  int hummus;
  double inclination;
  double predation;
  double sizeOfDeposit;
  double sizeOfSeedballs;

  // GMAP - KML
  Gmap geodata;

  Project(
    this.id,
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
    this.geodata,
    this.minFlightHeight,
    this.predation,
    this.sizeOfDeposit,
    this.sizeOfSeedballs,
    this.areaCovered,
  );

  @override
  String toString() {
    return 'Name=> ${this.projectName}; Date=> ${this.dateOfProject}; Seeds=> ${this.seeds}';
  }

  Map<String, dynamic> toMap() {
    List mapSeeds = [];
    seeds.forEach((element) {
      mapSeeds.add(element.toMap());
    });

    return {
      "id": id,
      "projectName": projectName,
      "dateOfProject": Timestamp.fromDateTime(dateOfProject),
      "sownMode": sownMode,
      "region": region,
      "minSwtDate": Timestamp.fromDateTime(minSwtDate),
      "maxSwtDate": Timestamp.fromDateTime(maxSwtDate),
      "minSwtTemp": minSwtTemp,
      "maxSwtTemp": maxSwtTemp,
      "avgNumberOfRains": avgNumberOfRains,
      "totalNumberOfRains": totalNumberOfRains,
      "seeds": mapSeeds,
      "validSurface": validSurface,
      "notValidSurface": notValidSurface,
      "emptyLand": emptyLand,
      "orientation": orientation,
      "minAltTerrain": minAltTerrain,
      "maxAltTerrain": maxAltTerrain,
      "maxDistance": maxDistance,
      "depth": depth,
      "ph": ph,
      "fractured": fractured,
      "hummus": hummus,
      "inclination": inclination,
      "geodata": geodata.toMap(),
      "minFlightHeight": minFlightHeight,
      "predation": predation,
      "sizeOfDeposit": sizeOfDeposit,
      "sizeOfSeedballs": sizeOfSeedballs,
      "areaCovered": areaCovered,
    };
  }

  static List<Project> toList(List<dynamic> list) {
    List<Project> projects = [];
    list.forEach((element) {
      List<Seed> seedList = [];
      seedList = Seed.fromMapList(element.value['seeds']);
      projects.add(Project(
        element.key,
        element.value['projectName'],
        DateTime.fromMillisecondsSinceEpoch(element.value['dateOfProject'].millisecondsSinceEpoch),
        element.value['sownMode'],
        element.value['region'],
        DateTime.fromMillisecondsSinceEpoch(element.value['minSwtDate'].millisecondsSinceEpoch),
        DateTime.fromMillisecondsSinceEpoch(element.value['maxSwtDate'].millisecondsSinceEpoch),
        element.value['minSwtTemp'],
        element.value['maxSwtTemp'],
        element.value['avgNumberOfRains'],
        element.value['totalNumberOfRains'],
        seedList,
        element.value['validSurface'],
        element.value['notValidSurface'],
        element.value['emptyLand'],
        element.value['orientation'],
        element.value['minAltTerrain'],
        element.value['maxAltTerrain'],
        element.value['maxDistance'],
        element.value['depth'],
        element.value['ph'],
        element.value['fractured'],
        element.value['hummus'],
        element.value['inclination'],
        Gmap.fromMap(element.value['geodata']),
        element.value['minFlightHeight'],
        element.value['predation'],
        element.value['sizeOfDeposit'],
        element.value['sizeOfSeedballs'],
        element.value['areaCovered'],
      ));
    });
    return projects;
  }
}
