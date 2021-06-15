import 'package:flutter/material.dart';
import 'package:ras/widgets/AppBar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssh/ssh.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String ipAddress = '';
  String password = '';

  createLocalFile() async {
    String localPath = await _localPath;
    print('local parth $localPath');
    File localFile = File('$localPath/testkml.kml');
    localFile.writeAsString('''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
	<name>testkml.kml</name>
	<Style id="s_ylw-pushpin_hl">
		<IconStyle>
			<scale>1.3</scale>
			<Icon>
				<href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
			</Icon>
			<hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
		</IconStyle>
	</Style>
	<Style id="s_ylw-pushpin">
		<IconStyle>
			<scale>1.1</scale>
			<Icon>
				<href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
			</Icon>
			<hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
		</IconStyle>
	</Style>
	<StyleMap id="m_ylw-pushpin">
		<Pair>
			<key>normal</key>
			<styleUrl>#s_ylw-pushpin</styleUrl>
		</Pair>
		<Pair>
			<key>highlight</key>
			<styleUrl>#s_ylw-pushpin_hl</styleUrl>
		</Pair>
	</StyleMap>
	<Placemark>
		<name>SOROCABA</name>
		<LookAt>
			<longitude>-47.45251900638822</longitude>
			<latitude>-23.50152714811598</latitude>
			<altitude>0</altitude>
			<heading>-3.732990949085341e-08</heading>
			<tilt>0</tilt>
			<range>30825.51191490768</range>
			<gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
		</LookAt>
		<styleUrl>#m_ylw-pushpin</styleUrl>
		<Point>
			<gx:drawOrder>1</gx:drawOrder>
			<coordinates>-47.45251900638822,-23.50152714811598,0</coordinates>
		</Point>
	</Placemark>
</Document>
</kml>
''');
    sendToLG('$localPath/testkml.kml');
  }

  sendToLG(String localPath) async {
    SSHClient client = SSHClient(
      host: ipAddress,
      port: 22,
      username: "lg",
      passwordOrKey: password,
    );

    try {
      await client.connect();
      await client.execute('> /var/www/html/kmls.txt');
      await client.connectSFTP();
      await client.sftpUpload(
        path: localPath,
        toPath: '/var/www/html',
        callback: (progress) {
          print('Sent $progress');
        },
      );
      await client.execute('echo "http://lg1:81/testkml.kml" > /var/www/html/kmls.txt');
    } catch (e) {
      print('Could not connect to host LG');
    }
  }

  init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    ipAddress = preferences.getString('master_ip') ?? '';
    password = preferences.getString('master_password') ?? '';
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    init();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: MyAppBar(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome! App under development',
            ),
            ElevatedButton(
              onPressed: () => {Navigator.pushNamed(context, '/map')},
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // background
                onPrimary: Colors.white, // foreground
              ),
              child: Text('Go to map screen'),
            ),
             ElevatedButton(
              onPressed: () => {Navigator.pushNamed(context, '/project-builder')},
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // background
                onPrimary: Colors.white, // foreground
              ),
              child: Text('Go to Project Builder'),
            ),
            ElevatedButton(
              onPressed: () => {createLocalFile()},
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // background
                onPrimary: Colors.white, // foreground
              ),
              child: Text('Send KML to LG'),
            )
          ],
        ),
      ),
    );
  }
}
