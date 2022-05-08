import 'package:firebase_core/firebase_core.dart';
import 'package:project_bind/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/reusable_widgets/bottom_appbar_widget.dart';
import 'package:project_bind/reusable_widgets/navigation_drawer_widget.dart';
import 'package:project_bind/reusable_widgets/user.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage({Key? key}) : super(key: key);

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  final Stream<QuerySnapshot> business =
      FirebaseFirestore.instance.collection('business').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[600],
        elevation: 0,
        title: const Text(
          "Business Page",
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
              stream: business,
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
                          Text(
                              'Business Name:${data.docs[index]['BusinessName']}'),
                          Text(
                              'Business Description:${data.docs[index]['Description']}'),
                          Text('Claimed:${data.docs[index]['Claimed']}'),
                          Text('Email:${data.docs[index]['Email']}'),
                          Text(
                              'Phone Number:${data.docs[index]['PhoneNumber']}'),
                          Text('Location:${data.docs[index]['Location']}'),
                          Text(
                              'Opening Time:${data.docs[index]['OpeningTime']}'),
                          Text(
                              'Closing Time:${data.docs[index]['ClosingTime']}'),
                          Text(
                              'Number Of Followers:${data.docs[index]['FollowNumber']}'),
                          Text('Number Of Stars:${data.docs[index]['Stars']}'),
                          Text(
                              'Number Of Reviews:${data.docs[index]['ReviewNumber']}'),
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
        ]),
      ),
      bottomNavigationBar: bottomAppbarWidget(),
    );
  }
}
