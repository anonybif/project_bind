import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';

class BusinessData {
  static BusinessApi businessApi = BusinessApi();
}

class BusinessApi {
  // static BusinessApi _instance = BusinessApi();

  // factory BusinessApi()=> _instance ?? = new BusinessApi._();
  // BusinessApi._();

  Map businessInfo = Map<String, dynamic>();
  List<Map<String, dynamic>> businessReview = List.empty(growable: true);
  List<Map<String, dynamic>> businessList = List.empty(growable: true);
  List<Map<String, dynamic>> businessRecommend = List.empty(growable: true);
  List<Map<String, dynamic>> businessNearby = List.empty(growable: true);
  List<String> businessId = [];
  Map userReview = Map<String, dynamic>();
  Map userInfo = Map<String, dynamic>();
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

  String isOpen = '';

  getDistance() async {
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

  getTime() async {
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

  getBusinessId() async {
    var ds = await FirebaseFirestore.instance.collection('business').get();
    if (ds.size != 0) {
      for (int i = 0; i < ds.size; i++) {
        businessId.add(ds.docs[i].id);
        businessId[i] = ds.docs[i].id;
      }
    }
  }

  getAllBusiness() async {
    var ds = await FirebaseFirestore.instance.collection('business').get();
    if (ds.size != 0) {
      for (int i = 0; i < ds.size; i++) {
        businessList.add(ds.docs[i].data());
        businessList[i] = ds.docs[i].data();
        // distance.add({'Bid': businessId[i]});
        // distance[i]['Bid'] = businessId[i];
        // distance.add({'Distance': 0});
        // distance[i]['Distance'] = 0;
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
    List<String> FollowingBusinessBid = <String>[];
    FollowingBusinessBid = List.from(myInfo['FollowingBusinessBid']);

    if (FollowingBusinessBid.contains(Bid)) {
      following = true;
    } else {
      following = false;
    }
  }

  getuserReview(String Bid) async {
    var ds = await FirebaseFirestore.instance
        .collection('business')
        .doc(Bid)
        .collection('review')
        .where('Uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (ds.size != 0) {
      notReviewed = false;
      userReview = ds.docs[0].data();

      LikedUserUid[5] = List.from(userReview['LikedUserUid']);
      if (FirebaseAuth.instance.currentUser != null) {
        var Uid = FirebaseAuth.instance.currentUser!.uid;
        if (LikedUserUid[5].contains(Uid)) {
          Liked[5] = true;
        } else {
          Liked[5] = false;
        }
      }
    }
  }

  getmyInfo() async {
    var ds = await FirebaseFirestore.instance
        .collection('user')
        .where('Uid', isEqualTo: userReview['Uid'])
        .get();
    if (ds.size != 0) {
      for (var doc in ds.docs) {
        myInfo = doc.data();
      }
    }
  }

  getuserInfo(int num) async {
    var ds = await FirebaseFirestore.instance
        .collection('user')
        .where('Uid', isEqualTo: businessReview[num]['Uid'])
        .get();
    if (ds.size != 0) {
      for (var doc in ds.docs) {
        userInfo = doc.data();
      }
    }
  }

  fetchBusinessbyCat() {}

  fetchNearbyBusiness() async {
    businessList.sort((m1, m2) {
      return m1['Distance'].compareTo(m2['Distance']);
    });

    businessNearby = List.from(businessList);
  }

  fetchRecommendBusiness() async {
    businessList.sort((m1, m2) {
      return m2['BindScore'].compareTo(m1['BindScore']);
    });

    businessRecommend = List.from(businessList);
  }

  fetchReviews(String Bid) async {
    var ds = await FirebaseFirestore.instance
        .collection('business')
        .doc(Bid)
        .collection('review')
        .where('Uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (ds.size != 0) {
      noReviews = false;
      for (int i = 0; i < ds.size; i++) {
        businessReview.add(ds.docs[i].data());
        businessReview[i] = ds.docs[i].data();
        LikedUserUid[i] = List.from(ds.docs[i].data()['LikedUserUid']);
      }
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
        .where('Uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (ds.size != 0) {
      for (int i = 0; i < ds.size; i++) {
        businessReview.add({'Likes': ds.docs[i].data()['Likes']});
        businessReview[i]["Likes"] = ds.docs[i].data()["Likes"];
        LikedUserUid[i] = List.from(ds.docs[i].data()['LikedUserUid']);
      }
    }
  }

  updateUserLikes(String Bid) async {
    var ds = await FirebaseFirestore.instance
        .collection('business')
        .doc(Bid)
        .collection('review')
        .where('Uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (ds.size != 0) {
      for (var doc in ds.docs) {
        userReview = doc.data();
      }
    }
  }

  sortReview() {
    businessReview.sort((a, b) {
      var adate = a['Date']; //before -> var adate = a.expiry;
      var bdate = b['Date']; //before -> var bdate = b.expiry;
      return DateTime.parse(adate).compareTo(DateTime.parse(bdate));
    });
  }

  getSearchResult(String query) async {
    var ds = await FirebaseFirestore.instance
        .collection('business')
        .where('$query', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
  }
}
