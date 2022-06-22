import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:project_bind/screens/add_business.dart';
import 'package:project_bind/screens/business_page.dart';
import 'package:project_bind/shared/Review.dart';
import 'package:project_bind/shared/business.dart';
import 'package:project_bind/shared/reusable_widget.dart';
import 'package:project_bind/screens/business_api.dart';
import 'package:project_bind/screens/home/home.dart';
import 'package:project_bind/screens/home/user_profile_page.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:project_bind/utils/utils.dart';
import 'package:searchfield/searchfield.dart';

class WriteReview extends StatefulWidget {
  const WriteReview({Key? key}) : super(key: key);

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

const _kPages = <String, IconData>{
  'home': Icons.home,
  'Add': Icons.business,
  'write': Icons.add,
  'profile': Icons.account_circle_outlined,
};

class _WriteReviewState extends State<WriteReview> {
  final formKey = GlobalKey<FormState>();
  final messengerKey = GlobalKey<ScaffoldMessengerState>();
  TabStyle _tabStyle = TabStyle.reactCircle;
  TextEditingController reviewController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  String? _selectedItem;
  List<String> businessNames = [];
  double rating = 0;
  String bizSelected = '';
  String unrated = '';

  int reviews = 0;

  File? file1;
  File? file2;
  File? file3;

  List<String> path = ['', '', ''];
  List<String> imageName = ['', '', ''];

  UploadTask? uploadTask1;
  UploadTask? uploadTask2;
  UploadTask? uploadTask3;

  List<String> ImageUrl = ['', '', ''];

  String Bid = '';

  @override
  void initState() {
    reviewController.clear;
    businessNameController.clear;
    getBusiness();
    super.initState();
  }

  getBusiness() async {
    await BusinessData.businessApi.getAllBusiness();
    for (int i = 0; i < BusinessData.businessApi.businessList.length; i++) {
      businessNames
          .add(BusinessData.businessApi.businessList[i]['BusinessName']);
    }
    print(businessNames);
  }

  bool hasProfanity() {
    final filter = ProfanityFilter();
    bool hasProfanity = filter.hasProfanity(reviewController.text);
    return hasProfanity;
  }

