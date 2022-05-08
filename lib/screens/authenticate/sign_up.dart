import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/reusable_widgets/user.dart';
import 'package:project_bind/screens/authenticate/sign_in.dart';
import 'package:project_bind/screens/home/home.dart';
import 'package:project_bind/utils/color_utils.dart';

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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: hexStringToColor("e8e8e8")),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                reusableTextField(
                    "First Name", Icons.person, false, firstNameController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Last Name", Icons.person, false, lastNameController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "UserName", Icons.person, false, userNameController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Phone Number", Icons.phone, false, phoneNumberController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Location", Icons.pin_drop, false, locationController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Email Address", Icons.mail, false, emailController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Password", Icons.lock_outlined, true, passwordController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Bio (Optional)", Icons.assignment, true, bioController),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Sign Up", () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text)
                      .then((signedInUser) {
                    print("Created New Account");
                    createUser(signedInUser);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),
                signInOption(),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ))),
    );
  }

  Future createUser(UserCredential signedInUser) async {
    final json = {
      'FirstName': firstNameController.text,
      'LastName': lastNameController.text,
      'Username': userNameController.text,
      'Email': emailController.text,
      'PhoneNumber': phoneNumberController.text,
      'Location': locationController.text,
      'Bio': bioController.text,
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
                    color: Colors.deepOrange, fontWeight: FontWeight.bold),
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
                color: Colors.deepOrange, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
