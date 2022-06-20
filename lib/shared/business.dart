import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/screens/business_page.dart';
import 'package:project_bind/screens/home/home.dart';

class BusinessManagement {
  Map businessData = Map<String, dynamic>();
  Map userData = Map<String, dynamic>();
  storeNewBusiness(json, context) async {
    final docRef = FirebaseFirestore.instance.collection('business').doc();
    final docId = docRef.id;

    await docRef.set(json).catchError((e) {
      print(e);
    });
    setbusinessId(docRef, docId);
  }

  setbusinessId(DocumentReference docRef, String docId) async {
    docRef.update({'Bid': docId});
  }

  updateBusinessFollows(String Bid, String operation) async {
    final ds1 =
        await FirebaseFirestore.instance.collection('business').doc(Bid).get();
    var Uid = FirebaseAuth.instance.currentUser!.uid;
    final ds2 =
        await FirebaseFirestore.instance.collection('user').doc(Uid).get();

    businessData = ds1.data()!;
    var ref = ds1.reference;
    userData = ds2.data()!;
    var userRef = ds2.reference;
    List<String> FollowingBusinessBid = <String>[];
    FollowingBusinessBid = List.from(userData['FollowingBusinessBid']);
    FollowingBusinessBid.removeWhere((element) => element == '');

    if (operation == 'plus') {
      var follows = double.parse(businessData["Follows"].toString()) + 1;

      FollowingBusinessBid.add(Bid);
      setBusinessFollows(ref, userRef, follows, FollowingBusinessBid);
    } else if (operation == 'minus') {
      var follows = double.parse(businessData["Follows"].toString()) - 1;

      FollowingBusinessBid.removeWhere((element) => element == Bid);
      setBusinessFollows(ref, userRef, follows, FollowingBusinessBid);
    }
  }

  setBusinessFollows(DocumentReference docRef, DocumentReference userdocRef,
      double Follows, List<String> FollowingBusinessBid) async {
    docRef.update({'Follows': Follows});
    userdocRef.update({'FollowingBusinessBid': FollowingBusinessBid});
  }

  updateBusinessReviews(String Bid, String operation) async {
    final ds =
        await FirebaseFirestore.instance.collection('business').doc(Bid).get();

    businessData = ds.data()!;
    var ref = ds.reference;

    if (operation == 'add') {
      var reviews = double.parse(businessData["Reviews"].toString()) + 1;

      setBusinessReviews(ref, reviews);
    } else if (operation == 'delete') {
      var reviews = double.parse(businessData["Reviews"].toString()) - 1;

      setBusinessReviews(ref, reviews);
    }
  }

  setBusinessReviews(DocumentReference docRef, double Reviews) async {
    docRef.update({'Reviews': Reviews});
  }

  updateBusinessRating(String Bid, double newRating, String operation) async {
    final ds =
        await FirebaseFirestore.instance.collection('business').doc(Bid).get();

    businessData = ds.data()!;
    var ref = ds.reference;

    if (operation == 'add') {
      var reviews = double.parse(businessData["Reviews"].toString());
      var rating = double.parse(businessData["Rating"].toString());

      rating = ((reviews * rating) + newRating) / (reviews + 1);
      setBusinessRating(ref, rating);
    } else if (operation == 'delete') {
      var reviews = double.parse(businessData["Reviews"].toString());
      var rating = double.parse(businessData["Rating"].toString());

      rating = ((reviews * rating) - newRating) / (reviews - 1);
      setBusinessReviews(ref, rating);
    }
  }

  setBusinessRating(DocumentReference docRef, double Rating) async {
    docRef.update({'Rating': Rating});
  }

  updateBusinessClicks(String Bid) async {
    final ds =
        await FirebaseFirestore.instance.collection('business').doc(Bid).get();

    businessData = ds.data()!;
    var ref = ds.reference;

    var clicks = double.parse(businessData["Clicks"].toString());
    clicks = clicks + 1;
    setBusinessClicks(ref, clicks);
  }

  setBusinessClicks(DocumentReference docRef, double clicks) {
    docRef.update({'Clicks': clicks});
  }

  updateCategoryClicks(String Category) async {
    if (FirebaseAuth.instance.currentUser != null) {
      var Uid = FirebaseAuth.instance.currentUser!.uid;
      print(Category);
      final ds =
          await FirebaseFirestore.instance.collection('user').doc(Uid).get();

      userData = ds.data()!;
      var ref = ds.reference;

      var clicks = double.parse(userData["MostViewedCat"][Category].toString());
      print(clicks);
      clicks = clicks + 1;
      print(clicks);
      setCategroyClicks(ref, clicks, Category);
    }
  }

  setCategroyClicks(DocumentReference docRef, double clicks, String Category) {
    docRef.update({('MostViewedCat.$Category'): clicks});
  }

  updateBusinessInfo(String Bid, json) async {
    final docRef = FirebaseFirestore.instance.collection('business').doc(Bid);

    await docRef.set(json).catchError((e) {
      print(e);
    });
  }
}
