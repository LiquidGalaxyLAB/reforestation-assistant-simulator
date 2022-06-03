import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_translate/flutter_translate.dart';
import 'package:ras/widgets/AppBar.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  List<String> images = [
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: MyAppBar(
          isHome: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      images[0],
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                height: 100,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                child: Text(
                  translate("About.aboutpage"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.grey.shade700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  translate("About.message"),
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                translate("About.learn"),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Text(
                translate("About.check"),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL('https://www.liquidgalaxy.eu/');
                },
                child: Text(
                  translate("About.website"),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL(
                      'https://github.com/LiquidGalaxyLAB/reforestation-assistant-simulator');
                },
                child: Text(
                  translate("About.github"),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL('https://dronecoria.org/en/main/');
                },
                child: Text(
                  translate("About.drone"),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                ),
              ),
              Text(
                translate("About.icons"),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL('https://www.freepik.com/');
                },
                child: Text(
                  translate("About.freepik"),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () {
                    _launchURL(
                        'https://github.com/LiquidGalaxyLAB/reforestation-assistant/files/6994243/license-47124069.pdf/');
                  },
                  child: Text(
                    translate("About.License"),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, color: Colors.blue),
                  ),
                ),
              ),
              Text(
                translate("About.partner"),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.05, vertical: 30),
                        child: Container(
                          child: Center(
                            child: Image.asset(
                              images[1],
                              fit: BoxFit.contain,
                            ),
                          ),
                          width: screenSize.width / 6,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Center(
                            child: Image.asset(
                              images[8],
                              fit: BoxFit.contain,
                            ),
                          ),
                          width: screenSize.width / 4,
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
