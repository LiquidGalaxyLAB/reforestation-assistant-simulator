import 'dart:async';

import 'package:flutter/material.dart';

// List of images
final List<String> images = [
  'assets/logos/logo_RAS_3.png',
  'assets/logos/logoLg.png',
  'assets/logos/logoGsoc.png',
  'assets/logos/logoWtm.png',
  'assets/logos/logoLgLab.png',
  'assets/logos/logoLgEu.png',
  'assets/logos/logoTic.png', 
  'assets/logos/logoPcital.jpg',
  'assets/logos/logoFacens.png', 
  'assets/logos/logoDronecoria.png', 
];

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    Duration duration = Duration(seconds: 5);

    return Timer(duration, pushToHome);
  }

  pushToHome() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: Image.asset(
                    images[0],
                    fit: BoxFit.contain,
                  ),
                ),
                width: screenSize.width / 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: Text('Reforestation Assistant & Simulator', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.grey.shade700),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05),
                    child: Container(
                      child: Center(
                        child: Image.asset(
                          images[1],
                          fit: BoxFit.contain,
                        ),
                      ),
                      width: screenSize.width / 5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05),
                    child: Container(
                      child: Center(
                        child: Image.asset(
                          images[2],
                          fit: BoxFit.contain,
                        ),
                      ),
                      width: screenSize.width / 5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05),
                    child: Container(
                      child: Center(
                        child: Image.asset(
                          images[3],
                          fit: BoxFit.contain,
                        ),
                      ),
                      width: screenSize.width / 5,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Center(
                      child: Image.asset(
                        images[4],
                        fit: BoxFit.contain,
                      ),
                    ),
                    width: screenSize.width / 5,
                  ),
                  Container(
                    child: Center(
                      child: Image.asset(
                        images[5],
                        fit: BoxFit.contain,
                      ),
                    ),
                    width: screenSize.width / 5,
                  ),
                  Container(
                    child: Center(
                      child: Image.asset(
                        images[6],
                        fit: BoxFit.contain,
                      ),
                    ),
                    width: screenSize.width / 5,
                  ),
                  Container(
                    child: Center(
                      child: Image.asset(
                        images[7],
                        fit: BoxFit.contain,
                      ),
                    ),
                    width: screenSize.width / 5,
                  ),
                ],
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Center(
                      child: Image.asset(
                        images[8],
                        fit: BoxFit.contain,
                      ),
                    ),
                    width: screenSize.width / 5,
                  ),
                  Container(
                    child: Center(
                      child: Image.asset(
                        images[9],
                        fit: BoxFit.contain,
                      ),
                    ),
                    width: screenSize.width / 3,
                  ),
                ],
              ),
              CircularProgressIndicator(),
              Text('Loading App...', style: TextStyle(color: Colors.grey),)
            ],
          ),
        ),
      ),
    );
  }
}