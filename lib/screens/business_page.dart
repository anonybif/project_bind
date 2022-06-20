import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project_bind/shared/Review.dart';
import 'package:project_bind/shared/business.dart';
import 'package:project_bind/shared/reusable_widget.dart';
import 'package:project_bind/screens/business_api.dart';
import 'package:project_bind/screens/business_direction_page.dart';
import 'package:project_bind/screens/reviews_page.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import 'package:flutter_map/flutter_map.dart';

class BusinessPage extends StatefulWidget {
  final String Bid;
  BusinessPage({Key? key, required this.Bid}) : super(key: key);

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  final formKey = GlobalKey<FormState>();
  final messengerKey = GlobalKey<ScaffoldMessengerState>();
  TextEditingController reviewController = TextEditingController();

  bool loading = true;
  double rating = 0;
  String unrated = '';
  int reviews = 0;
  int tag = 0;
  String report = 'Report';

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
    await BusinessData.businessApi.getmyInfo();
    await BusinessData.businessApi.getuserInfo();
    await BusinessData.businessApi.fetchBusiness(widget.Bid);
    await BusinessData.businessApi.fetchReviews(widget.Bid);
    await BusinessData.businessApi.getBusinessFollow(widget.Bid);
    await BusinessData.businessApi.getDistance();
    await BusinessData.businessApi.getTime();
    await BusinessData.businessApi.getRecommendation();
    reviews = BusinessData.businessApi.businessReview.length;
    if (reviews > 3) {
      reviews = 3;
    }
    List<dynamic> tg = BusinessData.businessApi.businessInfo['Tag'];
    for (int i = 0; i < tg.length; i++) {
      if (tg[i] == '') {
        tg.removeAt(i);
      }
    }
    tag = tg.length;

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;

