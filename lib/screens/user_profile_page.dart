import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project_bind/screens/add_business.dart';
import 'package:project_bind/screens/edit_business_page.dart';
import 'package:project_bind/shared/business.dart';
import 'package:project_bind/shared/navigation_drawer_widget.dart';
import 'package:project_bind/shared/reusable_widget.dart';
import 'package:project_bind/screens/Faq_page.dart';
import 'package:project_bind/screens/authenticate/google_sign_in.dart';
import 'package:project_bind/screens/business_api.dart';
import 'package:project_bind/screens/business_page.dart';
import 'package:project_bind/screens/home/home.dart';
import 'package:project_bind/screens/home/write_review_page.dart';
import 'package:project_bind/screens/landing_page.dart';
import 'package:project_bind/screens/user_edit_account_page.dart';
import 'package:project_bind/screens/user_settings_page.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UserProfile extends StatefulWidget {
  final DocumentReference Uid;
  const UserProfile({Key? key, required this.Uid}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  TabStyle _tabStyle = TabStyle.reactCircle;
  TextEditingController userNameController = TextEditingController();

  late TabController tabController;

  List<Map<String, dynamic>> followingBusinesses = List.empty(growable: true);
  List<Map<String, dynamic>> favoriteBusinesses = List.empty(growable: true);
  List<Map<String, dynamic>> myBusinesses = List.empty(growable: true);
  Map<String, dynamic> myInfo = Map();

  bool loading = true;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    getBusinessInfo();
    print(widget.Uid);
    // getUserInfo();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  getBusinessInfo() async {
    await BusinessData.businessApi.getAllBusiness();
    await BusinessData.businessApi.getDistance();
    await BusinessData.businessApi.getTime();
    await getUserInfo();

    setState(() {
      loading = false;
    });
  }

  getUserInfo() async {
    final docRef = widget.Uid;
    await docRef.get().then((DocumentSnapshot doc) {
      setState(() {
        myInfo = doc.data()!;
        print('first');
        print(myInfo);
      });
    });

    await getFollowingBusinesses();
    await getFavoriteBusinesses();
    await getMyBusiness();
  }

  getFollowingBusinesses() async {
    print('next');
    print(myInfo);
    followingBusinesses.clear();
    for (int i = 0; i < BusinessData.businessApi.businessList.length; i++) {
      for (int j = 0; j < myInfo['FollowingBusinessBid'].length; j++) {
        if (BusinessData.businessApi.businessList[i]['Bid'] ==
            myInfo['FollowingBusinessBid'][j]) {
          followingBusinesses.add(BusinessData.businessApi.businessList[i]);
        }
      }
    }
  }

  getFavoriteBusinesses() async {
    favoriteBusinesses.clear();
    for (int i = 0; i < BusinessData.businessApi.businessList.length; i++) {
      for (int j = 0; j < myInfo['FavoriteBusinessBid'].length; j++) {
        if (BusinessData.businessApi.businessList[i]['Bid'] ==
            myInfo['FavoriteBusinessBid'][j]) {
          favoriteBusinesses.add(BusinessData.businessApi.businessList[i]);
        }
      }
    }
  }

  getMyBusiness() async {
    myBusinesses.clear();

    for (int i = 0; i < BusinessData.businessApi.businessList.length; i++) {
      for (int j = 0; j < myInfo['OwnedBusinessBid'].length; j++) {
        if (BusinessData.businessApi.businessList[i]['Bid'] ==
            myInfo['OwnedBusinessBid'][j]) {
          myBusinesses.add(BusinessData.businessApi.businessList[i]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: tertiaryThemeColor(),
        elevation: 0,
      ),
      backgroundColor: tertiaryThemeColor(),
      body: loading
          ? SpinKitThreeBounce(
              color: primaryThemeColor(),
              size: 32,
            )
          : Container(
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        if (myInfo['ImageUrl'].toString().isNotEmpty)
                          ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                width: swidth * 0.3,
                                height: swidth * 0.3,
                                child: FadeInImage(
                                  image: NetworkImage('${myInfo['ImageUrl']} ',
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
                        if (myInfo['ImageUrl'].toString().isEmpty)
                          ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                width: swidth * 0.3,
                                height: swidth * 0.3,
                                child: Image.asset(
                                    "assets/images/placeholder.png"),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: sheight * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: swidth * 0.1,
                      ),
                      Text(
                        myInfo['Username'],
                        style:
                            TextStyle(color: primaryTextColor(), fontSize: 24),
                      ),
                      SizedBox(
                        width: swidth * 0.1,
                      ),
                      Icon(Icons.badge)
                    ],
                  ),
                  SizedBox(
                    height: sheight * 0.04,
                  ),
                  Container(
                    color: tertiaryThemeColor(),
                    child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor: primaryThemeColor(),
                        controller: tabController,
                        indicator: BoxDecoration(
                            color: primaryThemeColor(),
                            borderRadius: BorderRadius.circular(18)),
                        tabs: [
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("About"),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Following"),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Favourite"),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Owned"),
                            ),
                          )
                        ]),
                  ),
                  SizedBox(
                    height: sheight * 0.04,
                  ),
                  Container(
                    width: swidth,
                    height: sheight * 0.472,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        aboutTab(swidth, sheight),
                        followingTab(sheight, swidth, followingBusinesses),
                        favoriteTab(sheight, swidth, favoriteBusinesses),
                        myBusinessesTab(sheight, swidth, myBusinesses)
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Container aboutTab(double swidth, double sheight) {
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
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
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: primaryThemeColor(),
                    size: swidth * 0.08,
                  ),
                  SizedBox(
                    width: swidth * 0.08,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'First Name',
                        style:
                            TextStyle(color: primaryThemeColor(), fontSize: 18),
                      ),
                      SizedBox(
                        height: sheight * 0.01,
                      ),
                      Text(
                        myInfo['FirstName'],
                        style: TextStyle(color: primaryTextColor()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
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
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: primaryThemeColor(),
                    size: swidth * 0.08,
                  ),
                  SizedBox(
                    width: swidth * 0.08,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Name',
                        style:
                            TextStyle(color: primaryThemeColor(), fontSize: 18),
                      ),
                      SizedBox(
                        height: sheight * 0.01,
                      ),
                      Text(
                        myInfo['LastName'],
                        style: TextStyle(color: primaryTextColor()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
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
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: primaryThemeColor(),
                    size: swidth * 0.08,
                  ),
                  SizedBox(
                    width: swidth * 0.08,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Number',
                        style:
                            TextStyle(color: primaryThemeColor(), fontSize: 18),
                      ),
                      SizedBox(
                        height: sheight * 0.01,
                      ),
                      Text(
                        myInfo['PhoneNumber'],
                        style: TextStyle(color: primaryTextColor()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
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
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.email,
                    color: primaryThemeColor(),
                    size: swidth * 0.08,
                  ),
                  SizedBox(
                    width: swidth * 0.08,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style:
                            TextStyle(color: primaryThemeColor(), fontSize: 18),
                      ),
                      SizedBox(
                        height: sheight * 0.01,
                      ),
                      Text(
                        myInfo['Email'],
                        style: TextStyle(color: primaryTextColor()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (myInfo['Bio'] != '')
              Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
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
                child: Row(
                  children: [
                    Icon(
                      Icons.comment,
                      color: primaryThemeColor(),
                      size: swidth * 0.08,
                    ),
                    SizedBox(
                      width: swidth * 0.08,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bio',
                          style: TextStyle(
                              color: primaryThemeColor(), fontSize: 18),
                        ),
                        SizedBox(
                          height: sheight * 0.01,
                        ),
                        SizedBox(
                          width: swidth * 0.64,
                          child: Text(
                            myInfo['Bio'],
                            style: TextStyle(color: primaryTextColor()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Container followingTab(double sheight, double swidth,
    List<Map<String, dynamic>> followingBusinesses) {
  return Container(
    height: sheight * 0.472,
    child: Column(
      children: [
        if (followingBusinesses.isEmpty)
          Center(
            child: Text(
              'You dont follow any businesses',
              style: TextStyle(color: primaryTextColor(), fontSize: 18),
            ),
          ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: Card(
                margin: EdgeInsets.only(bottom: 16),
                color: tertiaryThemeColor(),
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Container(
                      height: sheight * 0.15,
                      width: swidth * 0.3,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FittedBox(
                        child: FadeInImage(
                          image: NetworkImage(
                              '${followingBusinesses[index]['ImageUrl']} ',
                              scale: sheight),
                          placeholder:
                              AssetImage("assets/images/placeholder.png"),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/images/error.png',
                                fit: BoxFit.cover);
                          },
                          fit: BoxFit.cover,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: sheight * 0.02, horizontal: swidth * 0.05),
                      child: Column(children: [
                        Text(
                          followingBusinesses[index]['BusinessName'],
                          style: TextStyle(
                              color: primaryTextColor(),
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: sheight * 0.012,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: swidth * 0.2,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: primaryThemeColor(),
                                    size: swidth * 0.05,
                                  ),
                                  SizedBox(
                                    width: swidth * 0.03,
                                  ),
                                  Text(
                                    followingBusinesses[index]['Rating']
                                        .toStringAsFixed(1),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: primaryTextColor()),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: swidth * 0.1,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: primaryThemeColor(),
                                    size: swidth * 0.05,
                                  ),
                                  SizedBox(
                                    width: swidth * 0.03,
                                  ),
                                  Text(
                                    '${followingBusinesses[index]['Distance'].toString()} KM',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: primaryTextColor()),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: sheight * 0.018,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: swidth * 0.2,
                              child: Text(
                                "${followingBusinesses[index]['AveragePrice']} ETB"
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: primaryTextColor()),
                              ),
                            ),
                            SizedBox(
                              width: swidth * 0.18,
                            ),
                            Container(
                              child: followingBusinesses[index]['isOpen']
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
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              onTap: () {
                BusinessManagement()
                    .updateBusinessClicks(followingBusinesses[index]['Bid']);
                BusinessManagement().updateCategoryClicks(
                    followingBusinesses[index]['Category']);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BusinessPage(
                            Bid: followingBusinesses[index]['Bid'])));
              },
            );
          },
          itemCount: followingBusinesses.length,
        ),
      ],
    ),
  );
}

Container favoriteTab(double sheight, double swidth,
    List<Map<String, dynamic>> favoriteBusinesses) {
  return Container(
      height: sheight * 0.472,
      child: Column(
        children: [
          if (favoriteBusinesses.isEmpty)
            Center(
              child: Text(
                'You dont have any favorite businesses',
                style: TextStyle(color: primaryTextColor(), fontSize: 18),
              ),
            ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Card(
                  margin: EdgeInsets.only(bottom: 16),
                  color: tertiaryThemeColor(),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Container(
                        height: sheight * 0.15,
                        width: swidth * 0.3,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: FittedBox(
                          child: FadeInImage(
                            image: NetworkImage(
                                '${favoriteBusinesses[index]['ImageUrl']} ',
                                scale: sheight),
                            placeholder:
                                AssetImage("assets/images/placeholder.png"),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/images/error.png',
                                  fit: BoxFit.cover);
                            },
                            fit: BoxFit.cover,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: sheight * 0.02,
                            horizontal: swidth * 0.05),
                        child: Column(children: [
                          Text(
                            favoriteBusinesses[index]['BusinessName'],
                            style: TextStyle(
                                color: primaryTextColor(),
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: sheight * 0.012,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: swidth * 0.2,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: primaryThemeColor(),
                                      size: swidth * 0.05,
                                    ),
                                    SizedBox(
                                      width: swidth * 0.03,
                                    ),
                                    Text(
                                      favoriteBusinesses[index]['Rating']
                                          .toStringAsFixed(1),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: primaryTextColor()),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: swidth * 0.1,
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: primaryThemeColor(),
                                      size: swidth * 0.05,
                                    ),
                                    SizedBox(
                                      width: swidth * 0.03,
                                    ),
                                    Text(
                                      '${favoriteBusinesses[index]['Distance'].toString()} KM',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: primaryTextColor()),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: sheight * 0.018,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: swidth * 0.2,
                                child: Text(
                                  "${favoriteBusinesses[index]['AveragePrice']} ETB"
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: primaryTextColor()),
                                ),
                              ),
                              SizedBox(
                                width: swidth * 0.18,
                              ),
                              Container(
                                child: favoriteBusinesses[index]['isOpen']
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
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  BusinessManagement()
                      .updateBusinessClicks(favoriteBusinesses[index]['Bid']);
                  BusinessManagement().updateCategoryClicks(
                      favoriteBusinesses[index]['Category']);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BusinessPage(
                              Bid: favoriteBusinesses[index]['Bid'])));
                },
              );
            },
            itemCount: favoriteBusinesses.length,
          ),
        ],
      ));
}

Container myBusinessesTab(
    double sheight, double swidth, List<Map<String, dynamic>> myBusinesses) {
  return Container(
    height: sheight * 0.472,
    child: Column(
      children: [
        if (myBusinesses.isEmpty)
          Center(
            child: Text(
              'You dont own any businesses',
              style: TextStyle(color: primaryTextColor(), fontSize: 18),
            ),
          ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: Card(
                margin: EdgeInsets.only(bottom: 16),
                color: tertiaryThemeColor(),
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Container(
                      height: sheight * 0.15,
                      width: swidth * 0.3,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FittedBox(
                        child: FadeInImage(
                          image: NetworkImage(
                              '${myBusinesses[index]['ImageUrl']} ',
                              scale: sheight),
                          placeholder:
                              AssetImage("assets/images/placeholder.png"),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/images/error.png',
                                fit: BoxFit.cover);
                          },
                          fit: BoxFit.cover,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: sheight * 0.02, horizontal: swidth * 0.05),
                      child: Column(children: [
                        Text(
                          myBusinesses[index]['BusinessName'],
                          style: TextStyle(
                              color: primaryTextColor(),
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: sheight * 0.012,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: swidth * 0.2,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: primaryThemeColor(),
                                    size: swidth * 0.05,
                                  ),
                                  SizedBox(
                                    width: swidth * 0.03,
                                  ),
                                  Text(
                                    myBusinesses[index]['Rating']
                                        .toStringAsFixed(1),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: primaryTextColor()),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: swidth * 0.1,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: primaryThemeColor(),
                                    size: swidth * 0.05,
                                  ),
                                  SizedBox(
                                    width: swidth * 0.03,
                                  ),
                                  Text(
                                    '${myBusinesses[index]['Distance'].toString()} KM',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: primaryTextColor()),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: sheight * 0.018,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: swidth * 0.2,
                              child: Text(
                                "${myBusinesses[index]['AveragePrice']} ETB"
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: primaryTextColor()),
                              ),
                            ),
                            SizedBox(
                              width: swidth * 0.18,
                            ),
                            Container(
                              child: myBusinesses[index]['isOpen']
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
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BusinessPage(Bid: myBusinesses[index]['Bid'])));
              },
            );
          },
          itemCount: myBusinesses.length,
        ),
      ],
    ),
  );
}
