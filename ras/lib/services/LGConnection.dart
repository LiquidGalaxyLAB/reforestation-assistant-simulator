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
}
