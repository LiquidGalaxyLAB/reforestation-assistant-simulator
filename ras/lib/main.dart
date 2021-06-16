import 'package:flutter/material.dart';
import 'package:ras/screens/AboutScreen.dart';
import 'package:ras/screens/HomeScreen.dart';
import 'package:ras/screens/ProjectBuilder.dart';
import 'package:ras/screens/SeedForm.dart';
import 'package:ras/screens/Settings.dart';
import 'package:ras/screens/MapBuilder.dart';
import 'package:ras/screens/TestPlayground.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/map': (context) => MapBuilder(),
        '/settings': (context) => Settings(),
        '/project-builder': (context) => ProjectBuilder(),
        '/about': (context) => AboutScreen(),
        '/seed-form': (context) => SeedForm(),
        '/test': (context) => TestPlaygrounf(),
      },
    );
  }
}
