import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_bind/screens/add_business.dart';
import 'package:project_bind/screens/authenticate/forgot_password_page.dart';
import 'package:project_bind/screens/authenticate/google_sign_in.dart';
import 'package:project_bind/screens/authenticate/sign_up.dart';
import 'package:project_bind/shared/reusable_widget.dart';
import 'package:project_bind/screens/home/home.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:project_bind/utils/utils.dart';
import 'package:provider/provider.dart';
// import 'package:get/get.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final messengerKey = GlobalKey<ScaffoldMessengerState>();
  bool passVisible = false;
  String userEmail = '';
  bool isLoading = false;

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
                      height: sheight * 0.08,
                    ),
                    logoWidget("assets/images/bind_logo1.png"),
                    SizedBox(
                      height: sheight * 0.07,
                    ),
                    Text('Welcome Back',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: secondaryTextColor(),
                        )),
                    SizedBox(
                      height: sheight * 0.03125,
                    ),
                    reusableTextField("Enter Username", Icons.person_outline,
                        'username', false, userNameController),
                    SizedBox(
                      height: sheight * 0.0208,
                    ),
                    SizedBox(
                      height: 70,
                      child: passwordField(),
                    ),
                    SizedBox(
                      height: sheight * 0.01,
                    ),
                    reusableIconButton(
                        context, "Login", Icons.lock_outline, swidth, () {
                      logIn();
                    }),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage()));
                      },
                      child: Text(
                        " Forgot Password?",
                        style: TextStyle(
                            color: primaryThemeColor(),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: sheight * 0.03125,
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
                            Text('Login with Google',
                                style: TextStyle(
                                  color: secondaryTextColor(),
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sheight * 0.03125,
                    ),
                    signUpOption(),
                    SizedBox(
                      height: sheight * 0.03125,
                    ),
                  ],
                ),
              ),
            ),
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

  fetchEmail() async {
    await FirebaseFirestore.instance
        .collection('user')
        .where("Username", isEqualTo: userNameController.text)
        .get()
        .then((value) => userEmail = value.docs[0]["Email"])
        .catchError((e) => userEmail = '');
  }

  Future logIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    loading(context);

    await fetchEmail();
    if (userEmail == '') {
      Utils.showSnackBar('Invaid Username', messengerKey);
      Navigator.of(context).pop();
      return;
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: userEmail, password: passwordController.text.trim());
      } on FirebaseAuthException catch (e) {
        Utils.showSnackBar('Invalid Password', messengerKey);
        Navigator.of(context).pop();
        return;
      }
    }

    var user = FirebaseAuth.instance.currentUser;
    if (user!.emailVerified) {
      Navigator.of(context).pop();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } else {
      var ds = FirebaseFirestore.instance.collection('user').doc(user.uid);
      if (ds.path.isNotEmpty) {
        ds.delete();
      }
      user.delete();
      Utils.showSnackBar('Invalid Account', messengerKey);
      Navigator.of(context).pop();
      return;
    }
  }

  Column signUpOption() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account?",
                style: TextStyle(color: secondaryTextColor())),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignUp()));
              },
              child: Text(
                " Sign Up",
                style: TextStyle(
                    color: primaryThemeColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
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
