import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/screens/home/user_profile_page.dart';
import 'package:project_bind/shared/reusable_widget.dart';
import 'package:project_bind/shared/user.dart';
import 'package:project_bind/screens/business_api.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:project_bind/utils/utils.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({Key? key}) : super(key: key);

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController FirstNameController = TextEditingController();
  TextEditingController LastNameController = TextEditingController();
  TextEditingController PhoneNumberController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController BioController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  File? file;
  String path = '';
  String imageName = '';
  UploadTask? uploadTask;
  String ImageUrl = '';
  bool newUpload = false;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  Future getUserInfo() async {
    await BusinessData.businessApi.getmyInfo();
    setUserInfo();
  }

  Future setUserInfo() async {
    userNameController.text =
        BusinessData.businessApi.myInfo['Username'].toString();
    FirstNameController.text =
        BusinessData.businessApi.myInfo['FirstName'].toString();
    LastNameController.text =
        BusinessData.businessApi.myInfo['LastName'].toString();
    PhoneNumberController.text =
        BusinessData.businessApi.myInfo['PhoneNumber'].toString();
    EmailController.text = BusinessData.businessApi.myInfo['Email'].toString();
    BioController.text = BusinessData.businessApi.myInfo['Bio'].toString();
    ImageUrl = BusinessData.businessApi.myInfo['ImageUrl'].toString();
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
              elevation: 1,
              backgroundColor: tertiaryThemeColor(),
              leading: IconButton(
                  splashColor: Colors.transparent,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: primaryTextColor(),
                  )),
            ),
            body: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, sheight * 0.02, 20, 0),
                child: Column(children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Edit profile',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor()),
                    ),
                  ),
                  SizedBox(
                    height: sheight * 0.02,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        if (file == null &&
                            BusinessData.businessApi.myInfo['ImageUrl']
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
                        if (file == null &&
                            BusinessData.businessApi.myInfo['ImageUrl']
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
                        if (file != null)
                          ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: Ink.image(
                                fit: BoxFit.cover,
                                width: swidth * 0.3,
                                height: swidth * 0.3,
                                image: FileImage(
                                  File(file!.path),
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          height: sheight * 0.06,
                          width: swidth * 0.10,
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: primaryThemeColor(),
                            child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: primaryTextColor(),
                                size: swidth * 0.05,
                              ),
                              onPressed: () {
                                selectFile();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: sheight * 0.05),
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          reusableTextField("username", Icons.person,
                              'username', false, userNameController),
                          SizedBox(height: sheight * 0.02),
                          reusableTextField("First Name", Icons.person, '',
                              false, FirstNameController),
                          SizedBox(height: sheight * 0.02),
                          reusableTextField("Last Name", Icons.person, '',
                              false, LastNameController),
                          SizedBox(height: sheight * 0.02),
                          reusableTextField("Phone Number", Icons.phone,
                              'phone', false, PhoneNumberController),
                          SizedBox(height: sheight * 0.02),
                          reusableTextArea(
                              "Bio", Icons.comment, true, BioController),
                          SizedBox(height: sheight * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              reusableUIButton(
                                  context, "Cancel", (swidth * 0.33), 40, () {
                                Navigator.pop(context);
                              }),
                              reusableUIButton(
                                  context, "Save", (swidth / 3), 40, () async {
                                var uid =
                                    FirebaseAuth.instance.currentUser!.uid;
                                final isValid =
                                    formKey.currentState!.validate();
                                if (!isValid) {
                                  return;
                                }
                                loading(context);
                                var ds = await FirebaseFirestore.instance
                                    .collection('user')
                                    .get();
                                for (int i = 0; i < ds.size; i++) {
                                  if (ds.docs[i]['Username']
                                              .toString()
                                              .toLowerCase() ==
                                          userNameController.text
                                              .trim()
                                              .toLowerCase() &&
                                      ds.docs[i]['Uid'] != uid) {
                                    userNameController.clear();
                                    Utils.showSnackBar(
                                        'Username already exists',
                                        messengerKey);
                                    Navigator.of(context).pop();
                                    return;
                                  }
                                }

                                await updateUser(context);
                                await BusinessData.businessApi.getmyInfo();
                                Utils.showSnackBar(
                                    'Profile Updated Succesfully',
                                    messengerKey);
                                Navigator.pop(context);
                                await Future.delayed(
                                    const Duration(seconds: 2), () {});
                                Navigator.pop(context);
                              }),
                            ],
                          ),
                        ],
                      ))
                ]))),
      ),
    );
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
        'user/${userNameController.text.trim()}/profile/${imageName}';
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

  Future updateUser(BuildContext context) async {
    if (newUpload) {
      await uploadImage();
    }

    final json = {
      'Username': userNameController.text.trim(),
      'FirstName': FirstNameController.text.trim(),
      'LastName': LastNameController.text.trim(),
      'PhoneNumber': PhoneNumberController.text.trim(),
      'Bio': BioController.text.trim(),
      'Badge': BusinessData.businessApi.myInfo['Badge'],
      'Email': BusinessData.businessApi.myInfo['Email'],
      'FollowingBusinessBid':
          BusinessData.businessApi.myInfo['FollowingBusinessBid'],
      'ImageUrl': ImageUrl,
      'MostViewedCat': BusinessData.businessApi.myInfo['MostViewedCat'],
      'OwnedBusinessBid': BusinessData.businessApi.myInfo['OwnedBusinessBid'],
      'Uid': BusinessData.businessApi.myInfo['Uid'],
    };

    UserManagement().updateUserInfo(json);
  }
}
