import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/screens/authenticate/sign_in.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      const SizedBox(
        height: 20,
      ),
      ElevatedButton(
        child: const Text('Logout'),
        onPressed: signOut,
      ),
    ]));
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut().then((value) {
      runApp(const MaterialApp(
        home: SignIn(),
      ));
    });
  }
}
