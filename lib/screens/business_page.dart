import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  final Stream<QuerySnapshot> business =
      FirebaseFirestore.instance.collection('business').snapshots();
  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  Map businessInfo = Map<String, dynamic>();
  double distance = 0;
  List<bool> stars = List.filled(5, false);
  bool loading = true;
  bool connected = false;

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
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(color: primaryTextColor(), fontSize: 16),
                    ),
                    SizedBox(
                      height: sheight / 48,
                    ),
                    Text(
                      '   ${businessInfo['Description']}',
                      style: TextStyle(color: primaryTextColor(), fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Text(
                      'Business Information',
                      style: TextStyle(color: primaryTextColor(), fontSize: 16),
                    ),
                    SizedBox(
                      height: sheight / 48,
                    ),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12)),
                height: sheight / 3.5,
                child: Column(
                  children: [
                    Text(
                      'Rate',
                      style: TextStyle(color: primaryTextColor(), fontSize: 16),
                    ),
                    SizedBox(
                      height: sheight / 64,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              getRating(1);
                            },
                            icon: Icon(
                              Icons.star,
                              color: stars[0]
                                  ? primaryThemeColor()
                                  : primaryTextColor(),
                              size: sheight / 24,
                            )),
                        IconButton(
                            onPressed: () {
                              getRating(2);
                            },
                            icon: Icon(
                              Icons.star,
                              color: stars[1]
                                  ? primaryThemeColor()
                                  : primaryTextColor(),
                              size: sheight / 24,
                            )),
                        IconButton(
                            onPressed: () {
                              getRating(3);
                            },
                            icon: Icon(
                              Icons.star,
                              color: stars[2]
                                  ? primaryThemeColor()
                                  : primaryTextColor(),
                              size: sheight / 24,
                            )),
                        IconButton(
                            onPressed: () {
                              getRating(4);
                            },
                            icon: Icon(
                              Icons.star,
                              color: stars[3]
                                  ? primaryThemeColor()
                                  : primaryTextColor(),
                              size: sheight / 24,
                            )),
                        IconButton(
                            onPressed: () {
                              getRating(5);
                            },
                            icon: Icon(
                              Icons.star,
                              color: stars[4]
                                  ? primaryThemeColor()
                                  : primaryTextColor(),
                              size: sheight / 24,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: sheight / 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: primaryThemeColor(),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.add_a_photo,
                                    color: primaryTextColor(),
                                  )),
                              radius: 28,
                            ),
                            SizedBox(
                              height: sheight / 48,
                            ),
                            Text(
                              'Add an Image',
                              style: TextStyle(
                                  color: primaryTextColor(), fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: primaryThemeColor(),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.comment,
                                    color: primaryTextColor(),
                                  )),
                              radius: 28,
                            ),
                            SizedBox(
                              height: sheight / 48,
                            ),
                            Text(
                              'Add a review',
                              style: TextStyle(
                                  color: primaryTextColor(), fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
}
