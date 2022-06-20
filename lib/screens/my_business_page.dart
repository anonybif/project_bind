import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_bind/shared/business.dart';
import 'package:project_bind/shared/reusable_widget.dart';
import 'package:project_bind/screens/business_api.dart';
import 'package:project_bind/screens/manage_business.dart';
import 'package:project_bind/utils/color_utils.dart';

class MyBusiness extends StatefulWidget {
  const MyBusiness({Key? key}) : super(key: key);

  @override
  State<MyBusiness> createState() => _MyBusinessState();
}

class _MyBusinessState extends State<MyBusiness> {
  bool loading = true;

  @override
  void initState() {
    getBusinessInfo();
    super.initState();
  }

  getBusinessInfo() async {
    await BusinessData.businessApi.getMyBusiness();

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: tertiaryThemeColor(),
      appBar: AppBar(
        backgroundColor: tertiaryThemeColor(),
        elevation: 10,
        title: Text(
          "My Businesses",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryTextColor()),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
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
                            '${BusinessData.businessApi.myBusinesses[index]['ImageUrl']} ',
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
                        BusinessData.businessApi.myBusinesses[index]
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
                                      .businessApi.myBusinesses[index]['Rating']
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
                                  '${BusinessData.businessApi.myBusinesses[index]['Distance'].toString()} KM',
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
                              "${BusinessData.businessApi.myBusinesses[index]['AveragePrice']} ETB"
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
                            child: BusinessData.businessApi.myBusinesses[index]
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
              BusinessManagement().updateBusinessClicks(
                  BusinessData.businessApi.myBusinesses[index]['Bid']);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ManageBusiness(
                          Bid: BusinessData.businessApi.myBusinesses[index]
                              ['Bid'])));
            },
          );
        },
        itemCount: BusinessData.businessApi.myBusinesses.length,
      ),
    );
  }
}
