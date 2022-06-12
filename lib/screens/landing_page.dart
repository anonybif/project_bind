import 'package:flutter/material.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/screens/authenticate/sign_in.dart';
import 'package:project_bind/screens/authenticate/sign_up.dart';
import 'package:project_bind/screens/home/home.dart';
import 'package:project_bind/utils/color_utils.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: secondaryThemeColor(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: sheight * 0.03125,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()));
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: primaryTextColor(),
                      ),
                      label: Text(
                        'Skip',
                        style: TextStyle(
                            color: primaryTextColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                              MaterialStateProperty.all(secondaryThemeColor())),
                    ),
                  ),
                ),
                SizedBox(
                  height: sheight * 0.125,
                ),
                logoWidget("assets/images/bind_logo1.png"),
                SizedBox(
                  height: sheight * 0.03125,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Share Your',
                        style: TextStyle(
                          fontSize: 24,
                          color: primaryTextColor(),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Experience!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: primaryTextColor(),
                        )),
                  ],
                ),
                SizedBox(
                  height: sheight * 0.015625,
                ),
                Text('Discover the perfect business',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: primaryTextColor(),
                    )),
                SizedBox(
                  height: sheight * 0.25,
                ),
                reusableUIButton(context, "Create Account", swidth, () {
                  toSignUp();
                }),
                SizedBox(height: sheight * 0.03125),
                signUpOption()
              ]),
        ),
      ),
    );
  }

  toSignUp() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignUp()));
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account?",
            style: TextStyle(color: primaryTextColor())),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignIn()));
          },
          child: Text(
            " Sign In",
            style: TextStyle(
                color: primaryThemeColor(),
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ],
    );
  }
}
