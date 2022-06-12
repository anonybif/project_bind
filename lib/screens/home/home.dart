import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project_bind/reusable_widgets/business.dart';
import 'package:project_bind/screens/business_api.dart';
import 'package:project_bind/screens/business_page.dart';
import 'package:project_bind/screens/home/search.dart';
import 'package:project_bind/screens/home/search_page.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/reusable_widgets/navigation_drawer_widget.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:shimmer/shimmer.dart';
//import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

const _kPages = <String, IconData>{
  'home': Icons.home,
  'write': Icons.add,
  'profile': Icons.account_circle_outlined,
};

class _HomeState extends State<Home> {
  TabStyle _tabStyle = TabStyle.reactCircle;

  var body;

  bool loading = true;
  bool connected = false;
  BusinessApi businessApi = BusinessApi();
  List<String> business = [];
  int amount = 0;
  List<bool> selected = [];
  List<String> items = <String>[];
  bool catPick = true;
  String catPickWarning = '';

  @override
  void initState() {
    fetchCategory();
    getBusinessInfo();
    super.initState();
  }

  List<bool> catSelected() {
    List<bool> selected = List.filled(items.length, false);
    return selected;
  }

  fetchCategory() async {
    await FirebaseFirestore.instance
        .collection('categories')
        .get()
        .then((value) {
      setState(() {
        items = List.from(value.docs[0]["cat"]);
        for (int i = 0; i < items.length; i++) {
          selected.add(false);
        }
      });
    }).catchError((e) => null);
    print(items);
  }

