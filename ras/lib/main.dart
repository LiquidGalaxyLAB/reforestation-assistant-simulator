import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ras/screens/AboutScreen.dart';
import 'package:ras/screens/HomeScreen.dart';
import 'package:ras/screens/ProjectBuilder.dart';
import 'package:ras/screens/ProjectView.dart';
import 'package:ras/screens/SeedForm.dart';
import 'package:ras/screens/Settings.dart';
import 'package:ras/screens/MapBuilder.dart';
import 'package:ras/screens/SplashScreen.dart';
import 'package:ras/screens/TestPlayground.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: 'RAS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/': (context) => MyHomePage(),
        '/splash': (context) => SplashScreen(),
        '/map': (context) => MapBuilder(),
        '/settings': (context) => Settings(),
        '/project-builder': (context) => ProjectBuilder(),
        '/about': (context) => AboutScreen(),
        '/seed-form': (context) => SeedForm(),
        '/project-view': (context) => ProjectView(),
        '/test': (context) => TestPlaygrounf(),
      },
    );
  }
}
