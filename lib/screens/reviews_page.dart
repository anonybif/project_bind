import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project_bind/shared/Review.dart';
import 'package:project_bind/shared/reusable_widget.dart';
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
    getBusinessInfo();
    super.initState();
  }

  bool loading = true;
  bool connected = false;
  double rating = 0;
  String unrated = '';
  List<String> Likes = List.empty(growable: true);

  getBusinessInfo() async {
    print('1');
    await BusinessData.businessApi.getuserInfo();
    await BusinessData.businessApi.fetchReviews(widget.Bid);
    await BusinessData.businessApi.getmyInfo();
    await BusinessData.businessApi.getBusinessFollow(widget.Bid);

    setState(() {
      loading = false;
    });
  }

  Stream getReviewLikes(String Rid) async* {
    var ds = await FirebaseFirestore.instance
        .collection('business')
        .doc(widget.Bid)
        .collection('review')
        .doc(Rid)
        .get();

    print(ds.data()!['Likes']);
    yield ds.data()!['Likes'];
  }

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    if (loading) {
      return Scaffold(
        backgroundColor: tertiaryThemeColor(),
        appBar: AppBar(
          backgroundColor: tertiaryThemeColor(),
          elevation: 1,
          title: Text(
            "Reviews",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryTextColor()),
          ),
          centerTitle: true,
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: tertiaryThemeColor(),
        appBar: AppBar(
          backgroundColor: tertiaryThemeColor(),
          elevation: 10,
          title: Text(
            "Reviews",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryTextColor()),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: sheight * 0.9,
                child: ListView.builder(
                  itemCount: BusinessData.businessApi.businessReview.length,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    if (BusinessData
                                        .businessApi.myInfo['ImageUrl']
                                        .toString()
                                        .isNotEmpty)
                                      ClipOval(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            width: swidth * 0.1,
                                            height: swidth * 0.1,
                                            child: FadeInImage(
                                              image: NetworkImage(
                                                  '${BusinessData.businessApi.businessReview[num]['UserImageUrl']} ',
                                                  scale: sheight),
                                              placeholder: AssetImage(
                                                  "assets/images/placeholder.png"),
                                              imageErrorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                    'assets/images/error.png',
                                                    fit: BoxFit.cover);
                                              },
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (BusinessData.businessApi
                                        .businessReview[num]['ImageUrl']
                                        .toString()
                                        .isEmpty)
                                      ClipOval(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            width: swidth * 0.1,
                                            height: swidth * 0.1,
                                            child: Image.asset(
                                                "assets/images/placeholder.png"),
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      width: swidth * 0.0336,
                                    ),
                                    Text(
                                      '${BusinessData.businessApi.businessReview[num]['Username']}',
                                      style:
                                          TextStyle(color: primaryTextColor()),
                                    )
                                  ],
                                ),
                                Row(children: [
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
                                  if (FirebaseAuth.instance.currentUser !=
                                          null &&
                                      BusinessData.businessApi
                                              .businessReview[num]['Uid'] !=
                                          FirebaseAuth
                                              .instance.currentUser!.uid)
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
                                              .businessReview[num]['Rid'],
                                          getBusinessInfo()),
                                      itemBuilder: (context) => [
                                        ...ReviewMenuItems.reportItems
                                            .map(buildItem)
                                            .toList(),
                                      ],
                                    ),
                                  if (FirebaseAuth.instance.currentUser !=
                                          null &&
                                      BusinessData.businessApi
                                              .businessReview[num]['Uid'] ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid)
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
                                              .businessReview[num]['Rid'],
                                          getBusinessInfo()),
                                      itemBuilder: (context) => [
                                        ...ReviewMenuItems.deleteItems
                                            .map(buildItem)
                                            .toList(),
                                      ],
                                    )
                                ])
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
                                    child: FadeInImage(
                                      image: NetworkImage(
                                        '${BusinessData.businessApi.businessReview[num]['ImageUrl'][0]} ',
                                      ),
                                      placeholder: AssetImage(
                                          "assets/images/placeholder.png"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                            'assets/images/error.png',
                                            fit: BoxFit.fitWidth);
                                      },
                                      fit: BoxFit.fitWidth,
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
                                    child: FadeInImage(
                                      image: NetworkImage(
                                        '${BusinessData.businessApi.businessReview[num]['ImageUrl'][1]} ',
                                      ),
                                      placeholder: AssetImage(
                                          "assets/images/placeholder.png"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                            'assets/images/error.png',
                                            fit: BoxFit.fitWidth);
                                      },
                                      fit: BoxFit.fitWidth,
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
                                    child: FadeInImage(
                                      image: NetworkImage(
                                        '${BusinessData.businessApi.businessReview[num]['ImageUrl'][2]} ',
                                      ),
                                      placeholder: AssetImage(
                                          "assets/images/placeholder.png"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                            'assets/images/error.png',
                                            fit: BoxFit.fitWidth);
                                      },
                                      fit: BoxFit.fitWidth,
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
                              StreamBuilder(
                                stream: getReviewLikes(BusinessData
                                    .businessApi.businessReview[num]['Rid']),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    String Likes =
                                        snapshot.data.toString().split('.')[0];
                                    return Row(
                                      children: [
                                        Text('${Likes}',
                                            style: TextStyle(
                                                color: primaryThemeColor())),
                                        SizedBox(
                                          width: swidth * 0.0258,
                                        ),
                                        Text('Likes',
                                            style: TextStyle(
                                                color: primaryTextColor())),
                                      ],
                                    );
                                  } else {
                                    return Row(
                                      children: [
                                        Text(
                                            '${BusinessData.businessApi.businessReview[num]['Likes'].toString().split('.')[0]}',
                                            style: TextStyle(
                                                color: primaryThemeColor())),
                                        SizedBox(
                                          width: swidth * 0.0258,
                                        ),
                                        Text('Likes',
                                            style: TextStyle(
                                                color: primaryTextColor())),
                                      ],
                                    );
                                  }
                                },
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

                                        // await BusinessData.businessApi
                                        //     .UpdateReviewLikes(widget.Bid);
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
            ],
          ),
        ),
      );
    }
  }
}

PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
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

void onSelected(BuildContext context, MenuItem item, String Bid, String Rid,
    Function reload) {
  switch (item) {
    case ReviewMenuItems.itemReport:
      reportReviewDialogue(context, Bid, Rid, reload);
      break;
    case ReviewMenuItems.itemDelete:
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

void reportReviewDialogue(
    BuildContext context, String Bid, String Rid, Function reload) {
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
                              foregroundColor:
                                  MaterialStateProperty.all(warningColor())),
                          onPressed: () async {
                            deleteReview(context, Bid, Rid);
                            await reload();
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
