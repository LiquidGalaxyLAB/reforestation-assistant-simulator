import 'package:flutter/material.dart';
import 'package:ras/widgets/AppBar.dart';
import 'package:ras/route-args/ProjectViewArgs.dart';

class MissionSize extends StatefulWidget {
  const MissionSize({Key? key}) : super(key: key);

  @override
  _MissionSizeState createState() => _MissionSizeState();
}

class _MissionSizeState extends State<MissionSize> {

    @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ProjectViewArgs;

    return Scaffold(appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: MyAppBar(
          isHome: false,
        ),
      ),);
  }

}