  getBusinessInfo() async {
    await checkConnection();
    if (connected) {
      await BusinessData.businessApi.getBusinessId();
      await BusinessData.businessApi.getAllBusiness();
      await BusinessData.businessApi.getDistance();
      await BusinessData.businessApi.getTime();
      await BusinessData.businessApi.fetchNearbyBusiness();
      await BusinessData.businessApi.fetchRecommendBusiness();
      print(BusinessData.businessApi.businessList.length);
      amount = BusinessData.businessApi.businessRecommend.length;

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
      return loader(sheight, swidth);
    } else
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: secondaryThemeColor(),
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: iconWidget("assets/images/logo1.png"),
              ),
              title: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 24,
                      color: primaryTextColor(),
                    ),
                    highlightColor: secondaryThemeColor(),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPage()));
                    },
                  )),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            drawer: NaviagtionDrawerWidget(),
            backgroundColor: secondaryThemeColor(),
            body: SingleChildScrollView(
              physics: ScrollPhysics(),
              padding: EdgeInsets.fromLTRB(15, sheight * 0.05, 15, 5),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Categories',
                      style: TextStyle(color: primaryTextColor(), fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: sheight * 0.02,
                  ),
                  Container(
                    height: sheight * 0.1428,
                    decoration: BoxDecoration(
                        color: tertiaryThemeColor(),
                        borderRadius: BorderRadius.circular(16)),
                    child: GridView.builder(
                      itemCount: items.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return Container(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (!selected[index]) {
                                  for (int i = 0; i < items.length; i++) {
                                    selected[i] = false;
                                  }
                                }
                                selected[index] = !selected[index];

                                print('cat selected');
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: selected[index]
                                      ? primaryThemeColor()
                                      : tertiaryThemeColor(),
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: primaryThemeColor())),
                              child: Center(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                      color: selected[index]
                                          ? tertiaryThemeColor()
                                          : primaryThemeColor()),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: (1 / 2),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sheight * 0.03,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nearby',
                      style: TextStyle(color: primaryTextColor(), fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: sheight * 0.02,
                  ),
                  SizedBox(
                    height: sheight * 0.15,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Card(
                            // margin: EdgeInsets.symmetric(horizontal: 5),
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
                                          '${BusinessData.businessApi.businessNearby[index]['ImageUrl']} ',
                                          scale: sheight),
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
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: sheight * 0.02,
                                      horizontal: swidth * 0.05),
                                  child: Column(children: [
                                    Text(
                                      BusinessData
                                              .businessApi.businessNearby[index]
                                          ['BusinessName'],
                                      style: TextStyle(
                                          color: primaryTextColor(),
                                          fontWeight: FontWeight.w800),
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
                                                color: primaryThemeColor(),
                                                size: swidth * 0.05,
                                              ),
                                              SizedBox(
                                                width: swidth * 0.03,
                                              ),
                                              Text(
                                                BusinessData
                                                    .businessApi
                                                    .businessNearby[index]
                                                        ['Rating']
                                                    .toString(),
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
                                                '${BusinessData.businessApi.businessNearby[index]['Distance'].toString()} KM',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: swidth * 0.2,
                                          child: Text(
                                            "${BusinessData.businessApi.businessNearby[index]['AveragePrice']} ETB"
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
                                          child: BusinessData.businessApi
                                                      .businessNearby[index]
                                                  ['isOpen']
                                              ? Text(
                                                  "Open",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.green),
                                                )
                                              : Text(
                                                  "Closed",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                            BusinessManagement().updateBusinessClicks(
                                BusinessData.businessApi.businessNearby[index]
                                    ['Bid']);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BusinessPage(
                                        Bid: BusinessData.businessApi
                                            .businessNearby[index]['Bid'])));
                          },
                        );
                      },
                      itemCount: BusinessData.businessApi.businessId.length,
                    ),
                  ),
                  SizedBox(
                    height: sheight * 0.03,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recommended',
                      style: TextStyle(color: primaryTextColor(), fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: sheight * 0.03,
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
                                        '${BusinessData.businessApi.businessRecommend[index]['ImageUrl']} ',
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
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: sheight * 0.02,
                                    horizontal: swidth * 0.05),
                                child: Column(children: [
                                  Text(
                                    BusinessData.businessApi
                                            .businessRecommend[index]
                                        ['BusinessName'],
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
                                              BusinessData
                                                  .businessApi
                                                  .businessRecommend[index]
                                                      ['Rating']
                                                  .toString(),
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
                                              '${BusinessData.businessApi.businessRecommend[index]['Distance'].toString()} KM',
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
                                          "${BusinessData.businessApi.businessRecommend[index]['AveragePrice']} ETB"
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
                                        child: BusinessData.businessApi
                                                    .businessRecommend[index]
                                                ['isOpen']
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
                          BusinessManagement().updateBusinessClicks(BusinessData
                              .businessApi.businessRecommend[index]['Bid']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BusinessPage(
                                      Bid: BusinessData.businessApi
                                          .businessRecommend[index]['Bid'])));
                        },
                      );
                    },
                    itemCount: BusinessData.businessApi.businessId.length,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: ConvexAppBar.badge(
              // Optional badge argument: keys are tab indices, values can be
              // String, IconData, Color or Widget.
              /*badge=*/ const <int, dynamic>{3: '99+'},
              style: _tabStyle,
              color: primaryTextColor(),
              //cornerRadius: 20,

              backgroundColor: tertiaryThemeColor(),
              items: <TabItem>[
                for (final entry in _kPages.entries)
                  TabItem(icon: entry.value, title: entry.key),
              ],
              onTap: (int i) => print('click index=$i'),
            ),
          ),
        ),
      );
  }

  Scaffold loader(double sheight, double swidth) {
    return Scaffold(
      backgroundColor: secondaryThemeColor(),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(0, sheight * 0.06, 0, 0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Shimmer.fromColors(
                baseColor: tertiaryThemeColor(),
                highlightColor: secondaryThemeColor(),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: sheight * 0.05,
                  width: swidth,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: tertiaryThemeColor()),
                ),
              ),
              SizedBox(
                height: sheight * 0.05,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Shimmer.fromColors(
                  baseColor: tertiaryThemeColor(),
                  highlightColor: secondaryThemeColor(),
                  child: Container(
                    height: sheight * 0.02,
                    width: swidth * 0.3,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: tertiaryThemeColor()),
                  ),
                ),
              ),
              SizedBox(
                height: sheight * 0.02,
              ),
              Shimmer.fromColors(
                baseColor: tertiaryThemeColor(),
                highlightColor: secondaryThemeColor(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: sheight * 0.06,
                          width: swidth * 0.2,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: tertiaryThemeColor()),
                        ),
                        SizedBox(
                          width: swidth * 0.04,
                        ),
                        Container(
                          height: sheight * 0.06,
                          width: swidth * 0.2,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: tertiaryThemeColor()),
                        ),
                        SizedBox(
                          width: swidth * 0.04,
                        ),
                        Container(
                          height: sheight * 0.06,
                          width: swidth * 0.2,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: tertiaryThemeColor()),
                        ),
                        SizedBox(
                          width: swidth * 0.04,
                        ),
                        Container(
                          height: sheight * 0.06,
                          width: swidth * 0.2,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: tertiaryThemeColor()),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sheight * 0.02,
                    ),
                    Row(
                      children: [
                        Container(
                          height: sheight * 0.06,
                          width: swidth * 0.2,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: tertiaryThemeColor()),
                        ),
                        SizedBox(
                          width: swidth * 0.04,
                        ),
                        Container(
                          height: sheight * 0.06,
                          width: swidth * 0.2,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: tertiaryThemeColor()),
                        ),
                        SizedBox(
                          width: swidth * 0.04,
                        ),
                        Container(
                          height: sheight * 0.06,
                          width: swidth * 0.2,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: tertiaryThemeColor()),
                        ),
                        SizedBox(
                          width: swidth * 0.04,
                        ),
                        Container(
                          height: sheight * 0.06,
                          width: swidth * 0.2,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: tertiaryThemeColor()),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: sheight * 0.04,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Shimmer.fromColors(
                  baseColor: tertiaryThemeColor(),
                  highlightColor: secondaryThemeColor(),
                  child: Container(
                    height: sheight * 0.02,
                    width: swidth * 0.3,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: tertiaryThemeColor()),
                  ),
                ),
              ),
              SizedBox(
                height: sheight * 0.02,
              ),
              Shimmer.fromColors(
                baseColor: tertiaryThemeColor(),
                highlightColor: secondaryThemeColor(),
                child: Card(
                  margin: EdgeInsets.fromLTRB(0, 6, 0, 10),
                  color: tertiaryThemeColor(),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Container(
                        height: swidth * 0.3,
                        width: swidth * 0.3,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      Container(
                        width: swidth * 0.6,
                        padding: EdgeInsets.all(32),
                        child: Column(children: [
                          Container(
                            height: sheight * 0.01,
                          ),
                          SizedBox(
                            height: sheight * 0.025,
                          ),
                          Container(
                            height: sheight * 0.01,
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: sheight * 0.03,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Shimmer.fromColors(
                  baseColor: tertiaryThemeColor(),
                  highlightColor: secondaryThemeColor(),
                  child: Container(
                    height: sheight * 0.02,
                    width: swidth * 0.3,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: tertiaryThemeColor()),
                  ),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Shimmer.fromColors(
                    baseColor: tertiaryThemeColor(),
                    highlightColor: secondaryThemeColor(),
                    child: Card(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      color: tertiaryThemeColor(),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Container(
                            height: swidth * 0.3,
                            width: swidth * 0.3,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          Container(
                            width: swidth * 0.6,
                            padding: EdgeInsets.all(32),
                            child: Column(children: [
                              Container(
                                height: sheight * 0.01,
                              ),
                              SizedBox(
                                height: sheight * 0.025,
                              ),
                              Container(
                                height: sheight * 0.01,
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: 2,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ConvexAppBar.badge(
        const <int, dynamic>{3: '99+'},
        style: _tabStyle,
        color: Colors.blue,
        backgroundColor: tertiaryThemeColor(),
        items: <TabItem>[
          for (final entry in _kPages.entries)
            TabItem(icon: entry.value, title: entry.key),
        ],
        onTap: (int i) => print('click index=$i'),
      ),
    );
  }
}
