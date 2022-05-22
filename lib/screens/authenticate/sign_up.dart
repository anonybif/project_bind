import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/reusable_widgets/user.dart';
import 'package:project_bind/screens/authenticate/google_sign_in.dart';
import 'package:project_bind/screens/authenticate/sign_in.dart';
import 'package:project_bind/screens/authenticate/sign_up_info.dart';
import 'package:project_bind/screens/authenticate/verify_email_page.dart';
import 'package:project_bind/screens/home/home.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:project_bind/utils/utils.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final navigatorKey = GlobalKey<NavigatorState>();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;

    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
              width: swidth,
              height: sheight,
              decoration: BoxDecoration(color: hexStringToColor("e8e8e8")),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      logoWidget("assets/images/bind_logo1.png"),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Create Account',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Email Address", Icons.mail, 'email',
                          false, emailController),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Password", Icons.lock_outlined,
                          'password', false, passwordController),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableUIButton(context, "Continue", swidth, () {
                        signUp();
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(21),
                          color: Colors.white,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            loading(context);
                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            provider.googleLogIn(context);
                            navigatorKey.currentState!
                                .popUntil((route) => route.isFirst);
                          },
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
                              const Text('Sign up with Google'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      signInOption(),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    loading(context);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignUpInfo()));
  }

  Column signInOption() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account?",
                style: TextStyle(color: Colors.black)),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const SignIn()));
              },
              child: const Text(
                " Login",
                style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            )
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
            Navigator.pushReplacement(
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
