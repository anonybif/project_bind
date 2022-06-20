import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_bind/shared/reusable_widget.dart';
import 'package:project_bind/shared/user.dart';
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
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final messengerKey = GlobalKey<ScaffoldMessengerState>();
  final formKey = GlobalKey<FormState>();
  bool passVisible = false;

  @override
  void initState() {
    passwordController.clear();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;

    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      home: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: secondaryThemeColor(),
          body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, sheight * 0.03125, 20, 0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: sheight * 0.06,
                      ),
                      logoWidget("assets/images/bind_logo1.png"),
                      SizedBox(
                        height: sheight * 0.06,
                      ),
                      Text('Create Account',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: primaryTextColor(),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("UserName", Icons.person, 'username',
                          false, userNameController),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Email Address", Icons.mail, 'email',
                          false, emailController),
                      SizedBox(
                        height: sheight * 0.03125,
                      ),
                      SizedBox(height: 70, child: passwordField()),
                      SizedBox(
                        height: sheight * 0.015625,
                      ),
                      reusableUIButton(context, "Continue", swidth, 50, () {
                        signUp();
                      }),
                      SizedBox(
                        height: sheight * 0.015625,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(21),
                          color: tertiaryThemeColor(),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            loading(context);
                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            provider.googleLogIn(context);
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.google,
                                size: swidth * 0.08,
                                color: primaryThemeColor(),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Sign up with Google',
                                style: TextStyle(color: secondaryTextColor()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sheight * 0.03125,
                      ),
                      signInOption(),
                      SizedBox(
                        height: sheight * 0.03125,
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  TextFormField passwordField() {
    return TextFormField(
        controller: passwordController,
        obscureText: !passVisible,
        enableSuggestions: false,
        autocorrect: false,
        style: TextStyle(color: primaryTextColor()),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock_outline,
            color: primaryThemeColor(),
          ),
          suffix: IconButton(
            icon: Icon(
              passVisible ? Icons.visibility_off : Icons.visibility,
              color: primaryThemeColor(),
            ),
            splashColor: Colors.transparent,
            onPressed: () {
              setState(() {
                passVisible = !passVisible;
              });
            },
          ),
          labelText: 'Enter Password',
          labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
          filled: true,
          fillColor: tertiaryThemeColor(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
                width: 0, style: BorderStyle.none, color: primaryThemeColor()),
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: ((value) => value != null && value.length < 6
            ? 'password needs to be atleast 6 characters'
            : null),
        keyboardType: TextInputType.visiblePassword);
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    loading(context);

    var ds = await FirebaseFirestore.instance.collection('user').get();
    for (int i = 0; i < ds.size; i++) {
      if (ds.docs[i]['Username'].toString().toLowerCase() ==
          userNameController.text.trim().toLowerCase()) {
        Utils.showSnackBar('Username already exists', messengerKey);
        Navigator.of(context).pop();
        return;
      }
    }
    for (int i = 0; i < ds.size; i++) {
      if (ds.docs[i]['Email'].toString().toLowerCase() ==
          emailController.text.trim().toLowerCase()) {
        Utils.showSnackBar('Email already exists', messengerKey);
        Navigator.of(context).pop();
        return;
      }
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message, messengerKey);
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerifyEmailPage(
                  Username: userNameController.text.trim(),
                )));
  }

  Column signInOption() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Already have an account?",
                style: TextStyle(color: secondaryTextColor())),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const SignIn()));
              },
              child: Text(
                " Login",
                style: TextStyle(
                    color: primaryThemeColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text("or", style: TextStyle(color: secondaryTextColor())),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Home()));
          },
          child: Text(
            " Continue as guest",
            style: TextStyle(
                color: primaryThemeColor(),
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        )
      ],
    );
  }
}
