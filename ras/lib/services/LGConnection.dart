import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ras/models/Project.dart';
import 'package:ras/models/kml/LookAt.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssh/ssh.dart';

class LGConnection {
  String _ipAddress = '';
  String _password = '';

  init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _ipAddress = preferences.getString('master_ip') ?? '';
    _password = preferences.getString('master_password') ?? '';
    print('$_ipAddress');
    print('$_password');
  }

  Future sendToLG(String kml, Project project) async {
    if (project.geodata.markers.length > 0 ||
        project.geodata.areaPolygon.coord.length > 0) {
      return _createLocalFile(kml, project);
    }
    return Future.error('NO GEODATA TO UPLOAD TO LG');
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

  _uploadToLG(String localPath, Project project) async {
    print('$_ipAddress');
    print('$_password');
    // FIX PROBLEM WITH EMPTY IP AND PASSWORD
    SSHClient client = SSHClient(
      host: '192.168.0.172',
      port: 22,
      username: "lg",
      passwordOrKey: 'lq',
    );

    LookAt flyto = LookAt(
        project.geodata.areaPolygon.coord.length > 0
            ? project.geodata.areaPolygon.coord[0].longitude
            : project.geodata.markers[0].lookAt.lng,
        project.geodata.areaPolygon.coord.length > 0
            ? project.geodata.areaPolygon.coord[0].latitude
            : project.geodata.markers[0].lookAt.lat,
        '1492.665945696469',
        '45',
        '0');
      print(flyto.generateTag().trim());

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
      await client.execute(
          'echo "http://lg1:81/${project.projectName}.kml" > /var/www/html/kmls.txt');
      return await client
          .execute('echo "flytoview=${flyto.generateLinearString()}" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return e;
    }
  }
}
