import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ras/models/Project.dart';
import 'package:ras/models/kml/LookAt.dart';
import 'package:ras/models/kml/Placemark.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:ssh/ssh.dart';

class LGConnection {

  int screenAmount = 5;

  openDemoLogos() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: 22,
      username: "lg",
      passwordOrKey: '${credencials['pass']}',
    );

    // With feh image viewer
    // try {
    //   await client.connect();
    //   await client.execute(
    //       'sshpass -p ${credencials['pass']} ssh lg1 "sudo -S <<< "${credencials['pass']}" sudo apt install feh -yq"');
    //   await client.execute(
    //       'sshpass -p ${credencials['pass']} ssh lg4 "curl https://i.imgur.com/4iHKQpN.jpg?1 > /home/lg/raslogos.png"');
    //   await client
    //       .execute('sshpass -p ${credencials['pass']} ssh lg4 "pkill feh"');
    //   await client.execute(
    //       'sshpass -p ${credencials['pass']} ssh lg4 "export DISPLAY=:0 && feh -x -g 700x700 /home/lg/raslogos.png --zoom fill"');
    // } catch (e) {}

    // With KML on slave 4
    String openLogoKML = '''
<?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
    <Document>
      <name>Ras-logos</name>
        <Folder>
        <name>Logos</name>
        <ScreenOverlay>
        <name>Logo</name>
        <Icon>
        <href>https://i.imgur.com/Y6HvAsC.png</href>
        </Icon>
        <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>
        <screenXY x="0.02" y="0.95" xunits="fraction" yunits="fraction"/>
        <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
        <size x="0.4" y="0.2" xunits="fraction" yunits="fraction"/>
        </ScreenOverlay>
        </Folder>
    </Document>
  </kml>
    ''';
    try {
      await client.connect();
      await client.execute("echo '$openLogoKML' > /var/www/html/kml/slave_4.kml");
    }catch (e) {
      print(e);
    }
  }

  Future infoGraphsUpload() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: 22,
      username: "lg",
      passwordOrKey: '${credencials['pass']}',
    );
        String graphKML = '''
<?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
    <Document>
      <name>Ras-graphs</name>
        <Folder>
        <name>Graphs</name>
        <ScreenOverlay>
        <name>Logo</name>
        <Icon>
        <href>http://lg1:81/graphs.png</href>
        </Icon>
        <overlayXY x="1" y="1" xunits="fraction" yunits="fraction"/>
        <screenXY x="0.98" y="0.98" xunits="fraction" yunits="fraction"/>
        <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
        <size x="0.2" y="0.2" xunits="fraction" yunits="fraction"/>
        </ScreenOverlay>
        </Folder>
    </Document>
  </kml>
    ''';
    String infoKML = '''
<?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
    <Document>
      <name>Ras-Project-Info</name>
        <Folder>
        <name>Project-Info</name>
        <ScreenOverlay>
        <name>Logo</name>
        <Icon>
        <href>http://lg1:81/info.png</href>
        </Icon>
        <overlayXY x="1" y="1" xunits="fraction" yunits="fraction"/>
        <screenXY x="0.98" y="0.98" xunits="fraction" yunits="fraction"/>
        <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
        <size x="0.2" y="0.2" xunits="fraction" yunits="fraction"/>
        </ScreenOverlay>
        </Folder>
    </Document>
  </kml>
    ''';
    String localPath = await _localPath;
    String graphPath = '$localPath/graphs.png';
    String infoPath = '$localPath/info.png';
    try {
      await client.connect();
      await client.connectSFTP();
      await client.sftpUpload(path: graphPath, toPath: '/var/www/html');
      await client.execute("echo '$graphKML' > /var/www/html/kml/slave_3.kml");
      await client.sftpUpload(path: infoPath, toPath: '/var/www/html');
      await client.execute("echo '$infoKML' > /var/www/html/kml/slave_1.kml");
    }catch (e) {
      print(e);
    }
  }

  Future sendToLG(String kml, Project project) async {
    if (project.geodata.markers.length > 0 ||
        project.geodata.areaPolygon.coord.length > 0) {
      return _createLocalFile(kml, project);
    }
    return Future.error('nogeodata');
  }

  Future cleanVisualization() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: 22,
      username: "lg",
      passwordOrKey: '${credencials['pass']}',
    );

    try {
      await client.connect();
      stopOrbit();
      await client.execute('> /var/www/html/kml/slave_3.kml');
      await client.execute('> /var/www/html/kml/slave_1.kml');
      return await client.execute('> /var/www/html/kmls.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  _getCredentials() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String ipAddress = preferences.getString('master_ip') ?? '';
    String password = preferences.getString('master_password') ?? '';

    return {
      "ip": ipAddress,
      "pass": password,
    };
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  _createLocalFile(String kml, Project project) async {
    String localPath = await _localPath;
    File localFile = File('$localPath/${project.projectName}.kml');
    localFile.writeAsString(kml);

    return _uploadToLG('$localPath/${project.projectName}.kml', project);
  }

  _createLocalImage(String imgName, String assetsUrl) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String imgPath = '${directory.path}/$imgName';
    ByteData data = await rootBundle.load(assetsUrl);
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(imgPath).writeAsBytes(bytes);
    return imgPath;
  }

  _uploadToLG(String localPath, Project project) async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: 22,
      username: "lg",
      passwordOrKey: '${credencials['pass']}',
    );

    LookAt flyto = LookAt(
        project.geodata.landingPoint.name != 'none'
            ? project.geodata.landingPoint.point.lng
            : (project.geodata.areaPolygon.coord.length > 0
                ? project.geodata.areaPolygon.coord[0].longitude
                : project.geodata.markers[0].lookAt.lng),
        project.geodata.landingPoint.name != 'none'
            ? project.geodata.landingPoint.point.lat
            : (project.geodata.areaPolygon.coord.length > 0
                ? project.geodata.areaPolygon.coord[0].latitude
                : project.geodata.markers[0].lookAt.lat),
        '1492.665945696469',
        '45',
        '0');
    try {
      await client.connect();
      await client.execute('> /var/www/html/kmls.txt');
      // upload kml
      await client.connectSFTP();
      await client.sftpUpload(
        path: localPath,
        toPath: '/var/www/html',
        callback: (progress) {
          print('Sent $progress');
        },
      );

      // upload seed markers icons
      await Future.forEach(project.geodata.markers, (Placemark element) async {
        if (element.customData['seed']['commonName'] != 'none') {
          String imgPath = await _createLocalImage(
              element.customData['seed']['icon']['name'],
              element.customData['seed']['icon']['url']);
          await client.sftpUpload(path: imgPath, toPath: '/var/www/html');
        }
      });

      // upload landpoint asset
      String imgPath = await _createLocalImage(
          'landpoint.png', 'assets/appIcons/landpoint.png');
      await client.sftpUpload(path: imgPath, toPath: '/var/www/html');

      await client.execute(
          'echo "http://lg1:81/${project.projectName}.kml" > /var/www/html/kmls.txt');
      return await client.execute(
          'echo "flytoview=${flyto.generateLinearString()}" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  Future<void> cleanLogos() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: 22,
      username: "lg",
      passwordOrKey: '${credencials['pass']}',
    );

    try {
      await client.connect();
      await client.execute("echo '' > /var/www/html/kml/slave_4.kml");
      await client.execute("echo '' > /var/www/html/kml/slave_1.kml");
      await client.execute("echo '' > /var/www/html/kml/slave_3.kml");
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  Future<void> rebootLg() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: 22,
      username: "lg",
      passwordOrKey: '${credencials['pass']}',
    );

  for (var i = screenAmount; i >= 1; i--) {

    try {
      await client.connect();
      await client
            .execute('sshpass -p ${credencials['pass']} ssh -t lg$i "echo ${credencials['pass']} | sudo -S reboot"');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }
  }

  Future<void> relaunchLg() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: 22,
      username: "lg",
      passwordOrKey: '${credencials['pass']}',
    );

  for (var i = screenAmount; i >= 1; i--) {

    try {
      await client.connect();
      final relaunchCommand = """RELAUNCH_CMD="\\
if [ -f /etc/init/lxdm.conf ]; then
  export SERVICE=lxdm
elif [ -f /etc/init/lightdm.conf ]; then
  export SERVICE=lightdm
else
  exit 1
fi
if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
  service \\\${SERVICE} start
else
  echo lq | sudo -S service \\\${SERVICE} restart
fi
" && sshpass -p ${credencials['pass']} ssh -x -t lg@lg$i "\$RELAUNCH_CMD\"""";
        await client.execute(relaunchCommand);
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }
  }

  Future<void> shutdownLg() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: 22,
      username: "lg",
      passwordOrKey: '${credencials['pass']}',
    );

  for (var i = screenAmount; i >= 1; i--) {
    try {
      await client.connect();
      await client.execute(
            'sshpass -p ${credencials['pass']} ssh -t lg$i "echo ${credencials['pass']} | sudo -S poweroff"');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
    }
  }

  Future<String?> getScreenAmount() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: 22,
      username: "lg",
      passwordOrKey: '${credencials['pass']}',
    );
    return client.execute("grep -oP '(?<=DHCP_LG_FRAMES_MAX=).*' personavars.txt");
  }

  buildOrbit(String content) async {
    dynamic credencials = await _getCredentials();

    String localPath = await _localPath;
    File localFile = File('$localPath/Orbit.kml');
    localFile.writeAsString(content);

    String filePath = '$localPath/Orbit.kml';

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: 22,
      username: "lg",
      passwordOrKey: '${credencials['pass']}',
    );

    try {
      await client.connect();
      await client.connectSFTP();
      await client.sftpUpload(
        path: filePath,
        toPath: '/var/www/html',
        callback: (progress) {
          print('Sent $progress');
        },
      );

      return await client
          .execute("echo '\nhttp://lg1:81/Orbit.kml' >> /var/www/html/kmls.txt");
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  startOrbit() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: 22,
      username: "lg",
      passwordOrKey: '${credencials['pass']}',
    );

    try {
      await client.connect();
      return await client.execute('echo "playtour=Orbit" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  stopOrbit() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: 22,
      username: "lg",
      passwordOrKey: '${credencials['pass']}',
    );

    try {
      await client.connect();
      return await client.execute('echo "exittour=true" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }
}
