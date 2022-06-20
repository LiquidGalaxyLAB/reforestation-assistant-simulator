import 'package:flutter/material.dart';
import 'package:ras/models/Gmap.dart';
import 'package:ras/models/Project.dart';
import 'package:ras/models/Seed.dart';
import 'package:ras/models/kml/LookAt.dart';
import 'package:ras/models/kml/Placemark.dart';
import 'package:ras/models/kml/Point.dart';
import 'package:ras/models/kml/Polygon.dart';
import 'package:ras/repositories/Project.dart';
import 'package:ras/repositories/Seed.dart';
import 'package:ras/route-args/MapBuilderArgs.dart';
import 'package:ras/route-args/ProjectBuilderArgs.dart';
import 'package:ras/services/ElevationApi.dart';
import 'package:ras/widgets/AppBar.dart';

class ProjectBuilder extends StatefulWidget {
  const ProjectBuilder({Key? key}) : super(key: key);

  @override
  _ProjectBuilderState createState() => _ProjectBuilderState();
}

class _ProjectBuilderState extends State<ProjectBuilder> {
  Future<List<Seed>> _listSeeds = SeedRepository().getAll();

  int _currentStep = 0;
  bool onEnter = true;
  StepperType stepperType = StepperType.vertical;
  final _formKey = GlobalKey<FormState>();
  // BASIC INFORMATION
  TextEditingController projectName = TextEditingController();
  DateTime dateOfProject = DateTime.now();
  String sownMode = 'By Drone';
  TextEditingController region = TextEditingController();

  // SOWING WINDOW TIME
  DateTime minSwtDate = DateTime.now();
  DateTime maxSwtdate = DateTime.now();
  TextEditingController minSwtTemp = TextEditingController();
  TextEditingController maxSwtTemp = TextEditingController();
  TextEditingController avgNumberOfRains = TextEditingController();
  TextEditingController totalNumberOfRains = TextEditingController();

  // SEEDS TABLE
  List<Seed> seeds = [];

  // MAP INFO
  Gmap geodata = Gmap(
    [],
    Polygon('', []),
    Placemark(
        '',
        '',
        '',
        LookAt(
          0,
          0,
          '',
          '',
          '',
        ),
        Point(0, 0),
        ''),
  );

  // AREA ATTRIBUTES
  TextEditingController validSurface = TextEditingController();
  TextEditingController notValidSurface = TextEditingController();
  TextEditingController emptyLand = TextEditingController();
  String orientation = 'North';
  TextEditingController minAltTerrain = TextEditingController();
  TextEditingController maxAltTerrain = TextEditingController();
  TextEditingController maxDistance = TextEditingController();
  TextEditingController minFlightHeight = TextEditingController();
  TextEditingController areaCovered = TextEditingController();

  // SOIL ATTRIBUTES
  TextEditingController depth = TextEditingController();
  TextEditingController ph = TextEditingController();
  String fractured = 'No';
  TextEditingController hummus = TextEditingController();
  TextEditingController inclination = TextEditingController();
  TextEditingController predation = TextEditingController();
  TextEditingController sizeOfDeposit = TextEditingController();
  TextEditingController sizeOfSeedballs = TextEditingController();

  calculateAltitudeOfTerrain() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as ProjectBuilderArgs;

    List<String> coordinates = [];

    args.project!.geodata.areaPolygon.coord.forEach((element) {
      String coord = '';
      coord = '${element.latitude},${element.longitude}';
      coordinates.add(coord);
    });

