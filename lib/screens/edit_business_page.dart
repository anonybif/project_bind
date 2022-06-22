import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_bind/shared/business.dart';
import 'package:project_bind/shared/reusable_widget.dart';
import 'package:project_bind/screens/business_api.dart';
import 'package:project_bind/screens/home/home.dart';
import 'package:project_bind/screens/location_picker.dart';
import 'package:project_bind/screens/my_business_page.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:path/path.dart';
import 'package:project_bind/utils/utils.dart';

class EditBusiness extends StatefulWidget {
  final String Bid;
  const EditBusiness({Key? key, required this.Bid}) : super(key: key);

  @override
  State<EditBusiness> createState() => _EditusinessState();
}

class _EditusinessState extends State<EditBusiness> {
  final messengerKey = GlobalKey<ScaffoldMessengerState>();
  final businessNameController = TextEditingController();
  final businessDiscController = TextEditingController();
  final EmailController = TextEditingController();
  final PhoneNumberController = TextEditingController();
  final avgPriceController = TextEditingController();
  String catUpdates = '';

  final formKey = GlobalKey<FormState>();

  TimeOfDay timeOpens = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay timeClosed = const TimeOfDay(hour: 24, minute: 0);

  String location = '';
  String address = '';
  String locationError = '';

  File? file;
  String path = '';
  String imageName = '';
  UploadTask? uploadTask;
  String ImageUrl = '';

  List<String> items = <String>[];

  bool catPick = true;
  String catPickWarning = '';
  List<String> tags = List.filled(4, '');
  bool disabletag = false;
  TextEditingController tagController = TextEditingController();
  List<bool> selected = [];

  bool loading = true;
  bool newUpload = false;

  @override
  void initState() {
    getBusinessInfo();

    super.initState();
  }

  List<bool> catSelected() {
    List<bool> selected = List.filled(items.length, false);
    return selected;
  }