  List<String> bannedWords() {
    List<String> moreProfaneWords = ['dicks'];
    final filter = ProfanityFilter.filterAdditionally(moreProfaneWords);
    List<String> wordsFound = filter.getAllProfanity(reviewController.text);
    return wordsFound;
  }

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      home: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: tertiaryThemeColor(),
          appBar: AppBar(
            backgroundColor: tertiaryThemeColor(),
            elevation: 10,
            title: Text(
              "Write a Review",
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
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Select a business',
                          style: TextStyle(
                              fontSize: 16, color: primaryThemeColor()),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        // decoration: BoxDecoration(
                        //   color: Colors.white,
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                        child: SearchField(
                            hint: 'Search',
                            controller: businessNameController,
                            searchInputDecoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: primaryTextColor(),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                      color: primaryThemeColor()),
                                ),
                                // focusedBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(
                                //       width: 2, color: primaryThemeColor()),
                                //   borderRadius: BorderRadius.circular(10),
                                // ),
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: tertiaryThemeColor()),
                            maxSuggestionsInViewPort: 6,
                            itemHeight: 50,
                            suggestionItemDecoration:
                                BoxDecoration(color: tertiaryThemeColor()),
                            suggestionsDecoration: BoxDecoration(
                              color: tertiaryThemeColor(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suggestionStyle: TextStyle(
                                color: primaryTextColor(),
                                backgroundColor: tertiaryThemeColor()),
                            searchStyle: TextStyle(color: primaryTextColor()),
                            onTap: (value) {
                              setState(() {
                                _selectedItem = value!;
                              });

                              print(value);
                            },
                            suggestions: businessNames),
                      ),
                      SizedBox(
                        height: sheight * 0.01,
                      ),
                      Center(
                        child: Text(
                          bizSelected,
                          style: TextStyle(color: warningColor()),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: tertiaryThemeColor(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
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
                              height: sheight * 0.02,
                            ),
                            //here
                            Form(
                              key: formKey,
                              child: Container(
                                // decoration: BoxDecoration(
                                //     border:
                                //         Border.all(color: primaryThemeColor()),
                                //     borderRadius: BorderRadius.circular(12)),
                                child: TextFormField(
                                    controller: reviewController,
                                    maxLines: 5,
                                    style: TextStyle(color: primaryTextColor()),
                                    decoration: InputDecoration(
                                        labelText: 'Write a review',
                                        labelStyle: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(0.9)),
                                        filled: true,
                                        fillColor: tertiaryThemeColor(),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                              color: primaryThemeColor()),
                                        )),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) =>
                                        value != null && value.isEmpty
                                            ? 'write something here'
                                            : null,
                                    keyboardType: TextInputType.multiline),
                              ),
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
                                          border: Border.all(
                                              color: primaryThemeColor()),
                                          borderRadius:
                                              BorderRadius.circular(12)),
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
                                                      color:
                                                          primaryThemeColor()),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
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
                                          border: Border.all(
                                              color: primaryThemeColor()),
                                          borderRadius:
                                              BorderRadius.circular(12)),
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
                                                      color:
                                                          primaryThemeColor()),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
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
                                          border: Border.all(
                                              color: primaryThemeColor()),
                                          borderRadius:
                                              BorderRadius.circular(12)),
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
                                                      color:
                                                          primaryThemeColor()),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
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
                                  loading(context);
                                  if (FirebaseAuth.instance.currentUser !=
                                      null) {
                                    if (businessNameController.text.isEmpty) {
                                      setState(() {
                                        bizSelected = 'select a business';
                                      });
                                      Navigator.pop(context);
                                      return;
                                    }
                                    setState(() {
                                      bizSelected = '';
                                    });

                                    if (rating == 0) {
                                      setState(() {
                                        unrated = 'Give us a rating';
                                      });
                                      Navigator.pop(context);
                                      return;
                                    }
                                    setState(() {
                                      unrated = '';
                                    });
                                    var isValid =
                                        formKey.currentState!.validate();
                                    if (!isValid) {
                                      return;
                                    }
                                    if (hasProfanity()) {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                tertiaryThemeColor(),
                                            title: Center(
                                                child: Text(
                                              "Alert!",
                                              style: TextStyle(
                                                  color: primaryTextColor()),
                                            )),
                                            content: Text(
                                                'The use of profane language is strictly prohibited. Return to your review and make any necessary adjustments',
                                                style: TextStyle(
                                                    color: primaryTextColor())),
                                            actions: <Widget>[
                                              Center(
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all(
                                                              primaryThemeColor())),
                                                  child: Text("OK",
                                                      style: TextStyle(
                                                          color:
                                                              primaryTextColor())),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      return;
                                    }

                                    await createReview(context);
                                    Navigator.pop(context);
                                    Utils.showSnackBar(
                                        'Review Posted', messengerKey);
                                    await Future.delayed(
                                        const Duration(seconds: 2), () {});
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BusinessPage(Bid: Bid)));

                                    setState(() {});
                                  } else {
                                    Navigator.pop(context);
                                    signUpDialogue(context,
                                        'Login or SignUp to post a review');
                                  }
                                })
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: ConvexAppBar.badge(const <int, dynamic>{},
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
                    MaterialPageRoute(builder: (context) => AddBusiness()));
                break;
              case 3:
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => UserProfile()));
                break;
            }
          }),
        ),
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
    print(businessNameController.text);

    for (int i = 0; i < BusinessData.businessApi.businessList.length; i++) {
      if (BusinessData.businessApi.businessList[i]['BusinessName'] ==
          businessNameController.text.trim()) {
        Bid = BusinessData.businessApi.businessList[i]['Bid'];
      }
    }
    print(Bid);

    DocumentReference Uid = FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    print(Uid);

    if (file1 != null) await uploadImage(0);
    if (file2 != null) await uploadImage(1);
    if (file3 != null) await uploadImage(2);
    await getDate();
    List<String> LikedUserUid = List.empty();
    final json = {
      'Content': reviewController.text.trim(),
      'Date': getDate(),
      'Rating': rating,
      'Uid': Uid,
      'Rid': '',
      'Likes': 0,
      'ImageUrl': List.from(ImageUrl),
      'LikedUserUid': LikedUserUid,
      'Reports': 0,
      'Bid': Bid
    };

    ReviewManagement().storeNewReview(json, context, Bid);
    BusinessManagement().updateBusinessRating(Bid, rating, 'add');
    BusinessManagement().updateBusinessReviews(Bid, 'add');
  }
}
