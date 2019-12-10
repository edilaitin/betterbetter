import 'package:google_sign_in/google_sign_in.dart';
import 'package:betterbetter/models/user.dart';

class GSignIn {
  static final GSignIn _singleton = new GSignIn._internal();
  GSignIn._internal() {}
  factory GSignIn() {
    return _singleton;
  }

  GoogleSignInAccount get currentUser {
    return _googleSignIn.currentUser;
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  Future<void> handleSignIn() async {
    try {
      await _googleSignIn.signIn();

      var user = User(
        name: currentUser.displayName,
        id: currentUser.id,
        photoUrl: currentUser.photoUrl,
        email: currentUser.email,
      );

      user.addUser();
    } catch (error) {
      print(error);
    }
  }

  Future<void> handleSignOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (error) {
      print(error);
    }
  }
}
