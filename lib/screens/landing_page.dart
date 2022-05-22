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
      body: Container(
        width: swidth,
        height: sheight,
        decoration: BoxDecoration(color: hexStringToColor("e8e8e8")),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      label: const Text(
                        'Skip',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all(
                              hexStringToColor("e8e8e8"))),
                    ),
                  ),
                ),
                SizedBox(
                  height: sheight / 6,
                ),
                logoWidget("assets/images/bind_logo1.png"),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Share Your',
                        style: TextStyle(
                          fontSize: 24,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Experience!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Discover the perfect business',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    )),
                SizedBox(
                  height: sheight / 4,
                ),
                reusableUIButton(context, "Create Account", swidth, () {
                  toSignUp();
                }),
                const SizedBox(height: 20),
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
        const Text("Already have an account?",
            style: TextStyle(color: Colors.black)),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignIn()));
          },
          child: const Text(
            " Sign In",
            style: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ],
    );
  }
}
