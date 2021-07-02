import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ras/models/Project.dart';
import 'package:ras/models/Seed.dart';
import 'package:ras/repositories/Project.dart';
import 'package:ras/repositories/Seed.dart';
import 'package:ras/route-args/ProjectBuilderArgs.dart';
import 'package:ras/widgets/AppBar.dart';

class ProjectBuilder extends StatefulWidget {
  const ProjectBuilder({Key? key}) : super(key: key);

  @override
  _ProjectBuilderState createState() => _ProjectBuilderState();
}

class _ProjectBuilderState extends State<ProjectBuilder> {
  Future<List<Seed>> _listSeeds = SeedRepository().getAll();

  int _currentStep = 0;
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
  // MAP INFO ?

  // AREA ATTRIBUTES
  TextEditingController validSurface = TextEditingController();
  TextEditingController notValidSurface = TextEditingController();
  TextEditingController emptyLand = TextEditingController();
  String orientation = 'North';
  TextEditingController minAltTerrain = TextEditingController();
  TextEditingController maxAltTerrain = TextEditingController();
  TextEditingController maxDistance = TextEditingController();

  // SOIL ATTRIBUTES
  TextEditingController depth = TextEditingController();
  TextEditingController ph = TextEditingController();
  String fractured = 'No';
  TextEditingController hummus = TextEditingController();
  TextEditingController inclination = TextEditingController();

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
                  icon: Icon(Icons.close),
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
                                  value: seeds.contains(data[index]),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != null) {
                                        setState(() {
                                          if (value)
                                            seeds.add(data[index]);
                                          else
                                            seeds.removeWhere((element) =>
                                                element.id == data[index].id);
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
                            child: Text('Loading data...'),
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
            title: Text('$title'),
            content: Text('$msg'),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: ElevatedButton(
                  child: Text("CLOSE"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        });
  }

  _saveProject(ProjectBuilderArgs args) {
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
      );
      Future response = ProjectRepository().create(project);
      response.then((value) {
        print('Success!!!! $value');
        Navigator.of(context).pop();
      });
      response.catchError((onError) => print('Error $onError'));
    }
  }

  initForm() {
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
  }

  @override
  void initState() {
    initForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ProjectBuilderArgs;

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
                  controlsBuilder: (BuildContext context,
                      {VoidCallback? onStepContinue,
                      VoidCallback? onStepCancel}) {
                    return Row(
                      children: <Widget>[],
                    );
                  },
                  type: stepperType,
                  physics: ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  // onStepContinue: continued,
                  // onStepCancel: cancel,
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
                              'Project name',
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
                                    showHelpDialog('Project name', '...');
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
                                    showHelpDialog('Date of project', '...');
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
                                    showHelpDialog('Sown mode', '...');
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
                                    showHelpDialog('Region', '...');
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
                              'SOWING DATE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            'Min.',
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
                                    showHelpDialog(
                                        'Minimum sowing date', '...');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Max.',
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
                                    showHelpDialog(
                                        'Maximum sowing date', '...');
                                  },
                                  icon: Icon(Icons.help)),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 15),
                            child: Text(
                              'TEMPERATURE',
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
                                      'Min.',
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
                                      'Max.',
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
                                        'Average temperature', '...');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Average number of rain days',
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
                                        'Average number of rain days', '...');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Total days of rain',
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
                                    showHelpDialog('Total days of rain', '...');
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
                                title: Text('${seeds[i].commonName}'),
                                subtitle: Text('${seeds[i].scientificName}'),
                                trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      seeds.removeWhere((element) =>
                                          element.id == seeds[i].id);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                )),
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
                                  primary: Colors.blueGrey),
                              child: Text(
                                'Open Map',
                                style: TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/map');
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
                              'Valid surface (1-100)%',
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
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Valid surface', '...');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Invalid surface (1-100)%',
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
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Invalid surface', '...');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Empty land (1-100)%',
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
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Empty land', '...');
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
                                    showHelpDialog('Orientation', '...');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Minimum altitude of the terrain',
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
                                        'Minimum altitude of the terrain',
                                        '...');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Maximum altitude of terrain',
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
                                        'Maximum altitude of terrain', '...');
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
                                    showHelpDialog('Maximum distance', '...');
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
                              'Depth(meters)',
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
                                    showHelpDialog('Depth', '...');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'PH (0-14)',
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
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('PH', '...');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Fractured',
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
                                    showHelpDialog('Fractured', '...');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Hummus presence (1-10)',
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
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showHelpDialog('Hummus', '...');
                                  },
                                  icon: Icon(Icons.help))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5),
                            child: Text(
                              'Inclination',
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
                                    showHelpDialog('Inclination', '...');
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
              MediaQuery.of(context).viewInsets.bottom == 0
                  ? Row(
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
                              } else
                                print('ooppsss throw error');
                            },
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
