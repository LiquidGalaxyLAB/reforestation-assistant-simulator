import 'package:flutter/material.dart';
import 'package:ras/models/Project.dart';
import 'package:ras/models/kml/Kml.dart';
import 'package:ras/models/kml/LookAt.dart';
import 'package:ras/models/kml/Orbit.dart';
import 'package:ras/repositories/Project.dart';
import 'package:ras/route-args/MapViewArgs.dart';
import 'package:ras/route-args/ProjectBuilderArgs.dart';
import 'package:ras/route-args/ProjectViewArgs.dart';
import 'package:ras/services/KmlGenerator.dart';
import 'package:ras/services/LGConnection.dart';
import 'package:ras/services/PdfGenerator.dart';
import 'package:ras/widgets/AppBar.dart';
import 'package:ras/widgets/SurvivalStackedChart.dart';
import 'package:ras/widgets/CO2Chart.dart';
import 'package:ras/widgets/PotentialCapture.dart';
import 'package:permission_handler/permission_handler.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({Key? key}) : super(key: key);

  @override
  _ProjectViewState createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  bool isOpen = false;
  bool isOrbiting = false;

  downloadKml(Project project) async {
    // create kml based on geodata attribute
    String content = KML.buildKMLContent(project.geodata.markers,
        project.geodata.areaPolygon, project.geodata.landingPoint);
    KML kml = KML(project.projectName, content);
    final kmlDone = kml.mount();

    var status = await Permission.storage.status;

    if (status.isGranted) {
      try {
        await KMLGenerator.generateKML(kmlDone, project.projectName);
        showAlertDialog('Success!',
            'You can find a KML containing the map data of the project in your Downloads folder');
      } catch (e) {
        print('error $e');
        showAlertDialog('Ops!',
            'You have to enable storage managing permissions to download the project KML');
      }
    } else {
      var isGranted = await Permission.storage.request().isGranted;
      if (isGranted) {
        // download kml
        try {
          await KMLGenerator.generateKML(kmlDone, project.projectName);
          showAlertDialog('Success!',
              'You can find a KML containing the map data of the project in your Downloads folder');
        } catch (e) {
          print('error $e');
          showAlertDialog('Ops!',
              'You have to enable storage managing permissions to download the project KML');
        }
      } else
        showAlertDialog('Ops!',
            'You have to enable storage managing permissions to download the project KML');
    }
  }

  downloadPdf(Project project) async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      PdfGenerator.generatePdf(project).then((value) {
        showAlertDialog('Success!',
            'You can find a PDF containing the summary of the project in your Downloads folder');
      }).catchError((onError) {
        showAlertDialog('Sorry',
            'An error occurred while downloading you PDF summary. Please try again later');
      });
    } else {
      var isGranted = await Permission.storage.request().isGranted;
      if (isGranted) {
        PdfGenerator.generatePdf(project).then((value) {
          showAlertDialog('Success!',
              'You can find a PDF containing the summary of the project in your Downloads folder');
        }).catchError((onError) {
          showAlertDialog('Sorry',
              'An error occurred while downloading you PDF summary. Please try again later');
        });
      } else
        showAlertDialog('Ops!',
            'You have to enable storage managing permissions to download the project summary');
    }
  }

  launchToLG(ProjectViewArgs args) {
    Project? p = args.project;

    // create kml based on geodata attribute
    String content = KML.buildKMLContent(args.project.geodata.markers,
        args.project.geodata.areaPolygon, args.project.geodata.landingPoint);
    KML kml = KML(args.project.projectName, content);

    // send to LG
    LGConnection().sendToLG(kml.mount(), p).then((value) {
      buildOrbit(args);
      setState(() {
        isOpen = true;
      });
    }).catchError((onError) {
      print('oh no $onError');
      if (onError == 'nogeodata')
        showAlertDialog('No GeoData',
            'It looks like you haven\'t added any geodata to this project. Use the map on area definition to place seeds and mark areas');
      showAlertDialog('Error launching!',
          'An error occurred while trying to connect to LG');
    });
  }

  playOrbit() async {
    await LGConnection().startOrbit();
    setState(() {
      isOrbiting = true;
    });
  }

  stopOrbit() async {
    await LGConnection().stopOrbit();
    setState(() {
      isOrbiting = false;
    });
  }

  buildOrbit(ProjectViewArgs args) async {
    Project? p = args.project;

    String content = '';

    if (p.geodata.landingPoint.name != 'none') {
      content = Orbit.generateOrbitTag(p.geodata.landingPoint.lookAt);
    } else if (p.geodata.areaPolygon.coord.length > 0) {
      content = Orbit.generateOrbitTag(LookAt(
          p.geodata.areaPolygon.coord[0].longitude,
          p.geodata.areaPolygon.coord[0].latitude,
          '1492.665945696469',
          '0',
          '0'));
    } else {
      content = Orbit.generateOrbitTag(p.geodata.markers[0].lookAt);
    }

    String kml = Orbit.buildOrbit(content);

    await LGConnection().buildOrbit(kml);
  }

  cleanVisualization() {
    LGConnection().cleanVisualization().then((value) {
      setState(() {
        isOpen = false;
      });
    }).catchError((onError) {
      print('oh no $onError');
      showAlertDialog('Error launching!',
          'An error occurred while trying to connect to LG');
    });
  }

  showAlertDialog(String title, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$title'),
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

  showDeleteDialog(String title, String msg, String id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$title'),
            content: Text('$msg'),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  child: Text("NO"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  child: Text("YES"),
                  onPressed: () {
                    // delete seed
                    Future response = ProjectRepository().delete(id);
                    response.then((value) {
                      print('Success!!');
                      Navigator.pop(context);
                      Navigator.of(context).pop({"reload": true});
                    });
                    response.catchError((onError) => print('Error $onError'));
                  },
                ),
              ),
            ],
          );
        });
  }

   getCO2(ProjectViewArgs args) {
    Project? p = args.project;
    double totalCO2 = 0;
    final diff = DateTime.now().difference(DateTime.parse(p.dateOfProject.toString()));
    p.seeds.forEach((element) {
    totalCO2 += element.co2PerYear;
    });
    double CO2 = diff.inDays*(totalCO2/365);
    return CO2.toStringAsFixed(3);
  }

    getCO2Planned(ProjectViewArgs args) {
    Project? p = args.project;
    double totalCO2 = 0;
    final diff = DateTime.now().difference(DateTime.parse(p.dateOfProject.toString()));
    p.seeds.forEach((element) {
    totalCO2 += element.co2PerYear;
    });
    double days = diff.inDays + (365.3*8);
    double CO2 = days*(totalCO2/365);
    return CO2.toStringAsFixed(3);
  }

  getSeedballs(double volume, double diameter) {
    double seedballs = 0;
    if(diameter == null || volume == null){
        return seedballs.toString();
    }
    double radius = diameter/20;
    seedballs = (15136*(volume/100))/(radius*radius*radius);
    return seedballs.toStringAsFixed(0);
  }

  getFlights(double volume, double diameter) {
    double flights = 0;
    if(diameter == null || volume == null){
        return flights.toString();
    }
    double radius = diameter/20;
    flights = (15136*(volume/100))/(radius*radius*radius);
    flights = 500000 / flights;
    return flights.toStringAsFixed(2);
  }

    getTotalFlights(ProjectViewArgs args) {
    double flights = 0;
    args.project.seeds.forEach((element) {
      double vol = args.project.sizeOfDeposit;
      double diameter = element.seedballDiameter;
      flights += double.parse(getFlights(vol, diameter));
    });
    return flights.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ProjectViewArgs;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: MyAppBar(
          isHome: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              ListTile(
                trailing: args.project.sownMode == 'By Drone'
                    ? Image.asset(
                        'assets/appIcons/drone.png',
                        height: 30,
                        width: 30,
                      )
                    : Image.asset(
                        'assets/appIcons/seeds.png',
                        height: 30,
                        width: 30,
                      ),
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '${args.project.projectName}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                subtitle: Text(
                    '${args.project.dateOfProject.toString().substring(0, 10)}'),
              ),
              Item('Region', '${args.project.region}'),
              Item('Sown mode', '${args.project.sownMode}'),
              isOpen
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          onPressed: () {
                            cleanVisualization();
                          },
                          label: Text('Clean KML'),
                          icon: Icon(Icons.clear_rounded),
                        ),
                        !isOrbiting
                            ? ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                ),
                                onPressed: () {
                                  playOrbit();
                                },
                                label: Text('Orbit'),
                                icon: Icon(Icons.rotate_left_outlined),
                              )
                            : ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                ),
                                onPressed: () {
                                  stopOrbit();
                                },
                                label: Text('Stop orbiting'),
                                icon: Icon(Icons.stop_circle_outlined),
                              ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        !isOpen
                            ? ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                ),
                                onPressed: () {
                                  launchToLG(args);
                                },
                                label: Text('Launch to Liquid Galaxy'),
                                icon: Icon(Icons.play_circle_fill_outlined),
                              )
                            : SizedBox(),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/map-view',
                                arguments: MapViewArgs(args.project.geodata));
                          },
                          label: Text('See Map'),
                          icon: Icon(Icons.place),
                        ),
                      ],
                    ),
              !isOpen
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red.shade400,
                            side: BorderSide(
                                color: Colors.red.shade400, width: 1),
                          ),
                          onPressed: () {
                            downloadPdf(args.project);
                          },
                          label: Text('Download PDF'),
                          icon: Icon(Icons.download),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            side: BorderSide(color: Colors.blue, width: 1),
                          ),
                          onPressed: () {
                            downloadKml(args.project);
                          },
                          label: Text('Download KML'),
                          icon: Icon(Icons.download),
                        ),
                      ],
                    )
                  : SizedBox(),
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                title: Text(
                  'Summary',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                trailing: IconButton(
                    onPressed: () async {
                      dynamic response = await Navigator.pushNamed(
                        context,
                        '/project-builder',
                        arguments:
                            ProjectBuilderArgs(false, project: args.project),
                      );

                      if (response != null) {
                        if (response['reload'])
                          Navigator.of(context).pop({"reload": true});
                      }
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.black,
                    )),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ItemTitle('BASIC INFORMATION'),
                    Item('Project name', args.project.projectName),
                    Item('Date',
                        args.project.dateOfProject.toString().substring(0, 10)),
                    Item('Sown mode', args.project.sownMode),
                    ItemTitle('PROJECT INFORMATION'),
                    Item('Total Flights', getTotalFlights(args)),
                    Item('CO2 capture until today', getCO2(args).toString() + ' kg'),
                    Item('CO2 capture planned', getCO2Planned(args).toString() + ' kg'),
                    Item('Size of Deposit', args.project.sizeOfDeposit.toString() + ' liters'),
                    ItemTitle('SOWING WINDOW TIME'),
                    Row(
                      children: [
                        Expanded(
                        child: Item(
                            'From',
                            args.project.minSwtDate
                                .toString()
                                .substring(0, 10)),
                        ),
                        Expanded(
                        child: Item(
                            'To',
                            args.project.maxSwtDate
                                .toString()
                                .substring(0, 10)),
                        ),
                      ],
                    ),
                    Item('Min Temp', args.project.minSwtTemp.toString() + '°C'),
                    Item('Max Temp', args.project.maxSwtTemp.toString() + '°C'),
                    Item('Average number of rain days',
                        args.project.avgNumberOfRains.toString()),
                    Item('Total number of rain days',
                        args.project.totalNumberOfRains.toString()),
                    ItemTitle('SPECIES INFORMATION'),
                    for (var i = 0; i < args.project.seeds.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Column(
                          children: [
                            Item('Common name',
                                args.project.seeds[i].commonName),
                            Item(
                                'Density',
                                args.project.seeds[i].density.toString() +
                                    ' plants per hectare'),
                            Item('Survival probability', 'xxx'),
                            Item(
                                'Estimated CO2 capture',
                                args.project.seeds[i].co2PerYear.toString() +
                                    ' kg per year'),
                            Item(
                                'Estimated longevity',
                                args.project.seeds[i].estimatedLongevity
                                        .toString() +
                                    ' years'),
                            Item(
                                'Estimated final height',
                                args.project.seeds[i].estimatedFinalHeight
                                        .toString() +
                                    'm'),
                            Item(
                                'Seedball Diameter',
                                args.project.seeds[i].seedballDiameter.toString() +
                                    ' mm'),
                            Item('Number of Seedballs', getSeedballs(args.project.sizeOfDeposit, args.project.seeds[i].seedballDiameter)),
                            Item('Number of Flights', getFlights(args.project.sizeOfDeposit, args.project.seeds[i].seedballDiameter)),
                          ],
                        ),
                      ),
                    ItemTitle('AREA INFORMATION'),
                    Item('Area covered',
                        args.project.areaCovered.toStringAsFixed(2).replaceAll(RegExp(r'([.]*00)(?!.*\d)'), '') + 'm²'),
                    Item('Optimal surface',
                        args.project.validSurface.toString() + '%'),
                    Item('Invalid surface',
                        args.project.notValidSurface.toString() + '%'),
                    Item('Empty land', args.project.emptyLand.toString() + '%'),
                    Item('Orientation', args.project.orientation),
                    Item('Min. terrain altitude',
                        args.project.minAltTerrain.toStringAsFixed(2).replaceAll(RegExp(r'([.]*00)(?!.*\d)'), '') + 'm'),
                    Item('Max. terrain altitude',
                        args.project.maxAltTerrain.toStringAsFixed(2).replaceAll(RegExp(r'([.]*00)(?!.*\d)'), '') + 'm'),
                    Item('Minimum flight height',
                        '~' + args.project.minFlightHeight.toString() + 'm'),
                    Item('Maximum distance',
                        args.project.maxDistance.toStringAsFixed(2).replaceAll(RegExp(r'([.]*00)(?!.*\d)'), '') + 'm'),
                    Item('Predation', args.project.predation.toString() + '%'),
                    ItemTitle('SOIL ATTRIBUTES'),
                    Item('Depth', args.project.depth.toStringAsFixed(5).replaceAll(RegExp(r'([.]*00000)(?!.*\d)'), '') + 'm'),
                    Item('PH', args.project.ph.toString()),
                    Item('Fractured', args.project.fractured ? 'Yes' : 'No'),
                    Item('Hummus presence', args.project.hummus.toString()),
                    Item(
                        'Inclination',
                        args.project.inclination.toString() +
                            '%' +
                            ' | ${((args.project.inclination / 100) * 360).toStringAsFixed(2)}°'),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28.0),
                    child: Text(
                      'Survival Information',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                  args.project.seeds.length > 0
                      ? SurvivalStackedChart(args.project.seeds)
                      : Center(
                          child: Text(
                            'No data',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                    Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28.0),
                    child: Text(
                      'Potential CO2 Capture',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                  args.project.seeds.length > 0
                      ? PotentialCapture(args.project.seeds)
                      : Center(
                          child: Text(
                            'No data',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28.0),
                    child: Text(
                      'Total CO2 capture per species',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                  args.project.seeds.length > 0
                      ? CO2Chart(args.project.seeds)
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              'No data',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    onPressed: () {
                      showDeleteDialog(
                          'Are you sure?',
                          'This action can\'t be undone and you will be deleting your project!',
                          args.project.id);
                    },
                    label: Text('Delete project'),
                    icon: Icon(Icons.delete_forever),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ItemTitle extends StatelessWidget {
  final String title;
  const ItemTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Text(
        '$title',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final String label;
  final String content;

  const Item(this.label, this.content);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            '$content',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
