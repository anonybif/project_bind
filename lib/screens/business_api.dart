import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';

class BusinessData {
  static BusinessApi businessApi = BusinessApi();
}

class BusinessApi {
  Map businessInfo = Map<String, dynamic>();
  List<Map<String, dynamic>> businessReview = List.empty(growable: true);
  List<Map<String, dynamic>> businessList = List.empty(growable: true);
  List<Map<String, dynamic>> duplicateItems = List.empty(growable: true);
  List<Map<String, dynamic>> userList = List.empty(growable: true);
  List<Map<String, dynamic>> followingBusinesses = List.empty(growable: true);
  List<String> businessId = [];
  List<String> myBusinessId = [];
  List<Map<String, dynamic>> myBusinesses = List.empty(growable: true);

  Map userReview = Map<String, dynamic>();
  Map myInfo = Map<String, dynamic>();
  List<bool> Liked = List.filled(6, false);
  List<List<String>> LikedUserUid = List.generate(
      6, (i) => List.filled(1, '', growable: true),
      growable: false);
  // Map distance = Map<String, double>();
  // List<Map<String, dynamic>> distance = List.empty(growable: true);
  bool noReviews = true;
  bool notReviewed = true;
  bool following = false;
  bool favorite = false;
  String isOpen = '';
  String deviceLocation = '';

  Future getDistance() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    var lat = _locationData.latitude;
    var long = _locationData.longitude;

    deviceLocation = '$lat,$long';

