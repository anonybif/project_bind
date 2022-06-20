import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
import 'package:project_bind/screens/support_page.dart';
import 'package:project_bind/screens/user_edit_account_page.dart';
import 'package:project_bind/screens/user_settings_page.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

const _kPages = <String, IconData>{
  'home': Icons.home,
  'write': Icons.add,
  'profile': Icons.account_circle_outlined,
};

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  TabStyle _tabStyle = TabStyle.reactCircle;
  TextEditingController userNameController = TextEditingController();
  final List<Tab> myTabs = <Tab>[
    new Tab(text: 'LEFT'),
    new Tab(text: 'RIGHT'),
  ];

  late TabController tabController;

  List<Map<String, dynamic>> followingBusinesses = List.empty(growable: true);

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    // getUserInfo();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  Future getUserInfo() async {
    await BusinessData.businessApi.getmyInfo();
    return BusinessData.businessApi.myInfo;
  }

  Future getFollowingBusinesses() async {
    await BusinessData.businessApi.getAllBusiness();
    await BusinessData.businessApi.getDistance();
    await BusinessData.businessApi.getTime();
    // await getFollowingBusinesses();
    followingBusinesses.clear();
    for (int i = 0; i < BusinessData.businessApi.businessList.length; i++) {
      for (int j = 0;
          j < BusinessData.businessApi.myInfo['FollowingBusinessBid'].length;
          j++) {
        if (BusinessData.businessApi.businessList[i]['Bid'] ==
            BusinessData.businessApi.myInfo['FollowingBusinessBid'][j]) {
          followingBusinesses.add(BusinessData.businessApi.businessList[i]);
        }
      }
    }
    return followingBusinesses;
  }

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: tertiaryThemeColor(),
        elevation: 0,
        actions: [
          PopupMenuButton<MenuItem>(
            color: tertiaryThemeColor(),
            icon: Icon(
              Icons.more_vert,
              color: primaryThemeColor(),
            ),
            onSelected: (item) async {
              onSelected(context, item);
            },
            itemBuilder: (context) => [
              ...MenuItems.settingItems.map(buildSettingItem).toList(),
            ],
          ),
        ],
      ),
      backgroundColor: tertiaryThemeColor(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Container(
          child: Column(
            children: [
              Center(
                child: FutureBuilder(
                    future: getUserInfo(),
                    builder: (context, AsyncSnapshot snapshot) {
                      return Stack(
                        children: [
                          if (BusinessData.businessApi.myInfo['ImageUrl']
                              .toString()
                              .isNotEmpty)
                            ClipOval(
                              child: Material(
                                color: Colors.transparent,
                                child: Container(
                                  width: swidth * 0.3,
                                  height: swidth * 0.3,
                                  child: FadeInImage(
                                    image: NetworkImage(
                                        '${BusinessData.businessApi.myInfo['ImageUrl']} ',
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
                          if (BusinessData.businessApi.myInfo['ImageUrl']
                              .toString()
                              .isEmpty)
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
                      );
                    }),
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
                    BusinessData.businessApi.myInfo['Username'],
                    style: TextStyle(color: primaryTextColor(), fontSize: 24),
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
                    FutureBuilder(
                      future: getUserInfo(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: SpinKitThreeBounce(
                            color: primaryThemeColor(),
                            size: 32,
                          ));
                        } else {
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'First Name',
                                              style: TextStyle(
                                                  color: primaryThemeColor(),
                                                  fontSize: 18),
                                            ),
                                            SizedBox(
                                              height: sheight * 0.01,
                                            ),
                                            Text(
                                              BusinessData.businessApi
                                                  .myInfo['FirstName'],
                                              style: TextStyle(
                                                  color: primaryTextColor()),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Last Name',
                                              style: TextStyle(
                                                  color: primaryThemeColor(),
                                                  fontSize: 18),
                                            ),
                                            SizedBox(
                                              height: sheight * 0.01,
                                            ),
                                            Text(
                                              BusinessData.businessApi
                                                  .myInfo['LastName'],
                                              style: TextStyle(
                                                  color: primaryTextColor()),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Phone Number',
                                              style: TextStyle(
                                                  color: primaryThemeColor(),
                                                  fontSize: 18),
                                            ),
                                            SizedBox(
                                              height: sheight * 0.01,
                                            ),
                                            Text(
                                              BusinessData.businessApi
                                                  .myInfo['PhoneNumber'],
                                              style: TextStyle(
                                                  color: primaryTextColor()),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Email',
                                              style: TextStyle(
                                                  color: primaryThemeColor(),
                                                  fontSize: 18),
                                            ),
                                            SizedBox(
                                              height: sheight * 0.01,
                                            ),
                                            Text(
                                              BusinessData
                                                  .businessApi.myInfo['Email'],
                                              style: TextStyle(
                                                  color: primaryTextColor()),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (BusinessData.businessApi.myInfo['Bio'] !=
                                      '')
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Bio',
                                                style: TextStyle(
                                                    color: primaryThemeColor(),
                                                    fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: sheight * 0.01,
                                              ),
                                              SizedBox(
                                                width: swidth * 0.64,
                                                child: Text(
                                                  BusinessData.businessApi
                                                      .myInfo['Bio'],
                                                  style: TextStyle(
                                                      color:
                                                          primaryTextColor()),
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
                      },
                    ),
                    Container(
                      height: sheight * 0.472,
                      child: FutureBuilder(
                        future: getFollowingBusinesses(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            // return SpinKitThreeBounce(
                            //   color: primaryThemeColor(),
                            //   size: 32,
                            return Column(
                              children: [
                                BusinessShimmerCard(sheight, swidth),
                                SizedBox(
                                  height: sheight * 0.02,
                                ),
                                BusinessShimmerCard(sheight, swidth),
                                SizedBox(
                                  height: sheight * 0.02,
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                if (followingBusinesses.isEmpty)
                                  Center(
                                    child: Text(
                                      'You dont follow any businesses',
                                      style: TextStyle(
                                          color: primaryTextColor(),
                                          fontSize: 18),
                                    ),
                                  ),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      child: Card(
                                        margin: EdgeInsets.only(bottom: 16),
                                        color: tertiaryThemeColor(),
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: sheight * 0.15,
                                              width: swidth * 0.3,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: FittedBox(
                                                child: FadeInImage(
                                                  image: NetworkImage(
                                                      '${followingBusinesses[index]['ImageUrl']} ',
                                                      scale: sheight),
                                                  placeholder: AssetImage(
                                                      "assets/images/placeholder.png"),
                                                  imageErrorBuilder: (context,
                                                      error, stackTrace) {
                                                    return Image.asset(
                                                        'assets/images/error.png',
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
                                                  followingBusinesses[index]
                                                      ['BusinessName'],
                                                  style: TextStyle(
                                                      color: primaryTextColor(),
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                                SizedBox(
                                                  height: sheight * 0.012,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: swidth * 0.2,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color:
                                                                primaryThemeColor(),
                                                            size: swidth * 0.05,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                swidth * 0.03,
                                                          ),
                                                          Text(
                                                            followingBusinesses[
                                                                        index]
                                                                    ['Rating']
                                                                .toStringAsFixed(
                                                                    1),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    primaryTextColor()),
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
                                                            color:
                                                                primaryThemeColor(),
                                                            size: swidth * 0.05,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                swidth * 0.03,
                                                          ),
                                                          Text(
                                                            '${followingBusinesses[index]['Distance'].toString()} KM',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    primaryTextColor()),
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
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: swidth * 0.2,
                                                      child: Text(
                                                        "${followingBusinesses[index]['AveragePrice']} ETB"
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                primaryTextColor()),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: swidth * 0.18,
                                                    ),
                                                    Container(
                                                      child:
                                                          followingBusinesses[
                                                                      index]
                                                                  ['isOpen']
                                                              ? Text(
                                                                  "Open",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .green),
                                                                )
                                                              : Text(
                                                                  "Closed",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .red),
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
                                            .updateBusinessClicks(
                                                followingBusinesses[index]
                                                    ['Bid']);
                                        BusinessManagement()
                                            .updateCategoryClicks(
                                                followingBusinesses[index]
                                                    ['Category']);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BusinessPage(
                                                        Bid:
                                                            followingBusinesses[
                                                                    index]
                                                                ['Bid'])));
                                      },
                                    );
                                  },
                                  itemCount: followingBusinesses.length,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                    Container(
                      child: Text('third'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: ConvexAppBar.badge(const <int, dynamic>{3: '99+'},
          style: _tabStyle,
          color: primaryTextColor(),
          backgroundColor: tertiaryThemeColor(),
          items: <TabItem>[
            for (final entry in _kPages.entries)
              TabItem(icon: entry.value, title: entry.key),
          ],
          initialActiveIndex: 2, onTap: (int i) {
        switch (i) {
          case 0:
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
            break;
          case 1:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => WriteReview()));
            break;
        }
      }),
    );
  }

  void onSelected(
    BuildContext context,
    MenuItem item,
  ) async {
    switch (item) {
      case MenuItems.itemEditProfile:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditAccount()));
        break;
      case MenuItems.itemFaq:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Faq()));
        break;
      case MenuItems.itemSupport:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Support()));
        break;
      case MenuItems.itemLogout:
        logOutDialogue(context);
        break;
      case MenuItems.itemSetting:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Settings()));
        break;
    }
  }
}

void Logout(BuildContext context) async {
  if (FirebaseAuth.instance.currentUser != null) {
    var email = await FirebaseAuth.instance.currentUser!.email;
    var methods =
        await FirebaseAuth.instance.fetchSignInMethodsForEmail(email!);
    if (methods.contains('google.com')) {
      final provider =
          Provider.of<GoogleSignInProvider>(context, listen: false);
      provider.googlelogout();
    }

    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LandingPage()));
  } else {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LandingPage()));
  }
}

void logOutDialogue(BuildContext context) {
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
                  'LogOut?',
                  style: TextStyle(fontSize: 24, color: primaryTextColor()),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Do you really want to logOut?',
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
                          child: Text('back')),
                      SizedBox(
                        width: swidth * 0.167,
                      ),
                      TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(
                                  primaryThemeColor())),
                          onPressed: () {
                            Logout(context);
                          },
                          child: Text('LogOut'))
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

PopupMenuItem<MenuItem> buildSettingItem(MenuItem item) =>
    PopupMenuItem<MenuItem>(
      value: item,
      child: Row(
        children: [
          Icon(
            item.icon,
            color: primaryThemeColor(),
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
