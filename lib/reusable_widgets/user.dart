import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/screens/home/home.dart';

class UserManagement {
  storeNewUser(user, json, context) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection('user')
        .doc(firebaseUser!.uid)
        .set(json)
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Home())))
        .catchError((e) {
      print(e);
    });
  }
}
