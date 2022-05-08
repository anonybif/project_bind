import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/screens/authenticate/sign_up.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/screens/home/home.dart';
import 'package:project_bind/utils/color_utils.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

String userName = '';

class _SignInState extends State<SignIn> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  String userEmail = '';

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: hexStringToColor("e8e8e8")),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/bind_logo1.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    userNameController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    passwordController),
                const SizedBox(
                  height: 15,
                ),
                // forgetPassword(context),
                firebaseUIButton(context, "Login", () async {
                  await fetchEmail();
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: userEmail, password: passwordController.text)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),
                const SizedBox(
                  height: 150,
                ),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  fetchEmail() async {
    QuerySnapshot user = await FirebaseFirestore.instance
        .collection('user')
        .where("Username", isEqualTo: userNameController.text)
        .get();
    userEmail = user.docs[0]["Email"];
  }

  Column signUpOption() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?",
                style: TextStyle(color: Colors.black)),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignUp()));
              },
              child: const Text(
                " Sign Up",
                style: TextStyle(
                    color: Colors.deepOrange, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Text("or", style: TextStyle(color: Colors.black)),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Home()));
          },
          child: const Text(
            " Continue as guest",
            style: TextStyle(
                color: Colors.deepOrange, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
