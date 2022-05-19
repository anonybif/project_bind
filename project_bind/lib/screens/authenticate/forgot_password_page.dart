import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/screens/authenticate/sign_in.dart';
import 'package:project_bind/utils/color_utils.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange[600],
          title: const Text('Reset Password'),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: iconWidget("assets/images/logo1.png"),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(color: hexStringToColor("e8e8e8")),
          padding: const EdgeInsets.all(16),
          child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Receive an email to reset your password',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 21),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  reusableTextField('Enter Email', Icons.email, 'email', false,
                      emailController),
                  const SizedBox(
                    height: 32,
                  ),
                  reusableUIButton(
                      context, 'Reset Password', swidth / 1.5, resetPassword),
                  TextButton(
                    style: ElevatedButton.styleFrom(),
                    child: const Text(
                      'Back To SignIn',
                      style: TextStyle(fontSize: 16, color: Colors.deepOrange),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignIn()));
                    },
                  )
                ],
              )),
        ));
  }

  Future resetPassword() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(color: Colors.deepOrange),
            ));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);

      // Utils.showSnackBar('Password Rest Email Sent');}
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);

      // Utils.showSnackBar(e.message);
    }
  }
}
