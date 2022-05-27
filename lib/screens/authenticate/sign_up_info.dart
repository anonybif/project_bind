import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/reusable_widgets/user.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:project_bind/utils/utils.dart';

class SignUpInfo extends StatefulWidget {
  const SignUpInfo({Key? key}) : super(key: key);

  @override
  State<SignUpInfo> createState() => _SignUpInfoState();
}

class _SignUpInfoState extends State<SignUpInfo> {
  final userNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;

    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      home: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: primaryThemeColor()[600],
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: iconWidget("assets/images/logo1.png"),
            ),
            title: const Text(
              "Complete Sign Up",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          backgroundColor: secondaryThemeColor(),
          body: SingleChildScrollView(
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
                      reusableTextField("Bio (Optional)", Icons.assignment, '',
                          true, bioController),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableUIButton(context, "Sign Up", swidth, () {
                        signUp();
                      }),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    loading(context);
    createUser();
    Navigator.of(context).pop();
  }

  Future createUser() async {
    final json = {
      'FirstName': firstNameController.text.trim(),
      'LastName': lastNameController.text.trim(),
      'Username': userNameController.text.trim(),
      'Email': FirebaseAuth.instance.currentUser!.email,
      'PhoneNumber': phoneNumberController.text.trim(),
      'Bio': bioController.text.trim(),
      'Badge': 'bronze',
      'Uid': FirebaseAuth.instance.currentUser!.uid
    };

    UserManagement().storeNewUser(json, context);
  }
}
