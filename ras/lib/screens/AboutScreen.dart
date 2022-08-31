import 'package:flutter/material.dart';
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
    'assets/logos/logoAera.jpeg',
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
                  'Reforestation Assistant & Simulator',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.grey.shade700),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      side: BorderSide(color: Colors.blue, width: 1),
                    ),
                    onPressed: () {
                    _launchURL('https://github.com/LiquidGalaxyLAB/reforestation-assistant-simulator/blob/main/PrivacyPolicy.md');
                    },
                    child: Text('View Privacy Policy'),
                  ),
                ),
              Text(
                'Contributors',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Text(
                '\n Syed Ali Ahmed (GSoC 2022)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
              Text(
                '\n Karine Pistili (GSoC 2021)\n',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
              Text(
                'Mentors',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Text(
                '\n Lot Amorós & Karine Pistili (GSoC 2022)\n\n Lot Amorós (GSoC 2021)\n',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
              Text(
                'Contact Us',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL('https://www.github.com/whysyed');
                },
                child: Text(
                  '\nSyed\'s Github',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL('https://github.com/KarinePistili');
                },
                child: Text(
                  '\nKarine\'s Github',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                ),
              ),
              Text(
                '\nOur partners',
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
                          width: screenSize.width / 5,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.05, vertical: 30),
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
              Text(
                'Description',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
                Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  'This project was created during the Google Summer of Code 2021 and was continued in Google Summer of Code 2022 alongside the Liquid Galaxy and Dronecoria organizations. \n\nThis open source project consists of an app to help plan and monitor reforestation projects either by sowning drones or manually. \n\nUsers can plan the reforesting missions, by defining areas of seeding, specific seed/tree location, drone landing points, fly zones and other helpful metrics. All the gathered information can be dynamically displayed on the Liquid Galaxy cluster using KMLs and also on the app with the help of charts and text to bring users a great and immersive overview of each projects\' panorama.\n',
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                'Learn more',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Text(
                '\nTo get to know more about Dronecoria and Liquid Galaxy Projects you can check out their websites and github. \n',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL('https://www.liquidgalaxy.eu/');
                },
                child: Text(
                  'Liquid Galaxy website \n',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL('https://github.com/LiquidGalaxyLAB/reforestation-assistant-simulator');
                },
                child: Text(
                  'RAS 2 Project GitHub\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL('https://dronecoria.org/en/main/');
                },
                child: Text(
                  'Dronecoria website',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                ),
              ),
              Text(
                '\nThank you for the authors of the icons used on this app. \n',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL('https://www.freepik.com/');
                },
                child: Text(
                  'Icons by freepik',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:10.0),
                child: GestureDetector(
                  onTap: () {
                    _launchURL('https://github.com/LiquidGalaxyLAB/reforestation-assistant/files/6994243/license-47124069.pdf/');
                  },
                  child: Text(
                    'Icons License',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, color: Colors.blue),
                  ),
                ),
              ),
              Text(
                '\nLleida Liquid Galaxy LAB support',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Text(
                '\n Pau Francino',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
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
