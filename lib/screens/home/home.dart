import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/reusable_widgets/bottom_appbar_widget.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/screens/authenticate/sign_in.dart';
import 'package:project_bind/reusable_widgets/navigation_drawer_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[600],
        elevation: 0,
        title: const Text(
          "Home",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: const NaviagtionDrawerWidget(),
      body: SingleChildScrollView(
        child: Column(children: []),
      ),
      bottomNavigationBar: bottomAppbarWidget(),
    );
  }
}