    if (loading) {
      return SpinKitThreeBounce(color: primaryThemeColor(), size: 32);
    } else {
      return Scaffold(
        backgroundColor: tertiaryThemeColor(),
        // drawer: NaviagtionDrawerWidget(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                title: Container(
                  margin: EdgeInsets.symmetric(horizontal: swidth * 0.0625),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: tertiaryThemeColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8)),
                  child: BusinessData.businessApi.businessInfo['Claimed']
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              BusinessData
                                  .businessApi.businessInfo['BusinessName'],
                              style: TextStyle(color: primaryTextColor()),
                            ),
                            SizedBox(
                              width: swidth * 0.015625,
                            ),
                            Icon(
                              Icons.check_circle_outline_sharp,
                              color: primaryThemeColor(),
                              size: swidth * 0.054,
                            )
                          ],
                        )
                      : Text(
                          BusinessData.businessApi.businessInfo['BusinessName'],
                          style: TextStyle(color: primaryTextColor()),
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
                      child: Image.network(
                          BusinessData.businessApi.businessInfo['ImageUrl'],
                          fit: BoxFit.cover),
                    ),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                            BusinessData.businessApi.businessInfo['ImageUrl'],
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ]),
              ),
              pinned: true,
              expandedHeight: sheight * 0.23,
              backgroundColor: tertiaryThemeColor(),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: tertiaryThemeColor(),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: secondaryThemeColor(),
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                height: sheight * 0.11,
                child: Column(
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: swidth * 0.4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: primaryThemeColor(),
                              ),
                              SizedBox(
                                width: swidth * 0.03125,
                              ),
                              Text(
                                '${BusinessData.businessApi.businessInfo['Distance'].toString()} KM',
                                style: TextStyle(color: primaryTextColor()),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          color: primaryTextColor(),
                          thickness: 1,
                        ),
                        SizedBox(width: swidth * 0.1),
                        Container(
                          child: Row(
                            children: [
                              BusinessData.businessApi.businessInfo['isOpen']
                                  ? Text(
                                      "Open",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green),
                                    )
                                  : Text(
                                      "Closed",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sheight * 0.02,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: swidth * 0.4,
                          child: Row(
                            children: [
                              Text(
                                'Avg Price :',
                                style: TextStyle(color: primaryTextColor()),
                              ),
                              SizedBox(
                                width: swidth * 0.03125,
                              ),
                              Text(
                                '${BusinessData.businessApi.businessInfo['AveragePrice'].toString()} ETB',
                                style: TextStyle(color: primaryTextColor()),
                              )
                            ],
                          ),
                        ),
                        VerticalDivider(
                          color: primaryTextColor(),
                          thickness: 1,
                        ),
                        SizedBox(width: swidth * 0.1),
                        Container(
                          child: Row(
                            children: [
                              Text(
                                'Bind Score',
                                style: TextStyle(color: primaryTextColor()),
                              ),
                              SizedBox(
                                width: swidth * 0.03125,
                              ),
                              Text(
                                BusinessData
                                    .businessApi.businessInfo['BindScore']
                                    .toStringAsFixed(2),
                                style: TextStyle(color: primaryTextColor()),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: tertiaryThemeColor(),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: secondaryThemeColor(),
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                height: sheight * 0.12,
                child: Column(
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: swidth * 0.4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                BusinessData.businessApi.businessInfo['Reviews']
                                    .toString()
                                    .split('.')[0],
                                style: TextStyle(color: primaryTextColor()),
                              ),
                              SizedBox(
                                width: swidth * 0.03125,
                              ),
                              Text(
                                'Reviews',
                                style: TextStyle(color: primaryTextColor()),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          color: primaryTextColor(),
                          thickness: 1,
                        ),
                        SizedBox(width: swidth * 0.1),
                        Container(
                          child: RatingBarIndicator(
                            rating: double.parse(BusinessData
                                .businessApi.businessInfo['Rating']
                                .toString()),
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: primaryThemeColor(),
                            ),
                            itemCount: 5,
                            itemSize: swidth * 0.0625,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sheight * 0.02,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: swidth * 0.4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                BusinessData.businessApi.businessInfo['Follows']
                                    .toString()
                                    .split('.')[0],
                                style: TextStyle(color: primaryTextColor()),
                              ),
                              SizedBox(
                                width: swidth * 0.03125,
                              ),
                              Text(
                                'Followers',
                                style: TextStyle(color: primaryTextColor()),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          color: primaryTextColor(),
                          thickness: 1,
                        ),
                        SizedBox(width: swidth * 0.1),
                        Container(
                          child: InkWell(
                            onDoubleTap: () {},
                            onTap: () async {
                              if (FirebaseAuth.instance.currentUser != null) {
                                if (!BusinessData.businessApi.following) {
                                  await BusinessManagement()
                                      .updateBusinessFollows(
                                          widget.Bid, 'plus');
                                } else if (BusinessData.businessApi.following) {
                                  await BusinessManagement()
                                      .updateBusinessFollows(
                                          widget.Bid, 'minus');
                                }

                                await BusinessData.businessApi
                                    .fetchBusinessFollowers(widget.Bid);
                                setState(() {
                                  BusinessData.businessApi.following =
                                      !BusinessData.businessApi.following;
                                });

                                print('following');
                              } else {
                                signUpDialogue(context,
                                    'LogIn or SignUp to follow a business');
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 21, vertical: 6),
                              decoration: BoxDecoration(
                                  color: BusinessData.businessApi.following
                                      ? primaryThemeColor()
                                      : tertiaryThemeColor(),
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: primaryThemeColor())),
                              child: Center(
                                  child: BusinessData.businessApi.following
                                      ? Text(
                                          'Following',
                                          style: TextStyle(
                                              color: tertiaryThemeColor()),
                                        )
                                      : Text(
                                          'Follow',
                                          style: TextStyle(
                                              color: primaryThemeColor()),
                                        )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: tertiaryThemeColor(),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: secondaryThemeColor(),
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Descrption',
                      style:
                          TextStyle(color: primaryThemeColor(), fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: sheight * 0.015625,
                    ),
                    Text(
                      '   ${BusinessData.businessApi.businessInfo['Description']}',
                      style: TextStyle(color: primaryTextColor(), fontSize: 16),
                    ),
                  ],
                ),
              ),
              if (BusinessData.businessApi.businessInfo['Tag'].length != 0)
                Container(
                  height: sheight * 0.06,
                  width: swidth,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: secondaryThemeColor(),
                        offset: const Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: sheight * 0.04,
                    width: swidth,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          BusinessData.businessApi.businessInfo['Tag'].length,
                      itemBuilder: (context, num) {
                        return Container(
                          height: sheight * 0.05,
                          padding: EdgeInsets.fromLTRB(0, 5, 8, 5),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: tertiaryThemeColor(),
                              border: Border.all(color: primaryTextColor()),
                              borderRadius: BorderRadius.circular(16)),
                          child: Text(
                            '   ${BusinessData.businessApi.businessInfo['Tag'][num]}',
                            style: TextStyle(
                                color: primaryTextColor(), fontSize: 16),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              if (BusinessData.businessApi.businessInfo['Email'] != '' ||
                  BusinessData.businessApi.businessInfo['PhoneNumber'] != '')
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: secondaryThemeColor(),
                        offset: const Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Business Information',
                        style:
                            TextStyle(color: primaryThemeColor(), fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: sheight * 0.015625,
                      ),
                      if (BusinessData
                              .businessApi.businessInfo['PhoneNumber'] !=
                          '')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Phone : ',
                              style: TextStyle(
                                  color: primaryTextColor(), fontSize: 16),
                            ),
                            Text(
                              '   ${BusinessData.businessApi.businessInfo['PhoneNumber']}',
                              style: TextStyle(
                                  color: primaryTextColor(), fontSize: 16),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: sheight * 0.015625,
                      ),
                      if (BusinessData.businessApi.businessInfo['Email'] != '')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              ' Email : ',
                              style: TextStyle(
                                  color: primaryTextColor(), fontSize: 16),
                            ),
                            Text(
                              '   ${BusinessData.businessApi.businessInfo['Email']}',
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
                          builder: (context) => Business_direction_page(
                                location: BusinessData
                                    .businessApi.businessInfo['Location']
                                    .toString(),
                                deviceLocation:
                                    BusinessData.businessApi.deviceLocation,
                              )));
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: secondaryThemeColor(),
                        offset: const Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  height: sheight * 0.357,
                  child: Column(
                    children: [
                      SizedBox(
                        height: sheight * 0.0208,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Get Directions',
                              style: TextStyle(color: primaryTextColor()),
                            ),
                            SizedBox(
                              width: swidth * 0.03125,
                            ),
                            Icon(
                              Icons.directions,
                              color: primaryThemeColor(),
                            ),
                          ]),
                      SizedBox(
                        height: sheight * 0.03125,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Business_direction_page(
                                      location: BusinessData
                                          .businessApi.businessInfo['Location']
                                          .toString(),
                                      deviceLocation: BusinessData
                                          .businessApi.deviceLocation)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: tertiaryThemeColor(),
                              borderRadius: BorderRadius.circular(12)),
                          height: sheight * 0.2703,
                          child: AbsorbPointer(
                            absorbing: true,
                            child: FlutterMap(
                              options: MapOptions(
                                center: LatLng(
                                    double.parse(BusinessData
                                        .businessApi.businessInfo['Location']
                                        .toString()
                                        .split(',')[0]),
                                    double.parse(BusinessData
                                        .businessApi.businessInfo['Location']
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
                                          double.parse(BusinessData.businessApi
                                              .businessInfo['Location']
                                              .toString()
                                              .split(',')[0]),
                                          double.parse(BusinessData.businessApi
                                              .businessInfo['Location']
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
              if (BusinessData.businessApi.notReviewed)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: secondaryThemeColor(),
                        offset: const Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Leave A Review',
                        style:
                            TextStyle(color: primaryThemeColor(), fontSize: 16),
                      ),
                      SizedBox(
                        height: sheight * 0.015625,
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
                        height: sheight * 0.03125,
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
                        height: sheight * 0.03125,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: sheight * 0.1,
                                width: sheight * 0.1,
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
                                width: swidth * 0.03125,
                              ),
                              Container(
                                height: sheight * 0.1,
                                width: sheight * 0.1,
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
                                width: swidth * 0.03125,
                              ),
                              Container(
                                height: sheight * 0.1,
                                width: sheight * 0.1,
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
                            height: sheight * 0.0208,
                          ),
                          reusableIconButton(context, 'Post Review',
                              Icons.comment, sheight * 0.5, () async {
                            if (FirebaseAuth.instance.currentUser != null) {
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
                                await getBusinessInfo();
                                // sortReview();
                                setState(() {});
                              }
                            } else {
                              signUpDialogue(
                                  context, 'Login or SignUp to post a review');
                            }
                          })
                        ],
                      ),
                    ],
                  ),
                ),
              if (BusinessData.businessApi.businessReview.isNotEmpty)
                Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 3),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: secondaryThemeColor(),
                        offset: const Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  height: sheight * 0.0476,
                  child: Text(
                    'Reviews',
                    style: TextStyle(color: primaryTextColor(), fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (BusinessData.businessApi.businessReview.isEmpty)
                Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 3),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: secondaryThemeColor(),
                        offset: const Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  height: sheight * 0.0476,
                  child: Text(
                    'No Reviews Yet',
                    style: TextStyle(color: primaryTextColor(), fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(
                height: sheight * 0.45 * reviews,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: reviews,
                  itemBuilder: (context, num) {
                    return Card(
                      color: tertiaryThemeColor(),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 5, 3, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)),
                            height: sheight * 0.0625,
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: primaryThemeColor(),
                                    ),
                                    SizedBox(
                                      width: swidth * 0.0336,
                                    ),
                                    Text(
                                      'Username', //'${BusinessData.businessApi.businessReview[num]['Username']}',
                                      style:
                                          TextStyle(color: primaryTextColor()),
                                    )
                                  ],
                                ),
                                SizedBox(width: swidth * 0.18),
                                RatingBarIndicator(
                                  rating: BusinessData.businessApi
                                      .businessReview[num]['Rating'],
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: primaryThemeColor(),
                                  ),
                                  itemCount: 5,
                                  itemSize: swidth * 0.06,
                                ),
                                SizedBox(width: swidth * 0.035),
                                if (FirebaseAuth.instance.currentUser != null &&
                                    BusinessData.businessApi.businessReview[num]
                                            ['Uid'] !=
                                        FirebaseAuth.instance.currentUser!.uid)
                                  PopupMenuButton<MenuItem>(
                                    color: tertiaryThemeColor(),
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: primaryThemeColor(),
                                    ),
                                    onSelected: (item) async {
                                      onSelected(
                                          context,
                                          item,
                                          widget.Bid,
                                          BusinessData.businessApi
                                              .businessReview[num]['Uid']);
                                      await getBusinessInfo();
                                    },
                                    itemBuilder: (context) => [
                                      ...MenuItems.reportItems
                                          .map(buildReviewItem)
                                          .toList(),
                                    ],
                                  ),
                                if (FirebaseAuth.instance.currentUser != null &&
                                    BusinessData.businessApi.businessReview[num]
                                            ['Uid'] ==
                                        FirebaseAuth.instance.currentUser!.uid)
                                  PopupMenuButton<MenuItem>(
                                    color: tertiaryThemeColor(),
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: primaryThemeColor(),
                                    ),
                                    onSelected: (item) => onSelected(
                                        context,
                                        item,
                                        widget.Bid,
                                        BusinessData.businessApi
                                            .businessReview[num]['Rid']),
                                    itemBuilder: (context) => [
                                      ...MenuItems.deleteItems
                                          .map(buildReviewItem)
                                          .toList(),
                                    ],
                                  )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: sheight * 0.0208,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: primaryThemeColor()),
                                borderRadius: BorderRadius.circular(12)),
                            width: swidth,
                            child: Text(
                              '${BusinessData.businessApi.businessReview[num]['Content']}',
                              style: TextStyle(color: primaryTextColor()),
                            ),
                          ),
                          SizedBox(
                            height: sheight * 0.015625,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (BusinessData.businessApi.businessReview[num]
                                          ['ImageUrl'][0] !=
                                      null &&
                                  BusinessData.businessApi.businessReview[num]
                                          ['ImageUrl'][0] !=
                                      '')
                                Container(
                                  height: sheight * 0.125,
                                  width: sheight * 0.125,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: primaryThemeColor()),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                    child: Image.network(
                                      BusinessData.businessApi
                                          .businessReview[num]['ImageUrl'][0],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              if (BusinessData.businessApi.businessReview[num]
                                          ['ImageUrl'][1] !=
                                      null &&
                                  BusinessData.businessApi.businessReview[num]
                                          ['ImageUrl'][1] !=
                                      '')
                                Container(
                                  height: sheight * 0.125,
                                  width: sheight * 0.125,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: primaryThemeColor()),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                    child: Image.network(
                                      BusinessData.businessApi
                                          .businessReview[num]['ImageUrl'][1],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              if (BusinessData.businessApi.businessReview[num]
                                          ['ImageUrl'][2] !=
                                      null &&
                                  BusinessData.businessApi.businessReview[num]
                                          ['ImageUrl'][2] !=
                                      '')
                                Container(
                                  height: sheight * 0.125,
                                  width: sheight * 0.125,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: primaryThemeColor()),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                    child: Image.network(
                                      BusinessData.businessApi
                                          .businessReview[num]['ImageUrl'][2],
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
                                '${BusinessData.businessApi.businessReview[num]['Date']}',
                                style: TextStyle(color: primaryTextColor()),
                              ),
                              SizedBox(
                                width: swidth * 0.0833,
                              ),
                              Row(
                                children: [
                                  Text(
                                      '${BusinessData.businessApi.businessReview[num]['Likes'].toString().split('.')[0]}',
                                      style: TextStyle(
                                          color: primaryThemeColor())),
                                  SizedBox(
                                    width: swidth * 0.0258,
                                  ),
                                  Text('Likes',
                                      style:
                                          TextStyle(color: primaryTextColor())),
                                ],
                              ),
                              SizedBox(
                                width: swidth * 0.0258,
                              ),
                              Center(
                                child: IconButton(
                                    onPressed: () async {
                                      if (FirebaseAuth.instance.currentUser !=
                                          null) {
                                        if (!BusinessData
                                            .businessApi.Liked[num]) {
                                          await ReviewManagement()
                                              .updateReviewLikes(
                                                  (BusinessData.businessApi
                                                          .businessReview[num]
                                                      ['Rid']),
                                                  'plus',
                                                  widget.Bid);
                                        } else if (BusinessData
                                            .businessApi.Liked[num]) {
                                          await ReviewManagement()
                                              .updateReviewLikes(
                                                  (BusinessData.businessApi
                                                          .businessReview[num]
                                                      ['Rid']),
                                                  'minus',
                                                  widget.Bid);
                                        }
                                        await BusinessData.businessApi
                                            .UpdateReviewLikes(widget.Bid);
                                        setState(() {
                                          BusinessData.businessApi.Liked[num] =
                                              !BusinessData
                                                  .businessApi.Liked[num];
                                        });
                                      } else {
                                        signUpDialogue(context,
                                            'Login or SignUp to like a review');
                                      }
                                    },
                                    icon: Icon(
                                      Icons.favorite,
                                      color: BusinessData.businessApi.Liked[num]
                                          ? primaryThemeColor()
                                          : primaryTextColor(),
                                      size: swidth * 0.067,
                                    )),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.share,
                                    color: primaryThemeColor(),
                                    size: swidth * 0.05,
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: sheight * 0.0208,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (BusinessData.businessApi.businessReview.isNotEmpty)
                reusableUIButton(context, 'Show all reviews', swidth, 50, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewsPage(
                                Bid: widget.Bid,
                              )));
                })
            ]))
          ],
        ),
      );
    }
  }

  Scaffold loadingAnim(double sheight, double swidth) {
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
              expandedHeight: sheight * 0.2,
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
                height: sheight * 0.167,
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
                decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12)),
                height: sheight * 0.167,
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
                decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12)),
                height: sheight * 0.167,
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
                decoration: BoxDecoration(
                    color: tertiaryThemeColor(),
                    borderRadius: BorderRadius.circular(12)),
                height: sheight * 0.167,
              ),
            ]))
          ],
        ));
  }

  Row tags(double sheight, double swidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              color: tertiaryThemeColor(),
              border: Border.all(color: primaryThemeColor()),
              borderRadius: BorderRadius.circular(16)),
          child: Text(
            '   ${BusinessData.businessApi.businessInfo['Tag'][0]}',
            style: TextStyle(color: primaryThemeColor(), fontSize: 16),
          ),
        ),
        SizedBox(
          width: swidth * 0.05,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              color: tertiaryThemeColor(),
              border: Border.all(color: primaryThemeColor()),
              borderRadius: BorderRadius.circular(16)),
          child: Text(
            '   ${BusinessData.businessApi.businessInfo['Tag'][1]}',
            style: TextStyle(color: primaryThemeColor(), fontSize: 16),
          ),
        ),
      ],
    );
  }

  Container reviewCard(int num, double sheight, double swidth) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 3, 5, 5),
      decoration: BoxDecoration(
        color: tertiaryThemeColor(),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: secondaryThemeColor(),
            offset: const Offset(
              5.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(12, 5, 12, 0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            height: sheight * 0.0625,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryThemeColor(),
                    ),
                    SizedBox(
                      width: swidth * 0.0336,
                    ),
                    Text(
                      //  '${userInfo['Username']}'
                      'Anonymous',
                      style: TextStyle(color: primaryTextColor()),
                    )
                  ],
                ),
                RatingBarIndicator(
                  rating: BusinessData.businessApi.businessReview[num]
                      ['Rating'],
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: primaryThemeColor(),
                  ),
                  itemCount: 5,
                  itemSize: swidth * 0.0625,
                ),
              ],
            ),
          ),
          SizedBox(
            height: sheight * 0.0208,
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: primaryThemeColor()),
                borderRadius: BorderRadius.circular(12)),
            width: swidth,
            child: Text(
              '${BusinessData.businessApi.businessReview[num]['Content']}',
              style: TextStyle(color: primaryTextColor()),
            ),
          ),
          SizedBox(
            height: sheight * 0.015625,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (BusinessData.businessApi.businessReview[num]['ImageUrl'][0] !=
                      null &&
                  BusinessData.businessApi.businessReview[num]['ImageUrl'][0] !=
                      '')
                Container(
                  height: sheight * 0.125,
                  width: sheight * 0.125,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      border: Border.all(color: primaryThemeColor()),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Image.network(
                      BusinessData.businessApi.businessReview[num]['ImageUrl']
                          [0],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              if (BusinessData.businessApi.businessReview[num]['ImageUrl'][1] !=
                      null &&
                  BusinessData.businessApi.businessReview[num]['ImageUrl'][1] !=
                      '')
                Container(
                  height: sheight * 0.125,
                  width: sheight * 0.125,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      border: Border.all(color: primaryThemeColor()),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Image.network(
                      BusinessData.businessApi.businessReview[num]['ImageUrl']
                          [1],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              if (BusinessData.businessApi.businessReview[num]['ImageUrl'][2] !=
                      null &&
                  BusinessData.businessApi.businessReview[num]['ImageUrl'][2] !=
                      '')
                Container(
                  height: sheight * 0.125,
                  width: sheight * 0.125,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      border: Border.all(color: primaryThemeColor()),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Image.network(
                      BusinessData.businessApi.businessReview[num]['ImageUrl']
                          [2],
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
                '${BusinessData.businessApi.businessReview[num]['Date']}',
                style: TextStyle(color: primaryTextColor()),
              ),
              SizedBox(
                width: swidth * 0.0833,
              ),
              Row(
                children: [
                  Text(
                      '${BusinessData.businessApi.businessReview[num]['Likes'].toString().split('.')[0]}',
                      style: TextStyle(color: primaryThemeColor())),
                  SizedBox(
                    width: swidth * 0.0258,
                  ),
                  Text('Likes', style: TextStyle(color: primaryTextColor())),
                ],
              ),
              SizedBox(
                width: swidth * 0.0258,
              ),
              Center(
                child: IconButton(
                    onPressed: () async {
                      if (!BusinessData.businessApi.Liked[num]) {
                        await ReviewManagement().updateReviewLikes(
                            (BusinessData.businessApi.businessReview[num]
                                ['Rid']),
                            'plus',
                            widget.Bid);
                      } else if (BusinessData.businessApi.Liked[num]) {
                        await ReviewManagement().updateReviewLikes(
                            (BusinessData.businessApi.businessReview[num]
                                ['Rid']),
                            'minus',
                            widget.Bid);
                      }
                      await BusinessData.businessApi
                          .UpdateReviewLikes(widget.Bid);
                      setState(() {
                        BusinessData.businessApi.Liked[num] =
                            !BusinessData.businessApi.Liked[num];
                      });
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: BusinessData.businessApi.Liked[num]
                          ? primaryThemeColor()
                          : primaryTextColor(),
                      size: swidth * 0.067,
                    )),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.share,
                    color: primaryThemeColor(),
                    size: swidth * 0.05,
                  ))
            ],
          ),
          SizedBox(
            height: sheight * 0.0208,
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
          'business/${BusinessData.businessApi.businessInfo['BusinessName']}/review/${imageName[0]}';
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
          'business/${BusinessData.businessApi.businessInfo['BusinessName']}/review/${imageName[1]}';
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
          'business/${BusinessData.businessApi.businessInfo['BusinessName']}/review/${imageName[2]}';
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
    List<String> LikedUserUid = List.empty();
    final json = {
      'Content': reviewController.text.trim(),
      'Date': getDate(),
      'Rating': rating,
      'Uid': FirebaseAuth.instance.currentUser!.uid,
      'Rid': '',
      'Likes': 0,
      'ImageUrl': List.from(ImageUrl),
      'LikedUserUid': LikedUserUid,
      'Reports': 0
    };

    ReviewManagement().storeNewReview(json, context, widget.Bid);
    BusinessManagement().updateBusinessRating(widget.Bid, rating, 'add');
    BusinessManagement().updateBusinessReviews(widget.Bid, 'add');
  }
}

PopupMenuItem<MenuItem> buildReviewItem(MenuItem item) =>
    PopupMenuItem<MenuItem>(
      value: item,
      child: Row(
        children: [
          Icon(
            item.icon,
            color: warningColor(),
            size: 20,
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            item.text,
            style: TextStyle(color: primaryTextColor()),
          ),
        ],
      ),
    );

void onSelected(BuildContext context, MenuItem item, String Bid, String Rid) {
  switch (item) {
    case MenuItems.itemReport:
      reportReviewDialogue(context, Bid, Rid);
      break;
    case MenuItems.itemDelete:
      deleteReviewDialogue(context, Bid, Rid);
      break;
  }
}

Future reportReview() async {}

void deleteReviewDialogue(BuildContext context, String Bid, String Rid) {
  double sheight = MediaQuery.of(context).size.height;
  double swidth = MediaQuery.of(context).size.width;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: tertiaryThemeColor(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Delete?',
                  style: TextStyle(fontSize: 24, color: primaryTextColor()),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Do you really want to delete your review?',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: primaryTextColor()),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(
                                  primaryThemeColor())),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel')),
                      SizedBox(
                        width: swidth * 0.167,
                      ),
                      TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(
                                  primaryThemeColor())),
                          onPressed: () {
                            deleteReview(context, Bid, Rid);
                          },
                          child: Text('Delete'))
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

void reportReviewDialogue(BuildContext context, String Bid, String Rid) {
  double sheight = MediaQuery.of(context).size.height;
  double swidth = MediaQuery.of(context).size.width;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: tertiaryThemeColor(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Delete?',
                  style: TextStyle(fontSize: 24, color: primaryTextColor()),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Do you really want to delete your review?',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: primaryTextColor()),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(
                                  primaryThemeColor())),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel')),
                      SizedBox(
                        width: swidth * 0.167,
                      ),
                      TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(
                                  primaryThemeColor())),
                          onPressed: () {
                            deleteReview(context, Bid, Rid);
                          },
                          child: Text('Delete'))
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

Future deleteReview(BuildContext context, String Bid, String Rid) async {
  var ds = await FirebaseFirestore.instance
      .collection('business')
      .doc(Bid)
      .collection('review')
      .doc(Rid);

  ds.delete();
  // Utils.showSnackBar('Business succesfully deleted', messengerKey);
  Navigator.pop(context);
}
