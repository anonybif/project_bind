import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:project_bind/shared/Review.dart';
import 'package:project_bind/shared/business.dart';
import 'package:project_bind/shared/reusable_widget.dart';
import 'package:project_bind/screens/business_api.dart';
import 'package:project_bind/screens/home/home.dart';
import 'package:project_bind/screens/user_profile_page.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:searchfield/searchfield.dart';

class WriteReview extends StatefulWidget {
  const WriteReview({Key? key}) : super(key: key);

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

const _kPages = <String, IconData>{
  'home': Icons.home,
  'write': Icons.add,
  'profile': Icons.account_circle_outlined,
};

class _WriteReviewState extends State<WriteReview> {
  final formKey = GlobalKey<FormState>();
  TabStyle _tabStyle = TabStyle.reactCircle;
  TextEditingController reviewController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  String? _selectedItem;
  List<String> businessNames = [];
  double rating = 0;
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

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    return MaterialApp(
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
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SearchField(
                            hint: 'Search',
                            controller: businessNameController,
                            searchInputDecoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: primaryTextColor(),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: primaryThemeColor(),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: primaryThemeColor()),
                                  borderRadius: BorderRadius.circular(10),
                                ),
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
                            Form(
                              key: formKey,
                              child: Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: primaryThemeColor()),
                                    borderRadius: BorderRadius.circular(12)),
                                child: TextFormField(
                                    controller: reviewController,
                                    maxLines: 10,
                                    style: TextStyle(color: primaryTextColor()),
                                    decoration: InputDecoration(
                                      labelText: 'Write a review',
                                      labelStyle: TextStyle(
                                          color: Colors.grey.withOpacity(0.9)),
                                      filled: true,
                                      fillColor: tertiaryThemeColor(),
                                      border: UnderlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) =>
                                        value != null && value.isEmpty
                                            ? 'Field can\'t be empty'
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
                                  if (FirebaseAuth.instance.currentUser !=
                                      null) {
                                    var isValid =
                                        formKey.currentState!.validate();
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

                                      setState(() {});
                                    }
                                  } else {
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
          bottomNavigationBar:
              ConvexAppBar.badge(const <int, dynamic>{3: '99+'},
                  style: _tabStyle,
                  color: primaryTextColor(),
                  backgroundColor: tertiaryThemeColor(),
                  items: <TabItem>[
                    for (final entry in _kPages.entries)
                      TabItem(icon: entry.value, title: entry.key),
                  ],
                  initialActiveIndex: 1, onTap: (int i) {
            switch (i) {
              case 0:
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
                break;

              case 2:
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

    String Bid = '';
    for (int i = 0; i < BusinessData.businessApi.businessList.length; i++) {
      if (BusinessData.businessApi.businessList[i]['BusinessName'] ==
          businessNameController.text.trim()) {
        Bid = BusinessData.businessApi.businessList[i]['Bid'];
      }
    }
    print(Bid);

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

    ReviewManagement().storeNewReview(json, context, Bid);
    BusinessManagement().updateBusinessRating(Bid, rating, 'add');
    BusinessManagement().updateBusinessReviews(Bid, 'add');
  }
}
