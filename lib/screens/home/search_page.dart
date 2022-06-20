import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_bind/screens/business_api.dart';
import 'package:project_bind/screens/business_page.dart';
import 'package:project_bind/shared/business.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:shimmer/shimmer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  BusinessApi businessApi = BusinessApi();
  List<Map<String, dynamic>> searchedResult = List.empty(growable: true);
  List<Map<String, dynamic>> duplicateItems = List.empty(growable: true);
  List<Map<String, dynamic>> businessNearby = List.empty(growable: true);
  var items = List.empty(growable: true);
  TextEditingController searchFieldController = TextEditingController();
  bool loading = true;
  bool filtering = false;
  bool nearBySelected = false;
  bool openSelected = false;
  List<bool> priceSort = [true, false, false];

  getBusinessList() async {
    await businessApi.getBusinessId();
    await businessApi.getAllBusiness();
    await businessApi.getDistance();
    await businessApi.getTime();
    duplicateItems.addAll(businessApi.businessList);
    items.addAll(duplicateItems);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getBusinessList();

    print(items);
    super.initState();
  }

  getSearchResult(String query) async {
    List<Map<String, dynamic>> dummySearchList = List.empty(growable: true);
    dummySearchList.addAll(duplicateItems);
    print(dummySearchList);
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> dummyListData = List.empty(growable: true);
      for (int i = 0; i < dummySearchList.length; i++) {
        if (dummySearchList[i]['BusinessName']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            dummySearchList[i]['Category']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())) {
          dummyListData.add(dummySearchList[i]);
        }
      }
      for (int i = 0; i < dummySearchList.length; i++) {
        for (int j = 0; j < dummySearchList[i]['Tag'].length; j++) {
          if (dummySearchList[i]['Tag'][j]
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) &&
              !dummyListData.contains(dummySearchList[i])) {
            dummyListData.add(dummySearchList[i]);
          }
        }
      }
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  getNearbyBusiness() async {
    var temp = items;
    temp.sort((m1, m2) {
      return m1['Distance'].compareTo(m2['Distance']);
    });

    setState(() {
      items = List.from(temp);
    });
  }

  getOpenBusiness() async {
    var temp = items;
    List<Map<String, dynamic>> temp2 = List.empty(growable: true);
    temp.forEach((item) {
      if (item['isOpen']) {
        temp2.add(item);
      }
    });
    setState(() {
      items.clear();
      items.addAll(temp2);
    });
  }

  getPriceAscend() {
    var temp = items;
    temp.sort((m1, m2) {
      return double.parse(m1['AveragePrice'].toString())
          .compareTo(double.parse(m2['AveragePrice'].toString()));
    });

    setState(() {
      items = List.from(temp);
    });
  }

  getPricedescend() {
    var temp = items;
    temp.sort((m1, m2) {
      return double.parse(m2['AveragePrice'].toString())
          .compareTo(double.parse(m1['AveragePrice'].toString()));
    });

    setState(() {
      items = List.from(temp);
    });
  }

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: secondaryThemeColor(),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, sheight * 0.05, 0, 0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back),
                  color: primaryTextColor(),
                  highlightColor: secondaryThemeColor(),
                  splashColor: secondaryThemeColor(),
                ),
                Container(
                  height: sheight * 0.05,
                  width: swidth * 0.65,
                  padding: EdgeInsets.only(left: 15),
                  child: TextField(
                    controller: searchFieldController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: primaryTextColor()),
                    autofocus: true,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        isDense: true,
                        hintText: 'Search',
                        hintStyle:
                            TextStyle(fontSize: 14, color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[900],
                        prefixIcon: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
                          child: Icon(
                            Icons.search,
                            size: 18,
                            color: primaryTextColor(),
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(24))),
                    onChanged: (value) {
                      getSearchResult(value);
                      if (openSelected) {
                        getOpenBusiness();
                      } else if (nearBySelected) {
                        getNearbyBusiness();
                      } else if (priceSort[1]) {
                        getPriceAscend();
                      } else if (priceSort[2]) {
                        getPricedescend();
                      }
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      filtering = !filtering;
                    });
                    print(filtering);
                  },
                  icon: Icon(Icons.filter_list),
                  color: primaryTextColor(),
                  highlightColor: secondaryThemeColor(),
                  splashColor: secondaryThemeColor(),
                )
              ],
            ),
            SizedBox(
              height: sheight * 0.01,
            ),
            if (filtering)
              Container(
                width: swidth * 0.9,
                height: sheight * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: tertiaryThemeColor(),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: swidth * 0.06,
                    ),
                    InkWell(
                      splashColor: tertiaryThemeColor(),
                      highlightColor: tertiaryThemeColor(),
                      onTap: () {
                        setState(() {
                          priceSort[0] = true;
                          priceSort[1] = false;
                          priceSort[2] = false;
                          nearBySelected = !nearBySelected;
                          if (openSelected && nearBySelected) {
                            getOpenBusiness();
                            getNearbyBusiness();
                          } else if (nearBySelected)
                            getNearbyBusiness();
                          else {
                            if (openSelected) {
                              getSearchResult(searchFieldController.text);
                              getOpenBusiness();
                            } else
                              getSearchResult(searchFieldController.text);
                          }
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: nearBySelected
                                ? primaryThemeColor()
                                : tertiaryThemeColor(),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: primaryThemeColor())),
                        child: Center(
                          child: Text(
                            'Nearby',
                            style: TextStyle(
                                color: nearBySelected
                                    ? tertiaryThemeColor()
                                    : primaryThemeColor()),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: tertiaryThemeColor(),
                      highlightColor: tertiaryThemeColor(),
                      onTap: () {
                        setState(() {
                          openSelected = !openSelected;

                          if (openSelected && nearBySelected) {
                            getOpenBusiness();
                            getNearbyBusiness();
                          } else if (openSelected)
                            getOpenBusiness();
                          else {
                            if (nearBySelected) {
                              getSearchResult(searchFieldController.text);
                              getNearbyBusiness();
                            } else
                              getSearchResult(searchFieldController.text);
                          }
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: openSelected
                                ? primaryThemeColor()
                                : tertiaryThemeColor(),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: primaryThemeColor())),
                        child: Center(
                          child: Text(
                            'Open',
                            style: TextStyle(
                                color: openSelected
                                    ? tertiaryThemeColor()
                                    : primaryThemeColor()),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: tertiaryThemeColor(),
                      highlightColor: tertiaryThemeColor(),
                      onTap: () {
                        setState(() {
                          if (priceSort[0]) {
                            nearBySelected = false;
                            priceSort[1] = true;
                            priceSort[0] = false;
                            getPriceAscend();
                          } else if (priceSort[1]) {
                            nearBySelected = false;
                            priceSort[2] = true;
                            priceSort[1] = false;
                            getPricedescend();
                          } else {
                            priceSort[0] = true;
                            priceSort[2] = false;
                            if (openSelected) {
                              getSearchResult(searchFieldController.text);
                              getOpenBusiness();
                            } else {
                              getSearchResult(searchFieldController.text);
                            }
                          }
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: priceSort[0]
                                ? tertiaryThemeColor()
                                : primaryThemeColor(),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: primaryThemeColor())),
                        child: Center(
                          child: Row(
                            children: [
                              priceSort[1]
                                  ? Icon(
                                      Icons.arrow_drop_up,
                                      color: tertiaryThemeColor(),
                                    )
                                  : priceSort[2]
                                      ? Icon(
                                          Icons.arrow_drop_down,
                                          color: tertiaryThemeColor(),
                                        )
                                      : Container(),
                              Text('Sort by price',
                                  style: TextStyle(
                                    color: priceSort[0]
                                        ? primaryThemeColor()
                                        : tertiaryThemeColor(),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            loading
                ? loader(sheight, swidth)
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(15, sheight * 0.02, 15, 5),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Card(
                          margin: EdgeInsets.only(bottom: 5),
                          color: tertiaryThemeColor(),
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              Container(
                                height: sheight * 0.072,
                                width: swidth * 0.16,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: FittedBox(
                                  child: FadeInImage(
                                    image: NetworkImage(
                                        '${items[index]['ImageUrl']} ',
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
                                    vertical: sheight * 0.01,
                                    horizontal: swidth * 0.05),
                                child: Column(children: [
                                  Text(
                                    items[index]['BusinessName'],
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
                                              items[index]['Rating'].toString(),
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
                                              '${items[index]['Distance'].toString()} KM',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: primaryTextColor()),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: swidth * 0.2,
                                        child: Row(
                                          children: [
                                            items[index]['isOpen']
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
                                              Icons.attach_money,
                                              color: primaryThemeColor(),
                                              size: swidth * 0.05,
                                            ),
                                            SizedBox(
                                              width: swidth * 0.03,
                                            ),
                                            Text(
                                              '${items[index]['AveragePrice'].toString()}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: primaryTextColor()),
                                            ),
                                          ],
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
                              .updateBusinessClicks(items[index]['Bid']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BusinessPage(Bid: items[index]['Bid'])));
                        },
                      );
                    },
                    itemCount: items.length,
                  ),
          ],
        ),
      ),
    );
  }

  filterUi(BuildContext context) {
    double sheight = MediaQuery.of(context).size.height;
    double swidth = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(top: sheight * 0.07),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: swidth * 0.5,
                height: 100,
                color: secondaryThemeColor(),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryThemeColor(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Container loader(double sheight, double swidth) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(15, sheight * 0.05, 15, 5),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Shimmer.fromColors(
            baseColor: tertiaryThemeColor(),
            highlightColor: secondaryThemeColor(),
            child: Card(
              margin: EdgeInsets.only(bottom: 5),
              color: tertiaryThemeColor(),
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Container(
                    height: sheight * 0.072,
                    width: swidth * 0.16,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: sheight * 0.01, horizontal: swidth * 0.05),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: 10,
      ),
    );
  }
}
