import 'package:flutter/material.dart';
import 'package:ras/route-args/ProjectViewArgs.dart';
import 'package:ras/widgets/AppBar.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({ Key? key }) : super(key: key);

  @override
  _ProjectViewState createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
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
      body: Center(
        child: Text('Project View Id = ${args.id}'),
      ),
    );
  }
}