import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_bind/shared/reusable_widget.dart';
import 'package:project_bind/screens/add_business.dart';
import 'package:project_bind/screens/authenticate/google_sign_in.dart';
import 'package:project_bind/screens/authenticate/sign_in.dart';
import 'package:project_bind/screens/authenticate/sign_up.dart';
import 'package:project_bind/screens/business_page.dart';
import 'package:project_bind/screens/landing_page.dart';
import 'package:project_bind/screens/my_business_page.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:provider/provider.dart';

class NaviagtionDrawerWidget extends StatelessWidget {
  NaviagtionDrawerWidget({Key? key}) : super(key: key);
  String userName = '';
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: tertiaryThemeColor(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: secondaryThemeColor(),
              ),
              child: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return userInfo(context);
                    } else {
                      return placholderInfo(context);
                    }
                  }),
            ),
            buildMenuItem(
                text: 'Add Business',
                icon: Icons.business_center,
                onClicked: () => selectedItem(context, 0)),
            buildMenuItem(
                text: 'Add Review',
                icon: Icons.message,
                onClicked: () => selectedItem(context, 1)),
            buildMenuItem(
                text: 'Favorites',
                icon: Icons.favorite,
                onClicked: () => selectedItem(context, 2)),
            buildMenuItem(
                text: 'Settings',
                icon: Icons.settings,
                onClicked: () => selectedItem(context, 3)),
            buildMenuItem(
                text: 'Ask Community',
                icon: Icons.question_answer,
                onClicked: () => selectedItem(context, 4)),
            buildMenuItem(
                text: 'FAQ',
                icon: Icons.question_answer_outlined,
                onClicked: () => selectedItem(context, 5)),
            buildMenuItem(
                text: 'Analytics',
                icon: Icons.analytics,
                onClicked: () => selectedItem(context, 6)),
            buildMenuItem(
                text: 'Contact Support',
                icon: Icons.contact_page,
                onClicked: () => selectedItem(context, 7)),
            buildMenuItem(
                text: 'Logout',
                icon: Icons.logout,
                onClicked: () => selectedItem(context, 8))
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    return ListTile(
      tileColor: tertiaryThemeColor(),
      leading: Icon(
        icon,
        color: primaryThemeColor(),
      ),
      title: Text(text, style: TextStyle(color: primaryTextColor())),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) async {
    // Navigator.of(context).pop();
    switch (index) {
      case 8:
        if (FirebaseAuth.instance.currentUser != null) {
          var email = await FirebaseAuth.instance.currentUser!.email;
          var methods =
              await FirebaseAuth.instance.fetchSignInMethodsForEmail(email!);
          if (methods.contains('google.com')) {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.googlelogout();
          }

          FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LandingPage()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LandingPage()));
        }
        break;

      case 0:
        if (FirebaseAuth.instance.currentUser?.uid != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddBusiness()));
        } else {
          signUpDialogue(context, 'content');
        }

        break;
    }
  }

  Future<String> fetch() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        userName = ds.data()!["Username"];
      }).catchError((e) {
        print(e);
      });
    }
    return userName;
  }
}

Column userInfo(BuildContext context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: Image.asset(
              "assets/images/profile.jpg",
              height: 72,
              width: 72,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Row(
                children: [
                  Text(
                    'userName',
                    style: TextStyle(
                      color: secondaryTextColor(),
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.badge,
                    color: secondaryTextColor(),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                FirebaseAuth.instance.currentUser!.email.toString(),
                style: TextStyle(
                  color: secondaryTextColor(),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyBusiness()));
            },
            child: Text(
              "My Businesses",
              style: TextStyle(color: primaryTextColor()),
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(primaryThemeColor()),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "following",
              style: TextStyle(color: primaryTextColor()),
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(primaryThemeColor()),
            ),
          ),
        ],
      )
    ],
  );
}

Column placholderInfo(BuildContext context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: Image.asset(
              "assets/images/d.png",
              height: 72,
              width: 72,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Guest',
            style: TextStyle(
              color: secondaryTextColor(),
              fontSize: 24,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignIn()));
            },
            child: Text(
              "Login",
              style: TextStyle(color: primaryTextColor()),
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(secondaryTextColor()),
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignUp()));
            },
            child: Text(
              "Sign UP",
              style: TextStyle(color: primaryTextColor()),
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(secondaryTextColor()),
            ),
          ),
        ],
      )
    ],
  );
}