    for (int num = 0; num < businessList.length; num++) {
      String businessloc = businessList[num]['Location'];
      var lat2 = double.parse(businessloc.split(',')[0]);
      var long2 = double.parse(businessloc.split(',')[1]);

      businessList[num]['Distance'] = Distance()
          .as(LengthUnit.Kilometer, LatLng(lat!, long!), LatLng(lat2, long2));
      if (businessInfo['Bid'] == businessList[num]['Bid']) {
        businessInfo['Distance'] = businessList[num]['Distance'];
      }
    }
  }

  Future getTime() async {
    DateTime _time = DateTime.now();
    String timeHour = DateFormat('kk').format(_time);
    String timeMin = DateFormat('mm').format(_time);
    double oTime = 0;
    double cTime = 0;
    double now = 0;

    for (int num = 0; num < businessList.length; num++) {
      String businessOtime = businessList[num]['OpeningTime'];
      String businessCtime = businessList[num]['ClosingTime'];

      if (businessOtime.contains('PM')) {
        var oTimeHour = (double.parse(businessOtime.split(':')[0]) + 12);
        var oTimeMin =
            (double.parse(businessOtime.split(':')[1].split(' ')[0]) / 60);
        oTime = oTimeHour + oTimeMin;
      } else {
        var oTimeHour = (double.parse(businessOtime.split(':')[0]));
        var oTimeMin =
            (double.parse(businessOtime.split(':')[1].split(' ')[0]) / 60);
        oTime = oTimeHour + oTimeMin;
      }

      if (businessCtime.contains('PM')) {
        var cTimeHour = (double.parse(businessCtime.split(':')[0]) + 12);
        var cTimeMin =
            (double.parse(businessCtime.split(':')[1].split(' ')[0]) / 60);
        cTime = cTimeHour + cTimeMin;
      } else {
        var cTimeHour = (double.parse(businessCtime.split(':')[0]));
        var cTimeMin =
            (double.parse(businessCtime.split(':')[1].split(' ')[0]) / 60);
        cTime = cTimeHour + cTimeMin;
      }

      now = double.parse(timeHour) + (double.parse(timeMin) / 60);

      if (now > oTime && now < cTime) {
        businessList[num]['isOpen'] = true;
      } else {
        businessList[num]['isOpen'] = false;
      }

      if (businessInfo['Bid'] == businessList[num]['Bid']) {
        businessInfo['isOpen'] = businessList[num]['isOpen'];
      }
    }
  }

  Future getRecommendation() async {
    if (FirebaseAuth.instance.currentUser != null) {
      //category
      Map catValues = Map.from(myInfo['MostViewedCat']);
      List catVal = catValues.values.toList();
      List catKey = catValues.keys.toList();
      double catViews = 0;
      List cat = myInfo['MostViewedCat'].values.toList();

      for (int i = 0; i < cat.length; i++) {
        catViews = catViews + double.parse(cat[i].toString());
      }

      for (int i = 0; i < catVal.length; i++) {
        catValues[catKey[i]] =
            (2 / catViews) * double.parse(catVal[i].toString());
      }

      //reviews
      double totalReviews = 0;

      for (int i = 0; i < businessList.length; i++) {
        totalReviews =
            totalReviews + double.parse(businessList[i]['Reviews'].toString());
      }

      Map reviews = Map();
      for (int num = 0; num < businessList.length; num++) {
        reviews[businessList[num]['Bid']] =
            (1 / totalReviews) * businessList[num]['Reviews'];
      }

      //rating
      double totalRating = 0;

      for (int i = 0; i < businessList.length; i++) {
        totalRating =
            totalRating + double.parse(businessList[i]['Rating'].toString());
      }

      Map ratings = Map();

      for (int num = 0; num < businessList.length; num++) {
        ratings[businessList[num]['Bid']] =
            (2 / totalRating) * businessList[num]['Rating'];
      }

      //total

      for (int num = 0; num < businessList.length; num++) {
        businessList[num]['BindScore'] = ratings[businessList[num]['Bid']] +
            reviews[businessList[num]['Bid']] +
            catValues[businessList[num]['Category']];
        if (businessInfo['Bid'] == businessList[num]['Bid']) {
          businessInfo['BindScore'] = businessList[num]['BindScore'];
        }
      }
    } else {
      //reviews
      double totalReviews = 0;

      for (int i = 0; i < businessList.length; i++) {
        totalReviews =
            totalReviews + double.parse(businessList[i]['Reviews'].toString());
      }

      Map reviews = Map();
      for (int num = 0; num < businessList.length; num++) {
        reviews[businessList[num]['Bid']] =
            (1 / totalReviews) * businessList[num]['Reviews'];
      }

      //rating
      double totalRating = 0;

      for (int i = 0; i < businessList.length; i++) {
        totalRating =
            totalRating + double.parse(businessList[i]['Rating'].toString());
      }

      Map ratings = Map();

      for (int num = 0; num < businessList.length; num++) {
        ratings[businessList[num]['Bid']] =
            (2 / totalRating) * businessList[num]['Rating'];
      }

      //total

      for (int num = 0; num < businessList.length; num++) {
        businessList[num]['BindScore'] = ratings[businessList[num]['Bid']] +
            reviews[businessList[num]['Bid']];
        if (businessInfo['Bid'] == businessList[num]['Bid']) {
          businessInfo['BindScore'] = businessList[num]['BindScore'];
        }
      }
    }
  }

  getBusinessId() async {
    var ds = await FirebaseFirestore.instance.collection('business').get();
    if (ds.size != 0) {
      businessId.clear();
      for (int i = 0; i < ds.size; i++) {
        businessId.add(ds.docs[i].id);
        businessId[i] = ds.docs[i].id;
      }
    }
  }

  Future getAllBusiness() async {
    var ds = await FirebaseFirestore.instance.collection('business').get();
    if (ds.size != 0) {
      businessList.clear();
      for (int i = 0; i < ds.size; i++) {
        businessList.add(ds.docs[i].data());
        businessList[i] = ds.docs[i].data();
      }
    }
  }

  getMyBusiness() async {
    myBusinesses.clear();
    myBusinessId.clear();
    var Uid = FirebaseAuth.instance.currentUser!.uid;
    var ds = await FirebaseFirestore.instance
        .collection('business')
        .where('Uid', isEqualTo: Uid)
        .get();

    if (ds.size != 0) {
      for (int i = 0; i < ds.size; i++) {
        myBusinessId.add(ds.docs[i].id);
      }

      for (int i = 0; i < businessId.length; i++) {
        for (int j = 0; j < myBusinessId.length; j++) {
          if (businessList[i]['Bid'] == myBusinessId[j]) {
            myBusinesses.add(businessList[i]);
          }
        }
      }
    }
  }

  fetchBusiness(String Bid) async {
    var ds =
        await FirebaseFirestore.instance.collection('business').doc(Bid).get();
    if (ds.exists) {
      businessInfo = ds.data()!;
    }
  }

  fetchBusinessFollowers(String Bid) async {
    var ds =
        await FirebaseFirestore.instance.collection('business').doc(Bid).get();
    if (ds.exists) {
      businessInfo['Follows'] = ds.data()!['Follows'];
    }
  }

  getBusinessFollow(String Bid) {
    if (FirebaseAuth.instance.currentUser != null) {
      List<String> FollowingBusinessBid = <String>[];
      FollowingBusinessBid = List.from(myInfo['FollowingBusinessBid']);

      if (FollowingBusinessBid.contains(Bid)) {
        following = true;
      } else {
        following = false;
      }
    } else {
      following = false;
    }
  }

  getBusinessFavorite(String Bid) {
    if (FirebaseAuth.instance.currentUser != null) {
      List<String> FavoriteBusinessBid = <String>[];
      FavoriteBusinessBid = List.from(myInfo['FavoriteBusinessBid']);

      if (FavoriteBusinessBid.contains(Bid)) {
        favorite = true;
      } else {
        favorite = false;
      }
    } else {
      favorite = false;
    }
  }

  getFollowingBusinesses() {
    followingBusinesses.clear();
    for (int i = 0; i < businessList.length; i++) {
      for (int j = 0; j < myInfo['FollowingBusinessBid'].length; j++) {
        if (businessList[i]['Bid'] == myInfo['FollowingBusinessBid'][j]) {
          followingBusinesses.add(businessList[i]);
        }
      }
    }
  }

  // getuserReview(String Bid) async {
  //   var ds = await FirebaseFirestore.instance
  //       .collection('business')
  //       .doc(Bid)
  //       .collection('review')
  //       .where('Uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .get();

  //   if (ds.size != 0) {
  //     notReviewed = false;
  //     userReview = ds.docs[0].data();

  //     LikedUserUid[5] = List.from(userReview['LikedUserUid']);
  //     if (FirebaseAuth.instance.currentUser != null) {
  //       var Uid = FirebaseAuth.instance.currentUser!.uid;
  //       if (LikedUserUid[5].contains(Uid)) {
  //         Liked[5] = true;
  //       } else {
  //         Liked[5] = false;
  //       }
  //     }
  //   }
  // }

  Future getmyInfo() async {
    if (FirebaseAuth.instance.currentUser != null) {
      var Uid = FirebaseAuth.instance.currentUser!.uid;
      var ds = await FirebaseFirestore.instance
          .collection('user')
          .where('Uid', isEqualTo: Uid)
          .get();
      if (ds.size != 0) {
        for (var doc in ds.docs) {
          myInfo = doc.data();
        }
      }
    }
  }

  getuserInfo() async {
    var ds = await FirebaseFirestore.instance.collection('user').get();
    if (ds.size != 0) {
      userList.clear();
      for (int i = 0; i < ds.size; i++) {
        userList.add(ds.docs[i].data());
        userList[i] = ds.docs[i].data();
      }
    }
  }

  fetchReviews(String Bid) async {
    var ds = await FirebaseFirestore.instance
        .collection('business')
        .doc(Bid)
        .collection('review')
        .get();
    if (ds.size != 0) {
      noReviews = false;
      businessReview.clear();
      for (int i = 0; i < ds.size; i++) {
        businessReview.add(ds.docs[i].data());
        businessReview[i] = ds.docs[i].data();
        LikedUserUid[i] = List.from(ds.docs[i].data()['LikedUserUid']);
      }

      if (FirebaseAuth.instance.currentUser != null) {
        var Uid = FirebaseAuth.instance.currentUser!.uid;
        for (int i = 0; i < ds.size; i++) {
          if (LikedUserUid[i].contains(Uid)) {
            Liked[i] = true;
          } else {
            Liked[i] = false;
          }
        }

        for (int i = 0; i < businessReview.length; i++) {
          if (businessReview[i]['Uid'].toString().contains(Uid)) {
            notReviewed = false;
          }
        }
      }

      // for (int i = 0; i < businessReview.length; i++) {
      //   for (int j = 0; j < userList.length; j++) {
      //     if (businessReview[i]['Uid'] == userList[j]['Uid']) {
      //       businessReview[i]['Username'] = userList[j]['Username'];
      //     }
      //   }
      // }
      for (int i = 0; i < businessReview.length; i++) {
        final docRef = businessReview[i]['Uid'];
        docRef.get().then((DocumentSnapshot doc) {
          businessReview[i]['Username'] = doc.data()!['Username'];
          if (doc.data()!['ImageUrl'] != '') {
            businessReview[i]['ImageUrl'] = doc.data()!['ImageUrl'];
          } else {
            businessReview[i]['ImageUrl'] = '';
          }
        });
      }
    }
  }

  UpdateBusinessFollowers(String Bid) async {
    var ds =
        await FirebaseFirestore.instance.collection('business').doc(Bid).get();
    if (ds.exists) {
      businessInfo['Follows'] = ds.data()!['Follows'];
    }
  }

  UpdateReviewLikes(String Bid) async {
    var ds = await FirebaseFirestore.instance
        .collection('business')
        .doc(Bid)
        .collection('review')
        .get();
    if (ds.size != 0) {
      for (int i = 0; i < ds.size; i++) {
        businessReview.add({'Likes': ds.docs[i].data()['Likes']});
        businessReview[i]["Likes"] = ds.docs[i].data()["Likes"];
        LikedUserUid[i] = List.from(ds.docs[i].data()['LikedUserUid']);
      }
    }
  }

  // updateUserLikes(String Bid) async {
  //   var ds = await FirebaseFirestore.instance
  //       .collection('business')
  //       .doc(Bid)
  //       .collection('review')
  //       .where('Uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   if (ds.size != 0) {
  //     for (var doc in ds.docs) {
  //       userReview = doc.data();
  //     }
  //   }
  // }

  // getSearchResult(String query) async {
  //   var ds = await FirebaseFirestore.instance
  //       .collection('business')
  //       .where('$query', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  // }
}
