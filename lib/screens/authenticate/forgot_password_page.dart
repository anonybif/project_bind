import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/screens/authenticate/sign_in.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:project_bind/utils/utils.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    emailController.dispose();

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
            appBar: AppBar(
              backgroundColor: primaryThemeColor(),
              title: const Text('Reset Password'),
              centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: iconWidget("assets/images/logo1.png"),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(color: secondaryThemeColor()),
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
                      reusableTextField('Enter Email', Icons.email, 'email',
                          false, emailController),
                      const SizedBox(
                        height: 32,
                      ),
                      reusableUIButton(context, 'Reset Password', swidth / 1.5,
                          resetPassword),
                      TextButton(
                        style: ElevatedButton.styleFrom(),
                        child: Text(
                          'Back To SignIn',
                          style: TextStyle(
                              fontSize: 16, color: primaryThemeColor()),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignIn()));
                        },
                      )
                    ],
                  )),
            )),
      ),
    );
  }

  Future resetPassword() async {
    loading(context);
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);

      Utils.showSnackBar('Password Reset Email Sent', messengerKey);
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message, messengerKey);
      Navigator.of(context).pop();
    }
  }
}
