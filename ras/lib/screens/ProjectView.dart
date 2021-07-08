import 'package:flutter/material.dart';
import 'package:ras/models/Project.dart';
import 'package:ras/models/kml/Kml.dart';
import 'package:ras/repositories/Project.dart';
import 'package:ras/route-args/ProjectBuilderArgs.dart';
import 'package:ras/route-args/ProjectViewArgs.dart';
import 'package:ras/services/LGConnection.dart';
import 'package:ras/widgets/AppBar.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({Key? key}) : super(key: key);

  @override
  _ProjectViewState createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {

  launchToLG(ProjectViewArgs args) {
    Project? p = args.project;

    // create kml based on geodata attribute
    String content = KML.buildKMLContent(args.project.geodata.markers, args.project.geodata.areaPolygon);
    KML kml = KML(args.project.projectName, content);
    
    // send to LG
    LGConnection().sendToLG(kml.mount(), p)
    .then((value) => print('Yayy sent $value'))
    .catchError((onError) => print('oh no $onError'));

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
                    });
                    response.catchError((onError) => print('Error $onError'));
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        });
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
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '${args.project.projectName}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                subtitle: Text(
                    '${args.project.dateOfProject.toString().substring(0, 10)}'),
              ),
              Item('Area covered', 'XXm'),
              Item('Region', '${args.project.region}'),
              Item('Sown mode', '${args.project.sownMode}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    onPressed: () {
                      launchToLG(args);
                    },
                    label: Text('Launch'),
                    icon: Icon(Icons.play_circle_fill_outlined),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      side: BorderSide(color: Colors.blue, width: 1),
                    ),
                    onPressed: () {},
                    label: Text('Download'),
                    icon: Icon(Icons.download),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple,
                    ),
                    onPressed: () {},
                    label: Text('Map'),
                    icon: Icon(Icons.place),
                  ),
                ],
              ),
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                title: Text(
                  'Summary',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/project-builder',
                        arguments:
                            ProjectBuilderArgs(false, project: args.project),
                      );
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
                    ItemTitle('SOWING WINDOW TIME'),
                    Text('DATES',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            fontStyle: FontStyle.italic)),
                    Row(
                      children: [
                        Item(
                            'Min',
                            args.project.minSwtDate
                                .toString()
                                .substring(0, 10)),
                        Text(
                          ' | ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Item(
                            'Max',
                            args.project.maxSwtDate
                                .toString()
                                .substring(0, 10)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('TEMPERATURE',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              fontStyle: FontStyle.italic)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Item(
                              'Min', args.project.minSwtTemp.toString() + '°C'),
                          Text(
                            ' | ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Item(
                              'Max', args.project.maxSwtTemp.toString() + '°C'),
                        ],
                      ),
                    ),
                    Item('Average number of rain days',
                        args.project.avgNumberOfRains.toString()),
                    Item('Total number of rain days',
                        args.project.totalNumberOfRains.toString()),
                    ItemTitle('SPECIES INFORMATION'),
                    Item('Total CO2 capture', 'XXX'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('SEEDS',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              fontStyle: FontStyle.italic)),
                    ),
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
                                    ' seed/m²'),
                            Item('Survival probability', 'xxx'),
                            Item(
                                'Estimated CO2 capture',
                                args.project.seeds[i].co2PerYear.toString() +
                                    ' per year'),
                            Item(
                                'Estimated longevity',
                                args.project.seeds[i].estimatedLongevity
                                        .toString() +
                                    ' years'),
                            Item(
                                'Estimated final heigth',
                                args.project.seeds[i].estimatedFinalHeight
                                        .toString() +
                                    'm'),
                          ],
                        ),
                      ),
                    ItemTitle('AREA INFORMATION'),
                    Item('Valid surface',
                        args.project.validSurface.toString() + '%'),
                    Item('Invalid surface',
                        args.project.notValidSurface.toString() + '%'),
                    Item('Empty land', args.project.emptyLand.toString() + '%'),
                    Item('Orientation', args.project.orientation),
                    Item('Minimun altitude of the terrain',
                        args.project.minAltTerrain.toString() + 'm'),
                    Item('Maximum altitude of the terrain',
                        args.project.maxAltTerrain.toString() + 'm'),
                    Item('Maximum distance',
                        args.project.maxDistance.toString() + 'm'),
                    ItemTitle('SOIL ATTRIBUTES'),
                    Item('Depth', args.project.depth.toString() + 'm'),
                    Item('PH', args.project.ph.toString()),
                    Item('Fractured', args.project.fractured ? 'Yes' : 'No'),
                    Item('Hummus presence', args.project.hummus.toString()),
                    Item('Inclination', args.project.inclination.toString()),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
