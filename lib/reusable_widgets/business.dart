import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/screens/business_page.dart';
import 'package:project_bind/screens/home/home.dart';

class BusinessManagement {
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

  updateBusiness(json, context) async {
    final businessDoc =
        FirebaseFirestore.instance.collection('business').doc('');
  }
}

// class BusinessInfo {
//   String BusinessName;
//   String Description;
//   String ImageUrl;
//   String Location;
//   String Category;
//   List<String> Tag;
//   bool Claimed;
//   String OpeningTime;
//   String ClosingTime;
//   String Uid;
//   String Bid;
//   String Email;
//   String PhoneNumber;
//   int AveragePrice;
//   int FollowNumber;
//   int ReviewNumber;
//   int Stars;

//   BusinessInfo({
//     required this.BusinessName,
//     required this.Description,
//     required this.ImageUrl,
//     required this.Category,
//     required this.OpeningTime,
//     required this.ClosingTime,
//     required this.Location,
//     required this.Tag,
//     required this.Claimed,
//     required this.Uid,
//     required this.Bid,
//     required this.Email,
//     required this.PhoneNumber,
//     required this.AveragePrice,
//     required this.FollowNumber,
//     required this.ReviewNumber,
//     required this.Stars,
//   });

//   Map<String, dynamic> toJson() => {
//         'BusinessName': BusinessName,
//         'Description': Description,
//         'AveragePrice': AveragePrice,
//         'ImageUrl': ImageUrl,
//         'Location': Location,
//         'Category': Category,
//         'Tag': Tag,
//         'Claimed': Claimed,
//         'Bid': Bid,
//         'Email': Email,
//         'PhoneNumber': PhoneNumber,
//         'OpeningTime': OpeningTime,
//         'ClosingTime': ClosingTime,
//         'Uid': Uid,
//         'ReviewNumber': ReviewNumber,
//         'Stars': Stars,
//         'FollowNumber': FollowNumber
//       };

//       static BusinessInfo fromJson(Map<String,dynamic> json) => BusinessInfo(
//         BusinessName: 'BusinessName',
//          Description: 'Description',
//           ImageUrl: 'ImageUrl',
//            Category: 'Category',
//             OpeningTime: 'OpeningTime',
//             ClosingTime: 'ClosingTime',
//              Location: 'Location',
//              Tag: 'Tag',
//              Claimed: 'Claimed',
//              Uid: 'Uid', Bid: 'Bid',
//               Email: 'Email',
//                PhoneNumber: 'PhoneNumber',
//                AveragePrice: 'AveragePrice',
//                 FollowNumber: 'FollowNumber',
//                  ReviewNumber: 'ReviewNumber',
//                   Stars: 'Stars',
//                   )
// }

class BusinessInfo {
  String BusinessName = '';
  String Description = '';
  String ImageUrl = '';
  String Location = '';
  String Category = '';
  List<String> Tag = ['', '', '', ''];
  bool Claimed = false;
  String OpeningTime = '';
  String ClosingTime = '';
  String Uid = '';
  String Bid = '';
  String Email = '';
  String PhoneNumber = '';
  int AveragePrice = 0;
  int FollowNumber = 0;
  int ReviewNumber = 0;
  int Stars = 0;

  BusinessInfo(
      String BusinessName,
      String Description,
      String ImageUrl,
      String Location,
      String Category,
      List<String> Tag,
      bool Claimed,
      String OpeningTime,
      String ClosingTime,
      String Uid,
      String Bid,
      String Email,
      String PhoneNumber,
      int AveragePrice,
      int FollowNumber,
      int ReviewNumber,
      int Stars) {
    this.BusinessName = BusinessName;
    this.Description = Description;
    this.ImageUrl = ImageUrl;
    this.Category = Category;
    this.OpeningTime = OpeningTime;
    this.ClosingTime = ClosingTime;
    this.Location = Location;
    this.Tag = Tag;
    this.Claimed = Claimed;
    this.Uid = Uid;
    this.Bid = Bid;
    this.Email = Email;
    this.PhoneNumber = PhoneNumber;
    this.AveragePrice = AveragePrice;
    this.FollowNumber = FollowNumber;
    this.ReviewNumber = ReviewNumber;
    this.Stars = Stars;
  }
}
