import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_bind/reusable_widgets/user.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogIn(BuildContext context) async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      notifyListeners();
      await FirebaseAuth.instance.signInWithCredential(credential);
      createUser(context);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future googlelogout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }

  Future createUser(BuildContext context) async {
    String firstName = user.displayName!.split(' ')[0];
    String lastName = user.displayName!.split(' ')[1];
    final json = {
      'FirstName': firstName,
      'LastName': lastName,
      'Username': '',
      'Email': user.email,
      'PhoneNumber': '',
      'Bio': '',
      'Badge': 'bronze',
      'Uid': user.id
    };

    UserManagement().storeNewUser(json, context);
  }
}
