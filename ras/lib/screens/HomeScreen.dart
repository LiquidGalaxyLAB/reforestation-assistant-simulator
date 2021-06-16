import 'package:flutter/material.dart';
import 'package:ras/screens/ProjectList.dart';
import 'package:ras/screens/SeedList.dart';
import 'package:ras/widgets/AppBar.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: MyAppBar(isHome: true),
        ),
        body: TabBarView(children: [
          Tab(
            child: ProjectList(),
          ),
          Tab(
            child: SeedList(),
          ),
        ]),
      ),
    );
  }
}
