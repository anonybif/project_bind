import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_bind/firebase_options.dart';
import 'package:project_bind/screens/authenticate/sign_in.dart';
import 'package:project_bind/screens/authenticate/verify_email_page.dart';
import 'package:project_bind/screens/home/home.dart';
import 'package:project_bind/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const Home();
              } else {
                return const SignIn();
              }
            }));
  }
}
