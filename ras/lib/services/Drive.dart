import 'dart:io';

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:http/http.dart' as http;
import 'package:ras/models/Project.dart';
import 'package:ras/services/PdfGenerator.dart';

class GoogleDrive {
  requestPermission(Project project) async {
    final googleSignIn =
        signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    final signIn.GoogleSignInAccount? account = await googleSignIn.signIn();
    print("User account $account");
    if (account != null) uploadFile(account, project);
    else return Future.error('Error uploading to drive');
  }

  uploadFile(signIn.GoogleSignInAccount account, Project pr) async {
    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    File pdf = await PdfGenerator.generatePdf(pr);
    var driveFile = new drive.File();
    driveFile.name = "${pr.projectName}";

    try {
      final result = await driveApi.files.create(driveFile,
          uploadMedia: drive.Media(pdf.openRead(), pdf.lengthSync()));
      await pdf.delete();
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
