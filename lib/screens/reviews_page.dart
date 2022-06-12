import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project_bind/reusable_widgets/Review.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/screens/business_api.dart';
import 'package:project_bind/utils/color_utils.dart';

class ReviewsPage extends StatefulWidget {
  final String Bid;
  ReviewsPage({Key? key, required this.Bid}) : super(key: key);

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  var review;
  @override
  void initState() {
    review = FirebaseFirestore.instance
        .collection('business')
        .doc(widget.Bid)
        .collection('review')
        .snapshots();
    // getBusinessInfo();
    super.initState();
  }

  bool loading = true;
  bool connected = false;
  double rating = 0;
  String unrated = '';
  BusinessApi businessApi = BusinessApi();

  getBusinessInfo() async {
    await checkConnection();
    if (connected) {
      await BusinessData.businessApi.fetchBusiness(widget.Bid);
      await BusinessData.businessApi.getDistance();
      await BusinessData.businessApi.fetchReviews(widget.Bid);
      await BusinessData.businessApi.getuserReview(widget.Bid);
      await BusinessData.businessApi.getmyInfo();
      await BusinessData.businessApi.getBusinessFollow(widget.Bid);
      setState(() {
        loading = false;
      });
    } else {
      NoConnectionDialogue(context, getBusinessInfo());
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

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    if (loading) {
      return Scaffold();
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange[600],
          elevation: 0,
          title: const Text(
            "Home",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: sheight,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: StreamBuilder<QuerySnapshot>(
                stream: review,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (FirebaseAuth.instance.currentUser != null) {
                    if (snapshot.hasError) {
                      return const Text('smtn went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    final data = snapshot.requireData;

                    return ListView.builder(
                      itemCount: data.size,
                      itemBuilder: (context, num) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Text('First Name:${data.docs[num]['FirstName']}'),
                            // Container reviewCard(int num, double sheight, double swidth) {
                            Container(
                              margin: EdgeInsets.fromLTRB(5, 3, 5, 5),
                              decoration: BoxDecoration(
                                  color: tertiaryThemeColor(),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(12, 5, 12, 0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    height: sheight * 0.0625,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  primaryThemeColor(),
                                            ),
                                            SizedBox(
                                              width: swidth * 0.0336,
                                            ),
                                            Text(
                                              //  '${userInfo['Username']}'
                                              'Anonymous',
                                              style: TextStyle(
                                                  color: primaryTextColor()),
                                            )
                                          ],
                                        ),
                                        RatingBarIndicator(
                                          rating: data.docs[num]['Rating'],
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
                                        border: Border.all(
                                            color: primaryThemeColor()),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    width: swidth,
                                    child: Text(
                                      '${data.docs[num]['Content']}',
                                      style:
                                          TextStyle(color: primaryTextColor()),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sheight * 0.015625,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      if (data.docs[num]['ImageUrl'][0] !=
                                              null &&
                                          data.docs[num]['ImageUrl'][0] != '')
                                        Container(
                                          height: sheight * 0.125,
                                          width: sheight * 0.125,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: primaryThemeColor()),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Center(
                                            child: Image.network(
                                              data.docs[num]['ImageUrl'][0],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      if (data.docs[num]['ImageUrl'][1] !=
                                              null &&
                                          data.docs[num]['ImageUrl'][1] != '')
                                        Container(
                                          height: sheight * 0.125,
                                          width: sheight * 0.125,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: primaryThemeColor()),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Center(
                                            child: Image.network(
                                              data.docs[num]['ImageUrl'][1],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      if (data.docs[num]['ImageUrl'][2] !=
                                              null &&
                                          data.docs[num]['ImageUrl'][2] != '')
                                        Container(
                                          height: sheight * 0.125,
                                          width: sheight * 0.125,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: primaryThemeColor()),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Center(
                                            child: Image.network(
                                              data.docs[num]['ImageUrl'][2],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        '${data.docs[num]['Date']}',
                                        style: TextStyle(
                                            color: primaryTextColor()),
                                      ),
                                      SizedBox(
                                        width: swidth * 0.0833,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              '${data.docs[num]['Likes'].toString().split('.')[0]}',
                                              style: TextStyle(
                                                  color: primaryThemeColor())),
                                          SizedBox(
                                            width: swidth * 0.0258,
                                          ),
                                          Text('Likes',
                                              style: TextStyle(
                                                  color: primaryTextColor())),
                                        ],
                                      ),
                                      SizedBox(
                                        width: swidth * 0.0258,
                                      ),
                                      // Center(
                                      //   child: IconButton(
                                      //       onPressed: () async {
                                      //         if (!BusinessData.businessApi.Liked[num]) {
                                      //           await ReviewManagement()
                                      //               .updateReviewLikes(
                                      //                   (businessApi
                                      //                           .businessReview[
                                      //                       num]['Rid']),
                                      //                   'plus',
                                      //                   widget.Bid);
                                      //         } else if (businessApi
                                      //             .Liked[num]) {
                                      //           await ReviewManagement()
                                      //               .updateReviewLikes(
                                      //                   (businessApi
                                      //                           .businessReview[
                                      //                       num]['Rid']),
                                      //                   'minus',
                                      //                   widget.Bid);
                                      //         }
                                      //         await businessApi
                                      //             .UpdateReviewLikes(
                                      //                 widget.Bid);
                                      //         setState(() {
                                      //           BusinessData.businessApi.Liked[num] =
                                      //               !BusinessData.businessApi.Liked[num];
                                      //         });
                                      //       },
                                      //       icon: Icon(
                                      //         Icons.favorite,
                                      //         color: BusinessData.businessApi.Liked[num]
                                      //             ? primaryThemeColor()
                                      //             : primaryTextColor(),
                                      //         size: swidth * 0.067,
                                      //       )),
                                      // ),
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
                            )
                          ],
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ]),
        ),
      );
    }
  }
}
