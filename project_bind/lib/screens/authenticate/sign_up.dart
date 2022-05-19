import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/reusable_widgets/user.dart';
import 'package:project_bind/screens/authenticate/sign_in.dart';
import 'package:project_bind/screens/home/home.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:project_bind/utils/utils.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final locationController = TextEditingController();
  final bioController = TextEditingController();
  final phoneNumberController = TextEditingController();
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.deepOrange[600],
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: iconWidget("assets/images/logo1.png"),
          ),
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Container(
            width: swidth,
            height: sheight,
            decoration: BoxDecoration(color: hexStringToColor("e8e8e8")),
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    reusableTextField("First Name", Icons.person, '', false,
                        firstNameController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Last Name", Icons.person, '', false,
                        lastNameController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("UserName", Icons.person, 'username',
                        false, userNameController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Phone Number", Icons.phone, 'phone',
                        false, phoneNumberController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Location", Icons.pin_drop, '', false,
                        locationController),
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
                    reusableTextField("Bio (Optional)", Icons.assignment, '',
                        true, bioController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableUIButton(context, "Sign Up", swidth, () {
                      signUp();
                    }),
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
                          const Text('Sign up with Google'),
                        ],
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
            ))),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    loading(context);
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text)
          .then((signedInUser) {
        createUser(signedInUser);
      });
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future createUser(UserCredential signedInUser) async {
    final json = {
      'FirstName': firstNameController.text.trim(),
      'LastName': lastNameController.text.trim(),
      'Username': userNameController.text.trim(),
      'Email': emailController.text.trim(),
      'PhoneNumber': phoneNumberController.text.trim(),
      'Location': locationController.text.trim(),
      'Bio': bioController.text.trim(),
      'Badge': 'bronze',
      'Uid': FirebaseAuth.instance.currentUser!.uid
    };

    UserManagement().storeNewUser(signedInUser.user, json, context);
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
                Navigator.push(context,
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
