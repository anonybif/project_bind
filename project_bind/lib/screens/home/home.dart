import 'package:firebase_core/firebase_core.dart';
import 'package:project_bind/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/reusable_widgets/bottom_appbar_widget.dart';
import 'package:project_bind/reusable_widgets/navigation_drawer_widget.dart';
import 'package:project_bind/reusable_widgets/user.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> user = FirebaseFirestore.instance
      .collection('user')
      .where("Email", isEqualTo: FirebaseAuth.instance.currentUser?.email)
      .snapshots();
  String userName = '';
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
        padding: const EdgeInsets.all(5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 300,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: StreamBuilder<QuerySnapshot>(
              stream: user,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (FirebaseAuth.instance.currentUser != null) {
                  if (snapshot.hasError) {
                    return const Text('smtn went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final data = snapshot.requireData;

                  return ListView.builder(
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('First Name:${data.docs[index]['FirstName']}'),
                          Text('Last Name:${data.docs[index]['LastName']}'),
                          Text('Username:${data.docs[index]['Username']}'),
                          Text('Email:${data.docs[index]['Email']}'),
                          Text(
                              'Phone Number:${data.docs[index]['PhoneNumber']}'),
                          Text('Location:${data.docs[index]['Location']}'),
                          Text('Bio:${data.docs[index]['Bio']}'),
                          Text('Badge:${data.docs[index]['Badge']}'),
                          const Divider(
                            thickness: 1,
                          )
                        ],
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          Center(
            child: FutureBuilder(
              future: fetch(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const CircularProgressIndicator();
                }
                return Column(
                  children: [
                    Text("UserName : $userName"),
                  ],
                );
              },
            ),
          ),
        ]),
      ),
      bottomNavigationBar: bottomAppbarWidget(),
    );
  }

  fetch() async {
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
  }
}
