import 'dart:io';

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:http/http.dart' as http;
import 'package:ras/models/Project.dart';
import 'package:ras/models/kml/Kml.dart';
import 'package:ras/services/KmlGenerator.dart';
import 'package:ras/services/PdfGenerator.dart';

class GoogleDrive {
  requestPermission(Project project) async {
    final googleSignIn =
        signIn.GoogleSignIn.standard(scopes: ['https://www.googleapis.com/auth/drive.file']);
    final signIn.GoogleSignInAccount? account = await googleSignIn.signIn();
    print("User account $account");
    if (account != null)
      uploadFile(account, project);
    else
      return Future.error('Error uploading to drive');
  }

  uploadFile(signIn.GoogleSignInAccount account, Project pr) async {
    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    await uploadKMLFile(pr, driveApi);

    // Upload PDF
    File pdf = await PdfGenerator.generatePdf(pr);
    var driveFile = new drive.File();
    driveFile.name = "${pr.projectName}.pdf";

    try {
      final result = await driveApi.files.create(driveFile,
          uploadMedia: drive.Media(pdf.openRead(), pdf.lengthSync()));
      await pdf.delete();
      return Future.value(result);
    } catch (e) {
      return Future.error('Error uploading to drive $e');
    }
  }

  uploadKMLFile(Project pr, driveApi) async {
    // Upload KML
    // create kml based on geodata attribute
    String content = KML.buildKMLContent(
        pr.geodata.markers, pr.geodata.areaPolygon, pr.geodata.landingPoint);
    KML kml = KML(pr.projectName, content);
    final kmlDone = kml.mount();
    File kmlFile = await KMLGenerator.generateKML(kmlDone, pr.projectName);
    
    var driveFile = new drive.File();
    driveFile.name = "${pr.projectName}.kml";

    try {
      final result = await driveApi.files.create(driveFile,
          uploadMedia: drive.Media(kmlFile.openRead(), kmlFile.lengthSync()));
      await kmlFile.delete();
      return Future.value(result);
    } catch (e) {
      return Future.error('Error uploading to drive $e');
    }
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;

  final http.Client _client = new http.Client();

  GoogleAuthClient(this._headers);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
