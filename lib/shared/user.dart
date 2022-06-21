import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/screens/authenticate/verify_email_page.dart';
import 'package:project_bind/screens/home/home.dart';

class UserManagement {
  Map userData = Map<String, dynamic>();

  storeNewUser(json, context) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection('user')
        .doc(firebaseUser!.uid)
        .set(json)
        .then((value) => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home())))
        .catchError((e) {
      print(e);
    });
  }

  updateUserInfo(json) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    final docRef =
        FirebaseFirestore.instance.collection('user').doc(firebaseUser!.uid);

    await docRef.set(json).catchError((e) {
      print(e);
    });
  }

  updateUserFavorites(String Bid, String operation) async {
    var Uid = FirebaseAuth.instance.currentUser!.uid;
    final ds =
        await FirebaseFirestore.instance.collection('user').doc(Uid).get();

    userData = ds.data()!;
    var userRef = ds.reference;
    List<String> FavoriteBusinessBid = <String>[];
    FavoriteBusinessBid = List.from(userData['FavoriteBusinessBid']);
    FavoriteBusinessBid.removeWhere((element) => element == '');

    if (operation == 'plus') {
      FavoriteBusinessBid.add(Bid);
      setBusinessFavorites(userRef, FavoriteBusinessBid);
    } else if (operation == 'minus') {
      FavoriteBusinessBid.removeWhere((element) => element == Bid);
      setBusinessFavorites(userRef, FavoriteBusinessBid);
    }
  }

  setBusinessFavorites(
      DocumentReference userdocRef, List<String> FavoriteBusinessBid) async {
    userdocRef.update({'FavoriteBusinessBid': FavoriteBusinessBid});
  }
}
