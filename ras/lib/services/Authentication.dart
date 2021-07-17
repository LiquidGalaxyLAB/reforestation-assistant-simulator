import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  Future<void> handleSignIn() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }
}
