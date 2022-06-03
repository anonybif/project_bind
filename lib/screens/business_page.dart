import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project_bind/reusable_widgets/Review.dart';
import 'package:project_bind/reusable_widgets/business.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/screens/SampleNavigationApp.dart';
import 'package:project_bind/screens/business_direction_page.dart';
import 'package:project_bind/screens/home/home.dart';
import 'package:project_bind/screens/landing_page.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:location/location.dart';
import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import 'package:project_bind/utils/utils.dart';
import 'package:flutter_map/flutter_map.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage({Key? key}) : super(key: key);

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  final Stream<QuerySnapshot> reviews = FirebaseFirestore.instance
      .collection('business')
      .doc('mR2hVOogJqDvH9d5I2Z8')
      .collection('review')
      .snapshots();
  final formKey = GlobalKey<FormState>();
  final messengerKey = GlobalKey<ScaffoldMessengerState>();
  TextEditingController reviewController = TextEditingController();
  Map businessInfo = Map<String, dynamic>();
  List<Map<String, dynamic>> businessReview = List.empty(growable: true);
  Map userReview = Map<String, dynamic>();
  Map userInfo = Map<String, dynamic>();
  Map myInfo = Map<String, dynamic>();
  double distance = 0;
  List<bool> stars = List.filled(5, false);
  bool loading = true;
  bool connected = false;
  double rating = 0;
  String unrated = '';
  bool Liked = false;

  File? file1;
  File? file2;
  File? file3;

  List<String> path = ['', '', ''];
  List<String> imageName = ['', '', ''];

  UploadTask? uploadTask1;
  UploadTask? uploadTask2;
  UploadTask? uploadTask3;

  List<String> ImageUrl = ['', '', ''];

  @override
  void initState() {
    getBusinessInfo();

    super.initState();
  }

  getBusinessInfo() async {
    await checkConnection();
    if (connected) {
      await fetchBusiness();
      await getDistance();
      await fetchReviews();
      await getuserReview();
      await getmyInfo();

      setState(() {
        loading = false;
      });
    } else {
      NoConnectionDialogue(context,
          'Connect to the internet and tap retry or tap on exit to close the app ');
    }
  }

  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        connected = true;
      }
    } on SocketException catch (_) {
      print('disconnected');
      connected = false;
    }
  }

  fetchBusiness() async {
    var ds = await FirebaseFirestore.instance
        .collection('business')
        .doc('mR2hVOogJqDvH9d5I2Z8')
        .get();

    if (ds.exists) {
      businessInfo["BusinessName"] = ds.data()!["BusinessName"];
      businessInfo["Description"] = ds.data()!["Description"];
      businessInfo["ImageUrl"] = ds.data()!["ImageUrl"];
      businessInfo["Location"] = ds.data()!["Location"];
      businessInfo["Category"] = ds.data()!["Category"];
      businessInfo["Tag"] = List.from(ds.data()!["Tag"]);
      businessInfo["Claimed"] = ds.data()!["Claimed"];
      businessInfo["OpeningTime"] = ds.data()!["OpeningTime"];
      businessInfo["ClosingTime"] = ds.data()!["ClosingTime"];
      businessInfo["Uid"] = ds.data()!["Uid"];
      businessInfo["Bid"] = ds.data()!["Bid"];
      businessInfo["Email"] = ds.data()!["Email"];
      businessInfo["PhoneNumber"] = ds.data()!["PhoneNumber"];
      businessInfo["FollowNumber"] = ds.data()!["FollowNumber"];
      businessInfo["ReviewNumber"] = ds.data()!["ReviewNumber"];
      businessInfo["Stars"] = ds.data()!["Stars"];
      businessInfo["AveragePrice"] = ds.data()!["AveragePrice"];
    }
  }

  getuserReview() async {
    var ds = await FirebaseFirestore.instance
        .collection('business')
        .doc('mR2hVOogJqDvH9d5I2Z8')
        .collection('review')
        .where('Uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (var doc in ds.docs) {
      userReview = doc.data();
    }
  }

  getmyInfo() async {
    var ds = await FirebaseFirestore.instance
        .collection('user')
        .where('Uid', isEqualTo: userReview['Uid'])
        .get();
    for (var doc in ds.docs) {
      myInfo = doc.data();
    }
  }

  getuserInfo(int num) async {
    var ds = await FirebaseFirestore.instance
        .collection('user')
        .where('Uid', isEqualTo: businessReview[num]['Uid'])
        .get();
    for (var doc in ds.docs) {
      userInfo = doc.data();
    }
  }

  fetchReviews() async {
    var ds = await FirebaseFirestore.instance
        .collection('business')
        .doc('mR2hVOogJqDvH9d5I2Z8')
        .collection('review')
        .where('Uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    for (int i = 0; i < ds.size; i++) {
      businessReview.add({'Content': ds.docs[i].data()['Content']});
      businessReview[i]["Content"] = ds.docs[i].data()['Content'];
      businessReview.add({'Likes': ds.docs[i].data()['Likes']});
      businessReview[i]["Likes"] = ds.docs[i].data()["Likes"];
      businessReview.add({'Date': ds.docs[i].data()['Date']});
      businessReview[i]["Date"] = ds.docs[i].data()['Date'];
      businessReview.add({'Rating': ds.docs[i].data()['Rating']});
      businessReview[i]["Rating"] = ds.docs[i].data()['Rating'];
      businessReview.add({'Liked': false});
      businessReview[i]["Liked"] = false;
      businessReview
          .add({'ImageUrl': List.from(ds.docs[i].data()['ImageUrl'])});
      businessReview[i]["ImageUrl"] = List.from(ds.docs[i].data()['ImageUrl']);
    }
  }

  sortReview() {
    businessReview.sort((a, b) {
      var adate = a['Date']; //before -> var adate = a.expiry;
      var bdate = b['Date']; //before -> var bdate = b.expiry;
      return DateTime.parse(adate).compareTo(DateTime.parse(bdate));
    });
  }

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
    print('$lat,$long');

    String businessloc = businessInfo['Location'];
    var lat2 = double.parse(businessloc.split(',')[0]);
    var long2 = double.parse(businessloc.split(',')[1]);

    distance = Distance()
        .as(LengthUnit.Kilometer, LatLng(lat!, long!), LatLng(lat2, long2));

    print(distance);
  }

  getRating(int star) {
    setState(() {
      for (int i = 0; i < 5; i++) {
        stars[i] = false;
      }
      if (star == 1) {
        stars[0] = !stars[0];
      } else if (star == 2) {
        stars[0] = !stars[0];
        stars[1] = !stars[1];
      } else if (star == 3) {
        stars[0] = !stars[0];
        stars[1] = !stars[1];
        stars[2] = !stars[2];
      } else if (star == 4) {
        stars[0] = !stars[0];
        stars[1] = !stars[1];
        stars[2] = !stars[2];
        stars[3] = !stars[3];
      } else if (star == 5) {
        stars[0] = !stars[0];
        stars[1] = !stars[1];
        stars[2] = !stars[2];
        stars[3] = !stars[3];
        stars[4] = !stars[4];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;

    if (loading) {
      return Scaffold(
          backgroundColor: secondaryThemeColor(),
          // drawer: NaviagtionDrawerWidget(),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                flexibleSpace: FlexibleSpaceBar(
                  title: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        color: tertiaryThemeColor().withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  centerTitle: true,
                  background: Container(
                    height: sheight,
                    width: swidth,
                  ),
                ),
                pinned: true,
                expandedHeight: sheight / 4.3,
                backgroundColor: tertiaryThemeColor(),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
                  decoration: BoxDecoration(
                      color: tertiaryThemeColor(),
                      borderRadius: BorderRadius.circular(12)),
                  height: sheight / 6,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
                  decoration: BoxDecoration(
                      color: tertiaryThemeColor(),
                      borderRadius: BorderRadius.circular(12)),
                  height: sheight / 6,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
                  decoration: BoxDecoration(
                      color: tertiaryThemeColor(),
                      borderRadius: BorderRadius.circular(12)),
                  height: sheight / 6,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
                  decoration: BoxDecoration(
                      color: tertiaryThemeColor(),
                      borderRadius: BorderRadius.circular(12)),
                  height: sheight / 6,
                ),
              ]))
            ],
          ));
    } else {
      return Scaffold(
        backgroundColor: secondaryThemeColor(),
        // drawer: NaviagtionDrawerWidget(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                title: Container(
                  margin: EdgeInsets.symmetric(horizontal: swidth / 16),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: tertiaryThemeColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8)),
                  child: businessInfo['Claimed']
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              businessInfo['BusinessName'],
                              style: TextStyle(color: secondaryTextColor()),
                            ),
                            SizedBox(
                              width: swidth / 64,
                            ),
                            Icon(
                              Icons.check_circle_outline_sharp,
                              color: primaryThemeColor(),
                              size: swidth / 24,
                            )
                          ],
                        )
                      : Text(
                          businessInfo['BusinessName'],
                          style: TextStyle(color: secondaryTextColor()),
                        ),
                ),
                centerTitle: true,
                background: Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(),
                      height: sheight,
                      width: swidth,
                      child: Image.network(businessInfo['ImageUrl'],
                          fit: BoxFit.cover),
                    ),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(businessInfo['ImageUrl'],
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ]),
              ),
              pinned: true,
              expandedHeight: sheight / 4.3,
              backgroundColor: tertiaryThemeColor(),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
                  decoration: BoxDecoration(
                      color: tertiaryThemeColor(),
                      borderRadius: BorderRadius.circular(12)),
                  height: sheight / 6,
                  child: Row(children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: primaryThemeColor(),
                                    size: 21,
                                  ),
                                  SizedBox(
                                    width: swidth / 32,
                                  ),
                                  Text(
                                    businessInfo['Stars'].toString(),
                                    style: TextStyle(
                                        color: primaryTextColor(),
                                        fontSize: 16),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: sheight / 32,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  businessInfo['ReviewNumber'].toString(),
                                  style: TextStyle(color: primaryTextColor()),
                                ),
                                SizedBox(
                                  width: swidth / 32,
                                ),
                                Text(
                                  'Reviews',
                                  style: TextStyle(color: primaryTextColor()),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: sheight / 32,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  businessInfo['FollowNumber'].toString(),
                                  style: TextStyle(color: primaryTextColor()),
                                ),
                                SizedBox(
                                  width: swidth / 32,
                                ),
                                Text(
                                  'Followers',
                                  style: TextStyle(color: primaryTextColor()),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: swidth / 8,
                    ),
                    VerticalDivider(
                      thickness: 1,
                      color: primaryTextColor(),
                    ),
                    SizedBox(
                      width: swidth / 8,
                    ),
                    Container(
                      child: Column(children: [
                        Container(
                          height: sheight / 38,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: primaryThemeColor(),
                              ),
                              SizedBox(
                                width: swidth / 32,
                              ),
                              Text(
                                '${distance.toString()} KM',
                                style: TextStyle(color: primaryTextColor()),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: sheight / 32,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Text(
                                businessInfo['OpeningTime'].toString(),
                                style: TextStyle(color: primaryTextColor()),
                              ),
                              SizedBox(
                                width: swidth / 64,
                              ),
                              Text(
                                ':',
                                style: TextStyle(color: primaryTextColor()),
                              ),
                              SizedBox(
                                width: swidth / 64,
                              ),
                              Text(
                                businessInfo['ClosingTime'].toString(),
                                style: TextStyle(color: primaryTextColor()),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: sheight / 32,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Text(
                                'Average Price',
                                style: TextStyle(color: primaryTextColor()),
                              ),
                              SizedBox(
                                width: swidth / 32,
                              ),
                              Text(
                                '${businessInfo['AveragePrice'].toString()} ETB',
                                style: TextStyle(color: primaryTextColor()),
                              )
                            ],
                          ),
                        )
                      ]),
                    ),
                  ])),
              Container(
                margin: EdgeInsets.fromLTRB(5, 5, 5, 3),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12)),
                height: sheight / 21,
                child: Text(
                  'Descrption',
                  style: TextStyle(color: primaryThemeColor(), fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.fromLTRB(5, 3, 5, 5),
                decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Text(
                      '   ${businessInfo['Description']}',
                      style: TextStyle(color: primaryTextColor(), fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, 5, 5, 3),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12)),
                height: sheight / 21,
                child: Text(
                  'Business Information',
                  style: TextStyle(color: primaryThemeColor(), fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                margin: EdgeInsets.fromLTRB(5, 3, 5, 5),
                decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Phone : ',
                          style: TextStyle(
                              color: primaryTextColor(), fontSize: 16),
                        ),
                        Text(
                          '   ${businessInfo['PhoneNumber']}',
                          style: TextStyle(
                              color: primaryTextColor(), fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sheight / 64,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          ' Email : ',
                          style: TextStyle(
                              color: primaryTextColor(), fontSize: 16),
                        ),
                        Text(
                          '   ${businessInfo['Email']}',
                          style: TextStyle(
                              color: primaryTextColor(), fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Business_direction_page()));
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: tertiaryThemeColor(),
                      borderRadius: BorderRadius.circular(12)),
                  height: sheight / 2.8,
                  child: Column(
                    children: [
                      SizedBox(
                        height: sheight / 48,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Get Directions',
                              style: TextStyle(color: primaryTextColor()),
                            ),
                            SizedBox(
                              width: swidth / 32,
                            ),
                            Icon(
                              Icons.directions,
                              color: primaryThemeColor(),
                            ),
                          ]),
                      SizedBox(
                        height: sheight / 32,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Business_direction_page()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: tertiaryThemeColor(),
                              borderRadius: BorderRadius.circular(12)),
                          height: sheight / 3.7,
                          child: AbsorbPointer(
                            absorbing: true,
                            child: FlutterMap(
                              options: MapOptions(
                                center: LatLng(
                                    double.parse(businessInfo['Location']
                                        .toString()
                                        .split(',')[0]),
                                    double.parse(businessInfo['Location']
                                        .toString()
                                        .split(',')[1])),
                                screenSize: Size.fromHeight(20),
                                zoom: 16.0,
                              ),
                              layers: [
                                TileLayerOptions(
                                  urlTemplate:
                                      "https://api.mapbox.com/styles/v1/anonybif/cl3cx9hxp000g14s7hw3cq9ql/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYW5vbnliaWYiLCJhIjoiY2wzY3cwdzN0MDJsejNtcHI2NnF1ZjFwdiJ9.KmZURW1zQepysv_g6xyiiw",
                                  additionalOptions: {
                                    'accessToken':
                                        'pk.eyJ1IjoiYW5vbnliaWYiLCJhIjoiY2wzY3cwdzN0MDJsejNtcHI2NnF1ZjFwdiJ9.KmZURW1zQepysv_g6xyiiw',
                                    'id': 'mapbox.mapbox-streets-v8'
                                  },
                                ),
                                MarkerLayerOptions(markers: [
                                  Marker(
                                      width: 65.0,
                                      height: 65.0,
                                      point: LatLng(
                                          double.parse(businessInfo['Location']
                                              .toString()
                                              .split(',')[0]),
                                          double.parse(businessInfo['Location']
                                              .toString()
                                              .split(',')[1])),
                                      builder: (ctx) => Icon(Icons.location_on,
                                          color: primaryThemeColor()))
                                ])
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // if (userReview['Content'] == null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Text(
                      'Leave A Review',
                      style:
                          TextStyle(color: primaryThemeColor(), fontSize: 16),
                    ),
                    SizedBox(
                      height: sheight / 64,
                    ),
                    Center(
                      child: RatingBar.builder(
                        minRating: 1,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: primaryThemeColor(),
                        ),
                        updateOnDrag: true,
                        allowHalfRating: true,
                        onRatingUpdate: (rating) => setState(() {
                          this.rating = rating;
                        }),
                      ),
                    ),
                    Text(
                      unrated,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      height: sheight / 32,
                    ),
                    Form(
                      key: formKey,
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: primaryThemeColor()),
                              borderRadius: BorderRadius.circular(12)),
                          child: reusableTextArea('Write a review',
                              Icons.comment, false, reviewController)),
                    ),
                    SizedBox(
                      height: sheight / 32,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: sheight / 10,
                              width: sheight / 10,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: primaryThemeColor()),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Stack(children: [
                                Center(
                                  child: IconButton(
                                      onPressed: () {
                                        selectFile(0);
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.add_a_photo,
                                        color: primaryTextColor(),
                                      )),
                                ),
                                if (file1 != null)
                                  GestureDetector(
                                    child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: primaryThemeColor()),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Center(
                                        child: Image.file(
                                          File(file1!.path),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      selectFile(0);
                                      setState(() {});
                                    },
                                  )
                              ]),
                            ),
                            SizedBox(
                              width: swidth / 32,
                            ),
                            Container(
                              height: sheight / 10,
                              width: sheight / 10,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: primaryThemeColor()),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Stack(children: [
                                Center(
                                  child: IconButton(
                                      onPressed: () {
                                        selectFile(1);
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.add_a_photo,
                                        color: primaryTextColor(),
                                      )),
                                ),
                                if (file2 != null)
                                  GestureDetector(
                                    child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: primaryThemeColor()),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Center(
                                        child: Image.file(
                                          File(file2!.path),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      selectFile(1);
                                      setState(() {});
                                    },
                                  )
                              ]),
                            ),
                            SizedBox(
                              width: swidth / 32,
                            ),
                            Container(
                              height: sheight / 10,
                              width: sheight / 10,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: primaryThemeColor()),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Stack(children: [
                                Center(
                                  child: IconButton(
                                      onPressed: () {
                                        selectFile(2);
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.add_a_photo,
                                        color: primaryTextColor(),
                                      )),
                                ),
                                if (file3 != null)
                                  GestureDetector(
                                    child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: primaryThemeColor()),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Center(
                                        child: Image.file(
                                          File(file3!.path),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      selectFile(2);
                                      setState(() {});
                                    },
                                  )
                              ]),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: sheight / 48,
                        ),
                        reusableIconButton(
                            context, 'Post Review', Icons.comment, swidth / 2,
                            () async {
                          var isValid = formKey.currentState!.validate();
                          if (!isValid) {
                            return;
                          }
                          if (rating == 0) {
                            setState(() {
                              unrated = 'Give us a rating';
                            });
                            return;
                          } else {
                            unrated = '';
                            await createReview(context);
                            reviewController.text = '';
                            await getBusinessInfo();
                            // sortReview();
                            setState(() {});
                          }
                        })
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, 5, 5, 3),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12)),
                height: sheight / 21,
                child: Text(
                  'Reviews',
                  style: TextStyle(color: primaryTextColor(), fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              if (userReview['Content'] != null)
                Container(
                  margin: EdgeInsets.fromLTRB(5, 3, 5, 5),
                  decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(12, 5, 12, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        height: sheight / 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: primaryThemeColor(),
                                ),
                                SizedBox(
                                  width: swidth / 36,
                                ),
                                Text(
                                  '${myInfo['Username']}',
                                  style: TextStyle(color: primaryTextColor()),
                                )
                              ],
                            ),
                            RatingBarIndicator(
                              rating: userReview['Rating'],
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: primaryThemeColor(),
                              ),
                              itemCount: 5,
                              itemSize: swidth / 16,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sheight / 48,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryThemeColor()),
                            borderRadius: BorderRadius.circular(12)),
                        width: swidth,
                        child: Text(
                          '${userReview['Content']}',
                          style: TextStyle(color: primaryTextColor()),
                        ),
                      ),
                      SizedBox(
                        height: sheight / 64,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (userReview['ImageUrl'][0] != null &&
                              userReview['ImageUrl'][0] != '')
                            Container(
                              height: sheight / 8,
                              width: sheight / 8,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: primaryThemeColor()),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Image.network(
                                  userReview['ImageUrl'][0],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          if (userReview['ImageUrl'][0] != null &&
                              userReview['ImageUrl'][1] != '')
                            Container(
                              height: sheight / 8,
                              width: sheight / 8,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: primaryThemeColor()),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Image.network(
                                  userReview['ImageUrl'][1],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          if (userReview['ImageUrl'][0] != null &&
                              userReview['ImageUrl'][2] != '')
                            Container(
                              height: sheight / 8,
                              width: sheight / 8,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: primaryThemeColor()),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Image.network(
                                  userReview['ImageUrl'][1],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '${userReview['Date']}',
                            style: TextStyle(color: primaryTextColor()),
                          ),
                          SizedBox(
                            width: swidth / 12,
                          ),
                          Row(
                            children: [
                              Text('${userReview['Likes']}',
                                  style: TextStyle(color: primaryThemeColor())),
                              SizedBox(
                                width: swidth / 48,
                              ),
                              Text('Likes',
                                  style: TextStyle(color: primaryTextColor())),
                            ],
                          ),
                          SizedBox(
                            width: swidth / 48,
                          ),
                          Center(
                            child: IconButton(
                                onPressed: () async {
                                  if (!Liked) {
                                    await ReviewManagement().updateReviewLikes(
                                        userReview['Rid'], 'plus');
                                  } else if (Liked) {
                                    await ReviewManagement().updateReviewLikes(
                                        userReview['Rid'], 'minus');
                                  }
                                  await getuserReview();
                                  setState(() {
                                    Liked = !Liked;
                                  });
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color: Liked
                                      ? primaryThemeColor()
                                      : primaryTextColor(),
                                  size: swidth / 15,
                                )),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.share,
                                color: primaryThemeColor(),
                                size: swidth / 20,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: sheight / 48,
                      ),
                    ],
                  ),
                ),
              if (businessReview[0]['Content'] != null)
                reviewCard(0, sheight, swidth),
              if (businessReview[1]['Content'] != null)
                reviewCard(1, sheight, swidth),
              if (businessReview[2]['Content'] != null)
                reviewCard(2, sheight, swidth),
              Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12)),
                height: sheight / 4,
              ),
              Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12)),
                height: sheight / 4,
              ),
            ]))
          ],
        ),
      );
    }
  }

  NoConnectionDialogue(BuildContext context, String content) {
    double sheight = MediaQuery.of(context).size.height;
    double swidth = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(primaryThemeColor())),
                        onPressed: () {
                          getBusinessInfo();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Retry')),
                    SizedBox(
                      width: swidth / 6,
                    ),
                    TextButton(
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(primaryThemeColor())),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                        child: const Text('Exit'))
                  ],
                ),
              )
            ],
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No connection',
                  style: TextStyle(fontSize: 24, color: primaryTextColor()),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  content,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: primaryTextColor()),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            backgroundColor: secondaryThemeColor(),
          );
        });
  }

  Container reviewCard(int num, double sheight, double swidth) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 3, 5, 5),
      decoration: BoxDecoration(
          color: tertiaryThemeColor(), borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(12, 5, 12, 0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            height: sheight / 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryThemeColor(),
                    ),
                    SizedBox(
                      width: swidth / 36,
                    ),
                    Text(
                      //  '${userInfo['Username']}'
                      'Anonymous',
                      style: TextStyle(color: primaryTextColor()),
                    )
                  ],
                ),
                RatingBarIndicator(
                  rating: businessReview[num]['Rating'],
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: primaryThemeColor(),
                  ),
                  itemCount: 5,
                  itemSize: swidth / 16,
                ),
              ],
            ),
          ),
          SizedBox(
            height: sheight / 48,
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: primaryThemeColor()),
                borderRadius: BorderRadius.circular(12)),
            width: swidth,
            child: Text(
              '${businessReview[num]['Content']}',
              style: TextStyle(color: primaryTextColor()),
            ),
          ),
          SizedBox(
            height: sheight / 64,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (businessReview[num]['ImageUrl'][0] != null &&
                  businessReview[num]['ImageUrl'][0] != '')
                Container(
                  height: sheight / 8,
                  width: sheight / 8,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      border: Border.all(color: primaryThemeColor()),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Image.network(
                      businessReview[num]['ImageUrl'][0],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              if (businessReview[num]['ImageUrl'][1] != null &&
                  businessReview[num]['ImageUrl'][1] != '')
                Container(
                  height: sheight / 8,
                  width: sheight / 8,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      border: Border.all(color: primaryThemeColor()),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Image.network(
                      businessReview[num]['ImageUrl'][1],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              if (businessReview[num]['ImageUrl'][2] != null &&
                  businessReview[num]['ImageUrl'][2] != '')
                Container(
                  height: sheight / 8,
                  width: sheight / 8,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      border: Border.all(color: primaryThemeColor()),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Image.network(
                      businessReview[num]['ImageUrl'][2],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                '${businessReview[num]['Date']}',
                style: TextStyle(color: primaryTextColor()),
              ),
              SizedBox(
                width: swidth / 12,
              ),
              Row(
                children: [
                  Text('${businessReview[num]['Likes']}',
                      style: TextStyle(color: primaryThemeColor())),
                  SizedBox(
                    width: swidth / 48,
                  ),
                  Text('Likes', style: TextStyle(color: primaryTextColor())),
                ],
              ),
              SizedBox(
                width: swidth / 48,
              ),
              Center(
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        businessReview[num]['Liked'] =
                            !businessReview[num]['Liked'];
                      });
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: businessReview[num]['Liked']
                          ? primaryThemeColor()
                          : primaryTextColor(),
                      size: swidth / 15,
                    )),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.share,
                    color: primaryThemeColor(),
                    size: swidth / 20,
                  ))
            ],
          ),
          SizedBox(
            height: sheight / 48,
          ),
        ],
      ),
    );
  }

  Future selectFile(int num) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result == null)
      return;
    else if (num == 0) {
      path[num] = result.files.single.path!;
      imageName[num] = result.files.single.name;

      setState(() {
        file1 = File(path[num]);
      });
    } else if (num == 1) {
      path[num] = result.files.single.path!;
      imageName[num] = result.files.single.name;

      setState(() {
        file2 = File(path[num]);
      });
    } else if (num == 2) {
      path[num] = result.files.single.path!;
      imageName[num] = result.files.single.name;

      setState(() {
        file3 = File(path[num]);
      });
    }
  }

  Future uploadImage(int num) async {
    if (num == 0) {
      final cloudPath =
          'business/${businessInfo['BusinessName']}/review/${imageName[0]}';
      final file1 = File(path[0]);

      final ref = FirebaseStorage.instance.ref().child(cloudPath);
      setState(() {
        uploadTask1 = ref.putFile(file1);
      });
      final snapshot = await uploadTask1!.whenComplete(() {});
      ImageUrl[0] = await snapshot.ref.getDownloadURL();
      print(ImageUrl);
      setState(() {
        uploadTask1 = null;
      });
    } else if (num == 1) {
      final cloudPath =
          'business/${businessInfo['BusinessName']}/review/${imageName[1]}';
      final file2 = File(path[1]);

      final ref = FirebaseStorage.instance.ref().child(cloudPath);
      setState(() {
        uploadTask2 = ref.putFile(file2);
      });
      final snapshot = await uploadTask2!.whenComplete(() {});
      ImageUrl[1] = await snapshot.ref.getDownloadURL();
      print(ImageUrl);
      setState(() {
        uploadTask2 = null;
      });
    } else if (num == 2) {
      final cloudPath =
          'business/${businessInfo['BusinessName']}/review/${imageName[2]}';
      final file3 = File(path[2]);

      final ref = FirebaseStorage.instance.ref().child(cloudPath);
      setState(() {
        uploadTask3 = ref.putFile(file3);
      });
      final snapshot = await uploadTask3!.whenComplete(() {});
      ImageUrl[2] = await snapshot.ref.getDownloadURL();
      print(ImageUrl);
      setState(() {
        uploadTask3 = null;
      });
    }
  }

  String getDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  Future createReview(BuildContext context) async {
    if (file1 != null) await uploadImage(0);
    if (file2 != null) await uploadImage(1);
    if (file3 != null) await uploadImage(2);
    await getDate();

    final json = {
      'Content': reviewController.text.trim(),
      'Date': getDate(),
      'Rating': rating,
      'Uid': FirebaseAuth.instance.currentUser!.uid,
      'Rid': '',
      'Likes': 0,
      'ImageUrl': List.from(ImageUrl),
    };

    ReviewManagement().storeNewReview(json, context);
  }
}
