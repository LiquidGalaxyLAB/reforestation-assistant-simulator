import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ras/widgets/AppBar.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssh/ssh.dart';

class TestPlaygrounf extends StatefulWidget {
  const TestPlaygrounf({Key? key}) : super(key: key);

  @override
  _TestPlaygrounfState createState() => _TestPlaygrounfState();
}

class _TestPlaygrounfState extends State<TestPlaygrounf> {
  String ipAddress = '';
  String password = '';

  createLocalFile() async {
    String localPath = await _localPath;
    print('local parth $localPath');
    File localFile = File('$localPath/REGION1.kml');
    localFile.writeAsString('''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
	<name>REGION1.kml</name>
	<Style id="s_ylw-pushpin_hl">
		<IconStyle>
			<scale>1.3</scale>
			<Icon>
				<href>http://maps.google.com/mapfiles/kml/paddle/grn-diamond.png</href>
			</Icon>
			<hotSpot x="32" y="1" xunits="pixels" yunits="pixels"/>
		</IconStyle>
		<ListStyle>
			<ItemIcon>
				<href>http://maps.google.com/mapfiles/kml/paddle/grn-diamond-lv.png</href>
			</ItemIcon>
		</ListStyle>
	</Style>
	<Style id="s_ylw-pushpin">
		<IconStyle>
			<scale>1.1</scale>
			<Icon>
				<href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
			</Icon>
			<hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
		</IconStyle>
		<LineStyle>
			<color>ff00ffff</color>
		</LineStyle>
		<PolyStyle>
			<color>b37fffff</color>
		</PolyStyle>
	</Style>
	<Style id="s_ylw-pushpin_hl0">
		<IconStyle>
			<scale>1.3</scale>
			<Icon>
				<href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
			</Icon>
			<hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
		</IconStyle>
		<LineStyle>
			<color>ff00ffff</color>
		</LineStyle>
		<PolyStyle>
			<color>b37fffff</color>
		</PolyStyle>
	</Style>
	<StyleMap id="m_ylw-pushpin">
		<Pair>
			<key>normal</key>
			<styleUrl>#s_ylw-pushpin0</styleUrl>
		</Pair>
		<Pair>
			<key>highlight</key>
			<styleUrl>#s_ylw-pushpin_hl</styleUrl>
		</Pair>
	</StyleMap>
	<Style id="s_ylw-pushpin0">
		<IconStyle>
			<scale>1.1</scale>
			<Icon>
				<href>http://maps.google.com/mapfiles/kml/paddle/grn-diamond.png</href>
			</Icon>
			<hotSpot x="32" y="1" xunits="pixels" yunits="pixels"/>
		</IconStyle>
		<ListStyle>
			<ItemIcon>
				<href>http://maps.google.com/mapfiles/kml/paddle/grn-diamond-lv.png</href>
			</ItemIcon>
		</ListStyle>
	</Style>
	<StyleMap id="m_ylw-pushpin0">
		<Pair>
			<key>normal</key>
			<styleUrl>#s_ylw-pushpin</styleUrl>
		</Pair>
		<Pair>
			<key>highlight</key>
			<styleUrl>#s_ylw-pushpin_hl0</styleUrl>
		</Pair>
	</StyleMap>
	<Folder>
		<name>REGION1</name>
		<Placemark>
			<name>Region1</name>
			<styleUrl>#m_ylw-pushpin0</styleUrl>
			<Polygon>
				<tessellate>1</tessellate>
				<outerBoundaryIs>
					<LinearRing>
						<coordinates>
							-47.52931532814348,-23.48824770740416,0 -47.53031759542059,-23.48779740819821,0 -47.5313584130239,-23.49276856012656,0 -47.53123244456581,-23.49375899388531,0 -47.5301614944787,-23.49318103442081,0 -47.53000662443083,-23.49244109352411,0 -47.52969250150048,-23.4905726871609,0 -47.52931532814348,-23.48824770740416,0 
						</coordinates>
					</LinearRing>
				</outerBoundaryIs>
			</Polygon>
		</Placemark>
		<Placemark>
			<name>Seed1</name>
			<LookAt>
				<longitude>-47.52653502290166</longitude>
				<latitude>-23.48891905879437</latitude>
				<altitude>0</altitude>
				<heading>-10.88388407177008</heading>
				<tilt>47.85114699982938</tilt>
				<range>1492.665945696469</range>
				<gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
			</LookAt>
			<styleUrl>#m_ylw-pushpin</styleUrl>
			<Point>
				<gx:drawOrder>1</gx:drawOrder>
				<coordinates>-47.53105471482726,-23.49338460838598,0</coordinates>
			</Point>
		</Placemark>
		<Placemark>
			<name>Seed2</name>
			<LookAt>
				<longitude>-47.52653502290166</longitude>
				<latitude>-23.48891905879437</latitude>
				<altitude>0</altitude>
				<heading>-10.88388407177008</heading>
				<tilt>47.85114699982938</tilt>
				<range>1492.665945696469</range>
				<gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
			</LookAt>
			<styleUrl>#m_ylw-pushpin</styleUrl>
			<Point>
				<gx:drawOrder>1</gx:drawOrder>
				<coordinates>-47.53086620077713,-23.49286409643531,0</coordinates>
			</Point>
		</Placemark>
		<Placemark>
			<name>Seed3</name>
			<LookAt>
				<longitude>-47.52882269495633</longitude>
				<latitude>-23.48912129413231</latitude>
				<altitude>0</altitude>
				<heading>-10.88297223537697</heading>
				<tilt>47.85114382962018</tilt>
				<range>1492.189890800937</range>
				<gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
			</LookAt>
			<styleUrl>#m_ylw-pushpin</styleUrl>
			<Point>
				<gx:drawOrder>1</gx:drawOrder>
				<coordinates>-47.5307940857337,-23.49230715879985,0</coordinates>
			</Point>
		</Placemark>
		<Placemark>
			<name>Seed4</name>
			<LookAt>
				<longitude>-47.52863132866368</longitude>
				<latitude>-23.48912847802362</latitude>
				<altitude>0</altitude>
				<heading>-10.88304850807027</heading>
				<tilt>47.85114352026186</tilt>
				<range>1492.14330278907</range>
				<gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
			</LookAt>
			<styleUrl>#m_ylw-pushpin</styleUrl>
			<Point>
				<gx:drawOrder>1</gx:drawOrder>
				<coordinates>-47.53055632645332,-23.49164654366516,0</coordinates>
			</Point>
		</Placemark>
		<Placemark>
			<name>Seed5</name>
			<LookAt>
				<longitude>-47.52854804155096</longitude>
				<latitude>-23.48866983341398</latitude>
				<altitude>0</altitude>
				<heading>-10.88308168960218</heading>
				<tilt>47.85116487087549</tilt>
				<range>1495.349320279493</range>
				<gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
			</LookAt>
			<styleUrl>#m_ylw-pushpin</styleUrl>
			<Point>
				<gx:drawOrder>1</gx:drawOrder>
				<coordinates>-47.53036030340782,-23.49105076351793,0</coordinates>
			</Point>
		</Placemark>
		<Placemark>
			<name>Seed6</name>
			<LookAt>
				<longitude>-47.52854804155096</longitude>
				<latitude>-23.48866983341398</latitude>
				<altitude>0</altitude>
				<heading>-10.88308168960218</heading>
				<tilt>47.85116487087549</tilt>
				<range>1495.349320279493</range>
				<gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
			</LookAt>
			<styleUrl>#m_ylw-pushpin</styleUrl>
			<Point>
				<gx:drawOrder>1</gx:drawOrder>
				<coordinates>-47.53018174297089,-23.49050790457373,0</coordinates>
			</Point>
		</Placemark>
		<Placemark>
			<name>Seed7</name>
			<LookAt>
				<longitude>-47.52854804155096</longitude>
				<latitude>-23.48866983341398</latitude>
				<altitude>0</altitude>
				<heading>-10.88308168960218</heading>
				<tilt>47.85116487087549</tilt>
				<range>1495.349320279493</range>
				<gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
			</LookAt>
			<styleUrl>#m_ylw-pushpin</styleUrl>
			<Point>
				<gx:drawOrder>1</gx:drawOrder>
				<coordinates>-47.53022706659075,-23.489713980681,0</coordinates>
			</Point>
		</Placemark>
		<Placemark>
			<name>Seed8</name>
			<LookAt>
				<longitude>-47.52854804155096</longitude>
				<latitude>-23.48866983341398</latitude>
				<altitude>0</altitude>
				<heading>-10.88308168960218</heading>
				<tilt>47.85116487087549</tilt>
				<range>1495.349320279493</range>
				<gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
			</LookAt>
			<styleUrl>#m_ylw-pushpin</styleUrl>
			<Point>
				<gx:drawOrder>1</gx:drawOrder>
				<coordinates>-47.52999778710858,-23.48864061374173,0</coordinates>
			</Point>
		</Placemark>
	</Folder>
</Document>
</kml>

''');
    sendToLG('$localPath/REGION1.kml');
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
      await client
          .execute('echo "http://lg1:81/REGION1.kml" > /var/www/html/kmls.txt');
      await client.execute('echo "flytoview=<LookAt><longitude>-47.530556</longitude><latitude>-23.491647</latitude><altitude>0</altitude><heading>-10.88388407177008</heading><tilt>47.85114699982938</tilt><range>1492.665945696469</range><gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode></LookAt>" > /tmp/query.txt');
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
          child: MyAppBar(isHome: false,),
        ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome! Testing Playground',
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
                onPressed: () =>
                    {Navigator.pushNamed(context, '/project-builder')},
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
              ),
            ]),
      ),
    );
  }
}
