import 'package:flutter/material.dart';
import 'package:ras/widgets/AppBar.dart';

class ProjectBuilder extends StatefulWidget {
  const ProjectBuilder({Key? key}) : super(key: key);

  @override
  _ProjectBuilderState createState() => _ProjectBuilderState();
}

class _ProjectBuilderState extends State<ProjectBuilder> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  tapped(int step){
    setState(() => _currentStep = step);
  }

  continued(){
    _currentStep < 7 ?
        setState(() => _currentStep += 1): null;
  }
  cancel(){
    _currentStep > 0 ?
        setState(() => _currentStep -= 1) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: MyAppBar(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Stepper(
                  type: stepperType,
                  physics: ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  onStepContinue:  continued,
                  onStepCancel: cancel,
                  steps: <Step>[
                     Step(
                      title: new Text('Basic Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      content: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Project Name *'),
                          ),
                          Text('TO DO')
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep == 0 ? StepState.editing : StepState.indexed,
                    ),
                     Step(
                      title: new Text('Sowing window time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      content: Column(
                        children: <Widget>[
                          Text('TO DO'),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep == 1 ? StepState.editing : StepState.indexed,
                    ),
                     Step(
                      title: new Text('Select Species', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      content: Column(
                        children: <Widget>[
                         Text('TO DO'),
                        ],
                      ),
                      isActive:_currentStep >= 0,
                      state: _currentStep == 2 ? StepState.editing : StepState.indexed,
                    ),
                    Step(
                      title: new Text('Area definition', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      content: Column(
                        children: <Widget>[
                         Text('TO DO'),
                        ],
                      ),
                      isActive:_currentStep >= 0,
                      state: _currentStep == 3 ? StepState.editing : StepState.indexed,
                    ),
                    Step(
                      title: new Text('Area attributes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      content: Column(
                        children: <Widget>[
                         Text('TO DO'),
                        ],
                      ),
                      isActive:_currentStep >= 0,
                      state: _currentStep == 4 ? StepState.editing : StepState.indexed,
                    ),
                    Step(
                      title: new Text('Soil attributes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      content: Column(
                        children: <Widget>[
                         Text('TO DO'),
                        ],
                      ),
                      isActive:_currentStep >= 0,
                      state: _currentStep == 5 ? StepState.editing : StepState.indexed,
                    ),
                    Step(
                      title: new Text('Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      content: Column(
                        children: <Widget>[
                         Text('TO DO'),
                        ],
                      ),
                      isActive:_currentStep >= 0,
                      state: _currentStep == 6 ? StepState.editing : StepState.indexed,
                    ),
                    Step(
                      title: new Text('Saving', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      content: Column(
                        children: <Widget>[
                         Text('TO DO'),
                        ],
                      ),
                      isActive:_currentStep >= 0,
                      state: _currentStep == 7 ? StepState.editing : StepState.indexed,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
