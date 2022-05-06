import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/screens/add_business.dart';
import 'package:project_bind/screens/authenticate/sign_in.dart';
import 'package:project_bind/screens/authenticate/sign_up.dart';

class NaviagtionDrawerWidget extends StatelessWidget {
  const NaviagtionDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepOrange[600],
              ),
              child: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return userInfo();
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
    const color = Colors.deepOrange;
    const hoverColor = Colors.black;

    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(text, style: const TextStyle(color: Colors.black)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 6:
        FirebaseAuth.instance.signOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const SignIn()));
        break;

      case 0:
        if (FirebaseAuth.instance.currentUser?.uid != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddBusiness()));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const SignIn()));
        }

        break;
    }
  }
}

Column userInfo() {
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
                children: const [
                  Text(
                    'Anony',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.badge,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                FirebaseAuth.instance.currentUser!.email.toString(),
                style: const TextStyle(
                  color: Colors.white,
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
            onPressed: () {},
            child: const Text(
              "My Businesses",
              style: TextStyle(color: Colors.black),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "following",
              style: TextStyle(color: Colors.black),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
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
              "assets/images/profile.jpg",
              height: 72,
              width: 72,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            'Guest',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ],
      ),
      SizedBox(
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
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.black),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
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
            child: const Text(
              "Sign UP",
              style: TextStyle(color: Colors.black),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),
        ],
      )
    ],
  );
}
