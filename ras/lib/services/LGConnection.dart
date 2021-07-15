import 'package:path_provider/path_provider.dart';
import 'package:ras/models/Project.dart';
import 'package:ras/models/kml/LookAt.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssh/ssh.dart';

class LGConnection {
  Future sendToLG(String kml, Project project) async {
    if (project.geodata.markers.length > 0 ||
        project.geodata.areaPolygon.coord.length > 0) {
      return _createLocalFile(kml, project);
    }
    return Future.error('NO GEODATA TO UPLOAD TO LG');
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
    }
    catch(e) {
      print('Could not connect to host LG');
      return e;
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

  _uploadToLG(String localPath, Project project) async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: 22,
      username: "lg",
      passwordOrKey: '${credencials['pass']}',
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