    try {
      List elevation = await ElevationAPi.getElevationOfArea(coordinates);

      if (elevation.isNotEmpty) {
        elevation.sort((a, b) => a.compareTo(b));
        minAltTerrain.text = elevation.last.toString();
        maxAltTerrain.text = elevation.first.toString();
        minFlightHeight.text =
            ((elevation.last + elevation.first) / 2).toString();
      } else {
        showHelpDialog('Sorry!',
            'We could not find altitude information from Open Topo Data API for the region you selected');
      }
    } catch (e) {
      print('Error getting info from Open Topo Data $e');
    }
  }

  Future<void> _selectDate(BuildContext context, int type) async {
    switch (type) {
      case 0:
        final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: dateOfProject,
            firstDate: DateTime(2010, 8),
            lastDate: DateTime(2101));
        if (picked != null && picked != dateOfProject)
          setState(() {
            dateOfProject = picked;
          });
        break;
      case 1:
        final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: minSwtDate,
            firstDate: DateTime(2010, 8),
            lastDate: DateTime(2101));
        if (picked != null && picked != minSwtDate)
          setState(() {
            minSwtDate = picked;
          });
        break;
      case 2:
        final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: maxSwtdate,
            firstDate: DateTime(2010, 8),
            lastDate: DateTime(2101));
        if (picked != null && picked != maxSwtdate)
          setState(() {
            maxSwtdate = picked;
          });
        break;
      default:
    }
  }

  _selectSeeds() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Choose seeds'),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter alertState) {
              return FutureBuilder(
                  future: _listSeeds,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<Seed> data = snapshot.data;
                      return Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                  title: Text('${data[index].commonName}'),
                                  subtitle:
                                      Text('${data[index].scientificName}'),
                                  value: seeds.any((element) =>
                                      element.id == data[index].id ||
                                      element.commonName ==
                                          data[index].commonName),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != null) {
                                        setState(() {
                                          if (value) {
                                            seeds.add(data[index]);
                                            seeds[seeds.length - 1].density = 0;
                                          } else
                                            seeds.removeWhere((element) =>
                                                element.id == data[index].id ||
                                                element.commonName ==
                                                    data[index].commonName);
                                        });
                                        alertState(() {});
                                      }
                                    });
                                  });
                            }),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Column(
                        children: [
                          SizedBox(
                            child: CircularProgressIndicator(),
                            width: 60,
                            height: 60,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Loading data...',
                                style: TextStyle(color: Colors.grey)),
                          )
                        ],
                      );
                    }
                  });
            }),
          );
        });
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  showHelpDialog(String title, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text('$title')),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            content: Text('$msg'),
          );
        });
  }

  _saveProject(ProjectBuilderArgs args) {
    seeds.forEach((element) {
      if (element.density == null) element.density = 0;
    });
    if (args.isNew) {
      Project project = Project(
        '',
        projectName.text,
        dateOfProject,
        sownMode,
        region.text,
        minSwtDate,
        maxSwtdate,
        double.parse(minSwtTemp.text),
        double.parse(maxSwtTemp.text),
        int.parse(avgNumberOfRains.text),
        int.parse(totalNumberOfRains.text),
        seeds,
        double.parse(validSurface.text),
        double.parse(notValidSurface.text),
        double.parse(emptyLand.text),
        orientation,
        double.parse(minAltTerrain.text),
        double.parse(maxAltTerrain.text),
        double.parse(maxDistance.text),
        double.parse(depth.text),
        int.parse(ph.text),
        fractured == 'Yes' ? true : false,
        int.parse(hummus.text),
        double.parse(inclination.text),
        geodata,
        double.parse(minFlightHeight.text),
        double.parse(predation.text),
        double.parse(sizeOfDeposit.text),
        double.parse(sizeOfSeedballs.text),
        double.parse(areaCovered.text),
      );
      Future response = ProjectRepository().create(project);
      response.then((value) {
        print('Success!!!! $value');
        Navigator.of(context).pop({"reload": true});
      });
      response.catchError((onError) => print('Error $onError'));
    } else {
      Project project = Project(
        args.project!.id,
        projectName.text,
        dateOfProject,
        sownMode,
        region.text,
        minSwtDate,
        maxSwtdate,
        double.parse(minSwtTemp.text),
        double.parse(maxSwtTemp.text),
        int.parse(avgNumberOfRains.text),
        int.parse(totalNumberOfRains.text),
        seeds,
        double.parse(validSurface.text),
        double.parse(notValidSurface.text),
        double.parse(emptyLand.text),
        orientation,
        double.parse(minAltTerrain.text),
        double.parse(maxAltTerrain.text),
        double.parse(maxDistance.text),
        double.parse(depth.text),
        int.parse(ph.text),
        fractured == 'Yes' ? true : false,
        int.parse(hummus.text),
        double.parse(inclination.text),
        geodata,
        double.parse(minFlightHeight.text),
        double.parse(predation.text),
        double.parse(sizeOfDeposit.text),
        double.parse(sizeOfSeedballs.text),
        double.parse(areaCovered.text),
      );
      Future response = ProjectRepository().update(project, args.project!.id);
      response.then((value) {
        print('Success!!!! $value');
        Navigator.of(context).pop({"reload": true});
      });
      response.catchError((onError) => print('Error $onError'));
    }
  }

  init(ProjectBuilderArgs args) async {
    if (!args.isNew) {
      projectName.text = args.project!.projectName;
      dateOfProject = args.project!.dateOfProject;
      sownMode = args.project!.sownMode;
      region.text = args.project!.region;
      minSwtDate = args.project!.minSwtDate;
      maxSwtdate = args.project!.maxSwtDate;
      minSwtTemp.text = args.project!.minSwtTemp.toString();
      maxSwtTemp.text = args.project!.maxSwtTemp.toString();
      avgNumberOfRains.text = args.project!.avgNumberOfRains.toString();
      totalNumberOfRains.text = args.project!.totalNumberOfRains.toString();
      seeds = args.project!.seeds;
      validSurface.text = args.project!.validSurface.toString();
      notValidSurface.text = args.project!.notValidSurface.toString();
      emptyLand.text = args.project!.emptyLand.toString();
      orientation = args.project!.orientation;
      minAltTerrain.text = args.project!.minAltTerrain.toString();
      maxAltTerrain.text = args.project!.maxAltTerrain.toString();
      maxDistance.text = args.project!.maxDistance.toString();
      depth.text = args.project!.depth.toString();
      ph.text = args.project!.ph.toString();
      fractured = args.project!.fractured ? 'Yes' : 'No';
      hummus.text = args.project!.hummus.toString();
      inclination.text = args.project!.inclination.toString();
      minFlightHeight.text = args.project!.minFlightHeight.toString();
      predation.text = args.project!.predation.toString();
      sizeOfDeposit.text = args.project!.sizeOfDeposit.toString();
      sizeOfSeedballs.text = args.project!.sizeOfSeedballs.toString();
      areaCovered.text = args.project!.areaCovered.toString();

      // map info
      geodata = args.project!.geodata;
    } else {
      minSwtTemp.text = '0';
      maxSwtTemp.text = '0';
      avgNumberOfRains.text = '0';
      totalNumberOfRains.text = '0';
      validSurface.text = '0';
      notValidSurface.text = '0';
      emptyLand.text = '0';
      minAltTerrain.text = '0';
      maxAltTerrain.text = '0';
      maxDistance.text = '0';
      depth.text = '0';
      ph.text = '0';
      hummus.text = '0';
      inclination.text = '0';
      minFlightHeight.text = '0';
      predation.text = '0';
      sizeOfDeposit.text = '0';
      sizeOfSeedballs.text = '0';
      areaCovered.text = '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ProjectBuilderArgs;
    if (onEnter) {
      init(args);
      onEnter = false;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: MyAppBar(
          isHome: false,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Stepper(
                  controlsBuilder: (BuildContext context, ControlsDetails controls) {
                    return Row(
                      children: <Widget>[],
                    );
                  },
                  type: stepperType,
                  physics: ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  steps: <Step>[
                    Step(
                      title: new Text(
                        'BASIC INFORMATION',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue),
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Project name*',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: projectName,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a project name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Project name',
                                        'A name for the project');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Date of project',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _selectDate(context, 0);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black))),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child:
                                              Icon(Icons.calendar_today_sharp),
                                        ),
                                        Text(
                                          '${dateOfProject.toLocal()}'
                                              .split(' ')[0],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Date of project',
                                        'Date when the project will be started');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Sown mode',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      sownMode = 'By Drone';
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      border: sownMode == 'By Drone'
                                          ? Border.all(color: Colors.blue)
                                          : null,
                                    ),
                                    child: Text(
                                      'By Drone',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: sownMode == 'By Drone'
                                              ? Colors.blue
                                              : Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      sownMode = 'Manually';
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      border: sownMode == 'Manually'
                                          ? Border.all(color: Colors.blue)
                                          : null,
                                    ),
                                    child: Text(
                                      'Manually',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: sownMode == 'Manually'
                                              ? Colors.blue
                                              : Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Sown mode',
                                        'If the sown method will be either by drone or manually');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Region',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: region,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Region',
                                        'The region or zone of the project');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep == 0
                          ? StepState.editing
                          : StepState.indexed,
                    ),
                    Step(
                      title: new Text(
                        'SOWING WINDOW TIME',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue),
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 15),
                            child: Text(
                              'SOWING WINDOW',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            'Min. (date)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _selectDate(context, 1);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black))),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child:
                                              Icon(Icons.calendar_today_sharp),
                                        ),
                                        Text(
                                          '${minSwtDate.toLocal()}'
                                              .split(' ')[0],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Minimum sowing date',
                                        'The earliest date where is possible to perform sowing');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Max. (date)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _selectDate(context, 2);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black))),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child:
                                              Icon(Icons.calendar_today_sharp),
                                        ),
                                        Text(
                                          '${maxSwtdate.toLocal()}'
                                              .split(' ')[0],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Maximum sowing date (date)',
                                        'The latest date where is possible to perform the sowing');
                                  },
                                  icon: Icon(Icons.help)),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 15),
                            child: Text(
                              'SOWING WINDOW TEMPERATURES (Number, Celsium degrees -10 to 50)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Min. (°C)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    TextFormField(
                                      controller: minSwtTemp,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        filled: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Max. (°C)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    TextFormField(
                                      controller: maxSwtTemp,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        filled: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog(
                                        'Sowing Window temperatures (Number, Celsium degrees -10 to 50).',
                                        'The minimum and maximum medium temperature in the time frame of the sowing window.');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Average number of days of rain (Number, 0 to 31)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: avgNumberOfRains,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog(
                                        'Average number of days of rain (Number, 0 to 31)',
                                        'The average number of days that stays raining in each rain. This monthly information is delivered by the closest weather station of the site.');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Total days of rain (Number, 0 to 31)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: totalNumberOfRains,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog(
                                        'Total days of rain (Number, 0 to 31)',
                                        'The total days of rain in a specific month.. This monthly information is delivered by the closest weather station of the site.');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep == 1
                          ? StepState.editing
                          : StepState.indexed,
                    ),
                    Step(
                      title: new Text(
                        'SEED SPECIES',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue),
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueGrey),
                            onPressed: () {
                              _selectSeeds();
                            },
                            icon: Icon(Icons.check_box),
                            label: Text('Select seed'),
                          ),
                          for (var i = 0; i < seeds.length; i++)
                            ListTile(
                              leading: SizedBox(
                                width: 75,
                                height: 75,
                                child: TextFormField(
                                  // controller: density,
                                  initialValue: seeds[i].density == null
                                      ? '0.0'
                                      : seeds[i].density.toString(),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (seeds[i].density == null)
                                      seeds[i].density = 0;
                                    else {
                                      if (value.length > 0)
                                        seeds[i].density = double.parse(value);
                                      else
                                        seeds[i].density = 0;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      filled: true, helperText: 'Density'),
                                ),
                              ),
                              title: Text('${seeds[i].commonName}'),
                              subtitle: Text('${seeds[i].scientificName}'),
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    seeds.removeAt(i);
                                  });
                                },
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep == 2
                          ? StepState.editing
                          : StepState.indexed,
                    ),
                    Step(
                      title: new Text(
                        'AREA DEFINITION',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue),
                      ),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                                'Use the map to define the project area, location of seeds and drone landing points'),
                          ),
                          Flexible(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue),
                              child: Text(
                                'Open Map',
                                style: TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                              onPressed: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  '/map',
                                  arguments: MapBuilderArgs(
                                      geodata,
                                      geodata.areaPolygon.coord.isEmpty &&
                                              geodata.markers.isEmpty
                                          ? true
                                          : false,
                                      seeds),
                                );
                                if (result is Gmap) {
                                  geodata = result;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep == 3
                          ? StepState.editing
                          : StepState.indexed,
                    ),
                    Step(
                      title: new Text(
                        'AREA ATTRIBUTES',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue),
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Area covered (m²)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: areaCovered,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Area covered (m²)',
                                        'The area covered by the project in square meters');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Optimal Surface (% 0 to 100)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: validSurface,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                  validator: (value) {
                                    if (double.parse(value!) < 0 ||
                                        double.parse(value) > 100) {
                                      return 'Wrong range! Allowed values are 0 to 100';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog(
                                        'Optimal Surface (% 0 to 100)',
                                        '% of surface that is optimal for direct sowing, where the seeds have chance to survival close to nurse plant.');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Not Valid Surface (% 0 to 100)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: notValidSurface,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                  validator: (value) {
                                    if (double.parse(value!) < 0 ||
                                        double.parse(value) > 100) {
                                      return 'Wrong range! Allowed values are 0 to 100';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog(
                                        'Not Valid Surface (% 0 to 100)',
                                        '% of surface where seeds will not grow, like rocks or present trees.');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Empty Land (% 0 to 100)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: emptyLand,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                  validator: (value) {
                                    if (double.parse(value!) < 0 ||
                                        double.parse(value) > 100) {
                                      return 'Wrong range! Allowed values are 0 to 100';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Empty Land (% 0 to 100)',
                                        '% of surface where seeds could grow, but don’t have the optimal conditions because don’t have any nurse plant.');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Orientation',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  filled: true,
                                ),
                                items: <String>[
                                  'North',
                                  'Northeast',
                                  'Northwest',
                                  'South',
                                  'Southeast',
                                  'Southwest',
                                  'East',
                                  'West'
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                value: orientation,
                                onChanged: (value) {
                                  setState(() {
                                    orientation = value!;
                                  });
                                },
                              )),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Orientation',
                                        'The predominant orientation of the area of sowing.');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      calculateAltitudeOfTerrain();
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text(
                                          'Get area altitude from Open Topo Data'),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                      onPressed: () {
                                        showHelpDialog('Open Topo Data API',
                                            'Altitude information from the Open Topo Data API free dataset aster30m. The automatic values are Global and can have a resolution of ~30m. The source is from NASA ASTER Service');
                                      },
                                      icon: Icon(Icons.help)),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                            child: Text(
                              'Minimum altitude of the terrain (Meters above sea level)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: minAltTerrain,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog(
                                        'Minimum altitude of the terrain (Meters above sea level)',
                                        'The minimum altitude of the area at the lower point.');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Maximum altitude of the terrain (Meters above sea level)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: maxAltTerrain,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog(
                                        'Maximum altitude of the terrain (Meters above sea level)',
                                        'The maximum altitude of the area at the highest point.');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Minimum safe flight height (Meters)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: minFlightHeight,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog(
                                        'Minimum safe flight height (Meters)',
                                        'The minimum altitude of the area that is safe for a drone to fly');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Maximum distance (meters)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: maxDistance,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Maximum distance (meters)',
                                        'Maximum distance that will fly the drone between the take off point and the farthest point.');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Predation (% 0 to 100)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: predation,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                  validator: (value) {
                                    if (double.parse(value!) < 0 ||
                                        double.parse(value) > 100) {
                                      return 'Wrong range! Allowed values are 0 to 100';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Predation (%, 0 - 100)',
                                        'Predation in the area.');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Size of Deposit',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: sizeOfDeposit,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                  validator: (value) {
                                    if (double.parse(value!) < 0) {
                                      return 'Wrong range! Negative values are not allowed';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Size of Deposit (centimeters)',
                                        'Size of the Seed Deposit.');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Size of Seedballs',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: sizeOfSeedballs,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                  validator: (value) {
                                    if (double.parse(value!) < 0) {
                                      return 'Wrong range! Negative values are not allowed';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Size of Seedballs (centimeters)',
                                        'Average size of Seedballs.');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep == 4
                          ? StepState.editing
                          : StepState.indexed,
                    ),
                    Step(
                      title: new Text(
                        'SOIL ATTRIBUTES',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue),
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Soil Depth (Centimeters)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: depth,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Soil Depth (Centimeters)',
                                        'Depth of the soil.');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Soil PH (Number, 0-14)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: ph,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                  validator: (value) {
                                    if (double.parse(value!) < 0 ||
                                        double.parse(value) > 14) {
                                      return 'Wrong range! Allowed values are 0 to 14';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Soil PH (Number, 1-14)',
                                        'PH of the soil, if is basic or alkaline');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Rock fractured (yes/no)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      fractured = 'Yes';
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      border: fractured == 'Yes'
                                          ? Border.all(color: Colors.blue)
                                          : null,
                                    ),
                                    child: Text(
                                      'Yes',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: fractured == 'Yes'
                                              ? Colors.blue
                                              : Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      fractured = 'No';
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      border: fractured == 'No'
                                          ? Border.all(color: Colors.blue)
                                          : null,
                                    ),
                                    child: Text(
                                      'No',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: fractured == 'No'
                                              ? Colors.blue
                                              : Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Rock fractured (yes/no)',
                                        'If the soil is rocky, if the rocks are fractured or if it is a single piece.');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Hummus presence (Number, 0 to 10)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: hummus,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                  validator: (value) {
                                    if (double.parse(value!) < 0 ||
                                        double.parse(value) > 10) {
                                      return 'Wrong range! Allowed values are 0 to 10';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog(
                                        'Hummus presence (Number, 0 to 10)',
                                        'Presence of hummus, from 0 to 10. 0 for no hummus, and 10 for abundant presence.');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Area Inclination (%)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: inclination,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Area Inclination (%)',
                                        'Inclination in % of the area.');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep == 5
                          ? StepState.editing
                          : StepState.indexed,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 15)),
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _saveProject(args);
                        } else {
                          showHelpDialog('Invalid fields!',
                              'Some fields have invalid values or are required. Please check them again');
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