  Future fetchCategory() async {
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

  Future getBusinessInfo() async {
    await BusinessData.businessApi.fetchBusiness(widget.Bid);
    await fetchCategory();
    await setBusinessInfo();

    setState(() {
      loading = false;
    });
  }

  Future setBusinessInfo() async {
    businessNameController.text =
        BusinessData.businessApi.businessInfo['BusinessName'].toString();
    businessDiscController.text =
        BusinessData.businessApi.businessInfo['Description'].toString();
    avgPriceController.text =
        BusinessData.businessApi.businessInfo['AveragePrice'].toString();
    catUpdates = BusinessData.businessApi.businessInfo['Category'].toString();
    for (int i = 0; i < items.length; i++) {
      if (catUpdates == items[i]) {
        selected[i] = true;
      }
    }
    tags = List.from(BusinessData.businessApi.businessInfo['Tag']);

    print(tags);
    for (int i = 0; i < tags.length; i++) {
      if (tags[i] == '') {
        tags.removeAt(i);
      }
    }
    print(tags);

    String OtimeH = BusinessData.businessApi.businessInfo['OpeningTime']
        .toString()
        .split(':')[0];
    String OtimeM = BusinessData.businessApi.businessInfo['OpeningTime']
        .toString()
        .split(':')[1]
        .split(' ')[0];
    timeOpens = TimeOfDay(hour: int.parse(OtimeH), minute: int.parse(OtimeM));
    String CtimeH = BusinessData.businessApi.businessInfo['ClosingTime']
        .toString()
        .split(':')[0];
    String CtimeM = BusinessData.businessApi.businessInfo['ClosingTime']
        .toString()
        .split(':')[1]
        .split(' ')[0];
    timeClosed = TimeOfDay(hour: int.parse(CtimeH), minute: int.parse(CtimeM));
    location = BusinessData.businessApi.businessInfo['Location'];
    PhoneNumberController.text =
        BusinessData.businessApi.businessInfo['PhoneNumber'].toString();
    EmailController.text =
        BusinessData.businessApi.businessInfo['Email'].toString();
    ImageUrl = BusinessData.businessApi.businessInfo['ImageUrl'].toString();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    final fileName = file != null ? basename(file!.path) : "No file selected";
    return Scaffold(
      backgroundColor: secondaryThemeColor(),
      appBar: AppBar(
          backgroundColor: tertiaryThemeColor(),
          elevation: 1,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit Business Profile',
                style: TextStyle(
                  color: primaryTextColor(),
                  fontSize: 21,
                ),
              ),
            ],
          )),
      body: loading
          ? Container()
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: swidth * 0.05, vertical: sheight * 0.02),
                child: Column(
                  children: [
                    SizedBox(
                      height: sheight * 0.02,
                    ),
                    Stack(
                      children: [
                        if (file == null)
                          Container(
                            margin: EdgeInsets.all(8),
                            height: sheight * 0.23,
                            width: swidth,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24)),
                            child: FadeInImage(
                              image: NetworkImage(
                                  '${BusinessData.businessApi.businessInfo['ImageUrl']} ',
                                  scale: sheight),
                              placeholder:
                                  AssetImage("assets/images/placeholder.png"),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/error.png',
                                    fit: BoxFit.cover);
                              },
                              fit: BoxFit.cover,
                            ),
                          ),
                        if (file != null)
                          Container(
                              margin: EdgeInsets.all(8),
                              height: sheight * 0.23,
                              width: swidth,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24)),
                              child: Image.file(
                                File(file!.path),
                              )),
                        Positioned(
                          height: sheight * 0.06,
                          width: swidth * 0.12,
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: primaryThemeColor(),
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: primaryTextColor(),
                              ),
                              onPressed: () {
                                selectFile();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sheight * 0.02,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          reusableTextField(
                              "Business Name",
                              Icons.business_center,
                              '',
                              false,
                              businessNameController),
                          SizedBox(
                            height: sheight * 0.0208,
                          ),
                          reusableTextArea("Description", Icons.message, false,
                              businessDiscController),
                          SizedBox(
                            height: sheight * 0.0208,
                          ),
                          reusableTextField("Phone Number", Icons.phone, '',
                              true, PhoneNumberController),
                          SizedBox(
                            height: sheight * 0.0208,
                          ),
                          reusableTextField(
                              "Email", Icons.mail, '', true, EmailController),
                          SizedBox(
                            height: sheight * 0.0208,
                          ),
                          reusableTextField(
                              "Average Price",
                              FontAwesomeIcons.dollarSign,
                              'number',
                              false,
                              avgPriceController),
                          SizedBox(
                            height: sheight * 0.0208,
                          ),
                          Divider(
                            thickness: 1,
                            color: primaryTextColor(),
                          ),
                          Container(
                              height: sheight * 0.2,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: sheight * 0.04167,
                                      child: Text(
                                        'Categories',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: primaryTextColor(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: sheight * 0.1428,
                                      decoration: BoxDecoration(
                                          color: tertiaryThemeColor(),
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: GridView.builder(
                                        itemCount: items.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          final item = items[index];

                                          return Container(
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  for (int i = 0;
                                                      i < items.length;
                                                      i++) {
                                                    selected[i] = false;
                                                  }
                                                  selected[index] =
                                                      !selected[index];
                                                  setState(() {
                                                    catPick = true;
                                                    catPickWarning = '';
                                                  });
                                                  print('${item} selected');
                                                });
                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                    color: selected[index]
                                                        ? primaryThemeColor()
                                                        : tertiaryThemeColor(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                        color:
                                                            primaryThemeColor())),
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
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: (1 / 2),
                                        ),
                                      ),
                                    ),
                                  ])),
                          catPick
                              ? Container()
                              : Text(
                                  catPickWarning,
                                  style: TextStyle(color: Colors.red),
                                ),
                          Divider(
                            thickness: 1,
                            color: primaryTextColor(),
                          ),
                          Container(
                            height: sheight * 0.278,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: sheight * 0.04166,
                                  child: Text(
                                    'Tags',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: primaryTextColor(),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: sheight * 0.1428,
                                  decoration: BoxDecoration(
                                      color: tertiaryThemeColor(),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: tags.length,
                                    itemBuilder: (context, index) {
                                      final item = tags[index];
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 10),
                                        decoration: BoxDecoration(
                                            color: primaryThemeColor(),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: primaryThemeColor())),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 12),
                                                child: Text(
                                                  item,
                                                  style: TextStyle(
                                                      color:
                                                          secondaryTextColor()),
                                                ),
                                              ),
                                              IconButton(
                                                  color: secondaryTextColor(),
                                                  onPressed: () {
                                                    tags.removeAt(index);
                                                    setState(() {
                                                      disabletag = false;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.cancel,
                                                    size: 15,
                                                  ))
                                            ]),
                                      );
                                    },
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: (3 / 1),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: swidth / 2,
                                      height: swidth / 9,
                                      child: TextField(
                                        enabled: !disabletag,
                                        controller: tagController,
                                        style: TextStyle(
                                            color: primaryTextColor()),
                                        cursorColor: primaryTextColor(),
                                        decoration: InputDecoration(
                                          labelText: 'Add a Tag',
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          filled: true,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          fillColor: tertiaryThemeColor(),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              borderSide: const BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none)),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        color: primaryThemeColor(),
                                        onPressed: () {
                                          setState(() {
                                            if (tags.length < 4 &&
                                                tagController.text.trim() !=
                                                    '') {
                                              tags.add(
                                                  tagController.text.trim());
                                            } else if (tags.length >= 4 &&
                                                tagController.text.trim() !=
                                                    '') {
                                              disabletag = true;
                                            }
                                          });
                                        },
                                        icon: Icon(Icons.add))
                                  ],
                                )
                              ],
                            ),
                          ),
                          disabletag
                              ? Text(
                                  'Maximum of 4 tags allowed',
                                  style: TextStyle(color: Colors.red),
                                )
                              : Text(''),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 1,
                            color: primaryTextColor(),
                          ),
                          Text(
                            "Working hours",
                            style: TextStyle(
                              fontSize: 18,
                              color: primaryTextColor(),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (states
                                          .contains(MaterialState.pressed)) {
                                        return primaryThemeColor();
                                      }
                                      return primaryThemeColor();
                                    }),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)))),
                                onPressed: () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context, initialTime: timeOpens);
                                  if (newTime == null) return;
                                  setState(() {
                                    timeOpens = newTime;
                                  });
                                },
                                child: Text(
                                  'Opens',
                                  style: TextStyle(
                                    color: primaryTextColor(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                timeOpens.format(context),
                                style: TextStyle(
                                    fontSize: 16, color: primaryTextColor()),
                              ),
                              const SizedBox(width: 15),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (states
                                          .contains(MaterialState.pressed)) {
                                        return primaryThemeColor();
                                      }
                                      return primaryThemeColor();
                                    }),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)))),
                                onPressed: () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime: timeClosed);
                                  if (newTime == null) return;
                                  setState(() {
                                    timeClosed = newTime;
                                  });
                                },
                                child: Text(
                                  'Closes',
                                  style: TextStyle(
                                    color: primaryTextColor(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                timeClosed.format(context),
                                style: TextStyle(
                                    fontSize: 16, color: primaryTextColor()),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 1,
                            color: primaryTextColor(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Location",
                            style: TextStyle(
                              fontSize: 18,
                              color: primaryTextColor(),
                            ),
                          ),
                          reusableIconButton(context, "pick location",
                              Icons.location_on, (sheight * 0.5), () {
                            getLocation(context);
                          }),
                          Text(
                            location,
                            style: TextStyle(color: primaryTextColor()),
                          ),
                          Text(
                            locationError,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              reusableUIButton(
                                  context, "Cancel", (swidth * 0.33), 50,
                                  () async {
                                Navigator.pop(context);
                              }),
                              reusableUIButton(
                                  context, "Update", (swidth / 3), 50,
                                  () async {
                                final isValid =
                                    formKey.currentState!.validate();
                                if (!isValid) {
                                  return;
                                }
                                bool catPicked = false;
                                for (int i = 0; i < items.length; i++) {
                                  if (selected[i]) {
                                    catPicked = true;
                                  }
                                }
                                if (!catPicked) {
                                  setState(() {
                                    catPick = false;
                                    catPickWarning = 'Select a category';
                                  });
                                  print('cat not selected');
                                  return;
                                }
                                if (location == '') {
                                  setState(() {
                                    locationError = 'Location must be added';
                                  });
                                  return;
                                }

                                for (int i = 0; i < items.length; i++) {
                                  if (catSelected()[i]) {
                                    catUpdates = items[i];
                                  }
                                }

                                await updateBusiness(context);
                                await BusinessData.businessApi.getAllBusiness();
                                Navigator.pop(context);
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             const MyBusiness()));
                              }),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildProgress() {
    return StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap!.bytesTransferred / snap.totalBytes;

            return SizedBox(
              height: 20,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: primaryThemeColor(),
                  ),
                  Center(
                    child: Text(
                      '${(100 * progress).roundToDouble()}%',
                      style:
                          TextStyle(fontSize: 20, color: secondaryTextColor()),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Future getLocation(BuildContext context) async {
    final loc = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Locationpicker(
                prevlocation: location,
              )),
    );
    setState(() {
      if (loc != null) {
        location = loc;
        locationError = '';
      } else {
        location = '';
        locationError = 'Location must be added';
      }
    });
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result == null) return;
    path = result.files.single.path!;
    imageName = result.files.single.name;

    setState(() {
      file = File(path);
      newUpload = true;
    });
  }

  Future uploadImage() async {
    final cloudPath =
        'business/${businessNameController.text.trim()}/banner/${imageName}';
    final file = File(path);

    final ref = FirebaseStorage.instance.ref().child(cloudPath);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    ImageUrl = await snapshot.ref.getDownloadURL();
    print(ImageUrl);
    setState(() {
      uploadTask = null;
    });
  }

  Future updateBusiness(BuildContext context) async {
    if (newUpload) {
      await uploadImage();
    }
    List<dynamic> tag = List.filled(4, '');
    for (int i = 0; i < tags.length; i++) {
      tag[i] = tags[i];
    }
    for (int i = 0; i < items.length; i++) {
      if (selected[i]) {
        catUpdates = items[i];
      }
    }
    print(tags);
    print(catUpdates);

    final json = {
      'BusinessName': businessNameController.text.trim(),
      'Description': businessDiscController.text.trim(),
      'AveragePrice': avgPriceController.text.trim(),
      'ImageUrl': ImageUrl,
      'Location': location,
      'Category': catUpdates,
      'Tag': FieldValue.arrayUnion([tag[0], tag[1], tag[2], tag[3]]),
      'Email': EmailController.text.trim(),
      'PhoneNumber': PhoneNumberController.text.trim(),
      'OpeningTime': timeOpens.format(context),
      'ClosingTime': timeClosed.format(context),
      'Claimed': BusinessData.businessApi.businessInfo['Claimed'],
      'Bid': BusinessData.businessApi.businessInfo['Bid'],
      'Uid': BusinessData.businessApi.businessInfo['Uid'],
      'Reviews': BusinessData.businessApi.businessInfo['Reviews'],
      'Rating': BusinessData.businessApi.businessInfo['Rating'],
      'Follows': BusinessData.businessApi.businessInfo['Follows'],
      'BindScore': BusinessData.businessApi.businessInfo['BindScore'],
      'Clicks': BusinessData.businessApi.businessInfo['Clicks']
    };

    BusinessManagement().updateBusinessInfo(widget.Bid, json);
  }
}
