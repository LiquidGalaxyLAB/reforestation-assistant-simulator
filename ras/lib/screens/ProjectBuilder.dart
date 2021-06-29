import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ras/models/Seed.dart';
import 'package:ras/route-args/ProjectBuilderArgs.dart';
import 'package:ras/widgets/AppBar.dart';

class ProjectBuilder extends StatefulWidget {
  const ProjectBuilder({Key? key}) : super(key: key);

  @override
  _ProjectBuilderState createState() => _ProjectBuilderState();
}

class _ProjectBuilderState extends State<ProjectBuilder> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  final _formKey = GlobalKey<FormState>();
  // BASIC INFORMATION
  TextEditingController projectName = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String sownMode = 'By Drone';
  TextEditingController region = TextEditingController();

  // SOWING WINDOW TIME
  TextEditingController minSwtDate = TextEditingController();
  TextEditingController maxSwtdate = TextEditingController();
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
  TextEditingController orientation = TextEditingController();
  TextEditingController minAltTerrain = TextEditingController();
  TextEditingController maxAltTerrain = TextEditingController();
  TextEditingController maxDistance = TextEditingController();

  // SOIL ATTRIBUTES
  TextEditingController depth = TextEditingController();
  TextEditingController ph = TextEditingController();
  TextEditingController fractured = TextEditingController();
  TextEditingController hummus = TextEditingController();
  TextEditingController inclination = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2010, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 7 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
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
                  type: stepperType,
                  physics: ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  onStepContinue: continued,
                  onStepCancel: cancel,
                  steps: <Step>[
                    Step(
                      title: new Text(
                        'Basic Information',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
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
                                    _selectDate(context);
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
                                          '${selectedDate.toLocal()}'
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
                        'Sowing window time',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      content: Column(
                        children: <Widget>[
                          Text('TO DO'),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep == 1
                          ? StepState.editing
                          : StepState.indexed,
                    ),
                    Step(
                      title: new Text(
                        'Select seeds',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      content: Column(
                        children: <Widget>[
                          Text('TO DO'),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep == 2
                          ? StepState.editing
                          : StepState.indexed,
                    ),
                    Step(
                      title: new Text(
                        'Area definition',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
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
                        'Area attributes',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      content: Column(
                        children: <Widget>[
                          Text('TO DO'),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep == 4
                          ? StepState.editing
                          : StepState.indexed,
                    ),
                    Step(
                      title: new Text(
                        'Soil attributes',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      content: Column(
                        children: <Widget>[
                          Text('TO DO'),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep == 5
                          ? StepState.editing
                          : StepState.indexed,
                    ),
                    Step(
                      title: new Text(
                        'Summary',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      content: Column(
                        children: <Widget>[
                          Text('TO DO'),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep == 6
                          ? StepState.editing
                          : StepState.indexed,
                    ),
                    Step(
                      title: new Text(
                        'Saving',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      content: Column(
                        children: <Widget>[
                          Text('TO DO'),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep == 7
                          ? StepState.editing
                          : StepState.indexed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
