import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/screens/authenticate/sign_in.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          child: Text('Sign out'),
          onPressed: signOut,
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(child: Text('back'), onPressed: signInPage),
      ],
    ));
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signInPage() async {
    runApp(new MaterialApp(
      home: const SignIn(),
    ));
  }
}
