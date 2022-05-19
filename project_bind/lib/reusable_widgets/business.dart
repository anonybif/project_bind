import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/screens/business_page.dart';
import 'package:project_bind/screens/home/home.dart';

class BusinessManagement {
  storeNewBusiness(json, context) async {
    FirebaseFirestore.instance
        .collection('business')
        .doc()
        .set(json)
        .catchError((e) {
      print(e);
    });
  }

  updateBusiness(json, context) async {
    final businessDoc =
        FirebaseFirestore.instance.collection('business').doc('');
  }
}
