import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ras/@fakedb/Projects.dart';
import 'package:ras/@fakedb/Seeds.dart';
import 'package:ras/repositories/Project.dart';
import 'package:ras/repositories/Seed.dart';
import 'package:ras/screens/AboutScreen.dart';
import 'package:ras/screens/HomeScreen.dart';
import 'package:ras/screens/ProjectBuilder.dart';
import 'package:ras/screens/ProjectView.dart';
import 'package:ras/screens/SeedForm.dart';
import 'package:ras/screens/Settings.dart';
import 'package:ras/screens/MapBuilder.dart';
import 'package:ras/screens/SigninScreen.dart';
import 'package:ras/screens/SplashScreen.dart';
import 'package:ras/screens/TestPlayground.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  checkLocalStorage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? isFirst = preferences.getBool('first_time');
    if (isFirst == null || isFirst) {
      await preferences.setBool('first_time', false);
      populateAppWithMockData();
    }
  }

  populateAppWithMockData() {
    FakeSeeds.seeds.forEach((element) async {
      await SeedRepository().create(element);
    });
    FakeProjects.projects.forEach((element) async {
      await ProjectRepository().create(element);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Fix orientation
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Check if it is first time on the app, if it is first time, load mockdata
    checkLocalStorage();

    return MaterialApp(
      title: 'RAS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/': (context) => MyHomePage(),
        '/login': (context) => SignInScreen(),
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
