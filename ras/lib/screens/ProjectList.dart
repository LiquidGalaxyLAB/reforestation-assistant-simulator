import 'package:flutter/material.dart';
import 'package:ras/route-args/ProjectBuilderArgs.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({Key? key}) : super(key: key);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Text('Project List'),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0, right: 30.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                print('New project');
                Navigator.pushNamed(context, '/project-builder', arguments: ProjectBuilderArgs(true));
              },
              child: Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
