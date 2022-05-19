import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/screens/authenticate/forgot_password_page.dart';
import 'package:project_bind/screens/authenticate/sign_up.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/screens/home/home.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:project_bind/utils/utils.dart';
// import 'package:get/get.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

String userName = '';

class _SignInState extends State<SignIn> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final formKey = GlobalKey<FormState>();
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
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;

    return MaterialApp(
      navigatorKey: navigatorKey,
      // scaffoldMessengerKey: Utils.messengerKey,
      home: Scaffold(
        body: Container(
          width: swidth,
          height: sheight,
          decoration: BoxDecoration(color: hexStringToColor("e8e8e8")),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, sheight * 0.1, 20, 0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    logoWidget("assets/images/bind_logo1.png"),
                    const SizedBox(
                      height: 30,
                    ),
                    reusableTextField("Enter Username", Icons.person_outline,
                        'username', false, userNameController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Password", Icons.lock_outline,
                        'password', false, passwordController),
                    const SizedBox(
                      height: 15,
                    ),
                    reusableUIButton(context, "Login", swidth, () {
                      logIn();
                    }),
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage()));
                      },
                      child: const Text(
                        " Forgot Password?",
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(36),
                            child: Image.asset(
                              "assets/images/google_logo.png",
                              height: 42,
                              width: 42,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text('Sign in with Google'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    signUpOption()
                  ],
                ),
              ),
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

  Future logIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    loading(context);
    await fetchEmail();
    // if (userName == '') {
    //   Utils.showSnackBar('Invaid Username');
    //   return;
    // }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail, password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e.message);

      // Utils.showSnackBar(e.message);
      // return;
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Home()));
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
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
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
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        )
      ],
    );
  }
}
