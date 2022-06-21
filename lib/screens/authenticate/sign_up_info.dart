import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/shared/reusable_widget.dart';
import 'package:project_bind/shared/user.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:project_bind/utils/utils.dart';

class SignUpInfo extends StatefulWidget {
  final String Username;

  const SignUpInfo({
    Key? key,
    required this.Username,
  }) : super(key: key);

  @override
  State<SignUpInfo> createState() => _SignUpInfoState();
}

class _SignUpInfoState extends State<SignUpInfo> {
  final userNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final ageController = TextEditingController();
  String radioValue = 'Male';
  final Map MostViewedCat = Map();
  final List<String> FollowingBusinessBid = List.empty();
  final List<String> OwnedBusinessBid = List.empty();
  final List<String> FavoriteBusinessBid = List.empty();

  final formKey = GlobalKey<FormState>();
  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  File? file;
  String path = '';
  String imageName = '';
  UploadTask? uploadTask;
  String ImageUrl = '';
  bool newUpload = false;

  bool userExist = false;

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;

    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      home: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: tertiaryThemeColor(),
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: iconWidget("assets/images/logo1.png"),
            ),
            title: const Text(
              "Complete Sign Up",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          backgroundColor: secondaryThemeColor(),
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, sheight * 0.14, 20, 0),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      if (file == null)
                        ClipOval(
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              width: swidth * 0.3,
                              height: swidth * 0.3,
                              child:
                                  Image.asset("assets/images/placeholder.png"),
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
                SizedBox(height: sheight * 0.03),
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      reusableTextField("First Name", Icons.person, '', false,
                          firstNameController),
                      const SizedBox(
                        height: 16,
                      ),
                      reusableTextField("Last Name", Icons.person, '', false,
                          lastNameController),
                      const SizedBox(
                        height: 16,
                      ),
                      reusableTextField("Phone Number", Icons.phone, 'phone',
                          false, phoneNumberController),
                      const SizedBox(
                        height: 16,
                      ),
                      reusableTextField("Bio (Optional)", Icons.comment, '',
                          true, bioController),
                      const SizedBox(
                        height: 16,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      reusableUIButton(context, "Sign Up", swidth, 50, () {
                        signUp();
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    loading(context);

    createUser();
    Navigator.of(context).pop();
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

  getMostViewedCat() async {
    var ds = await FirebaseFirestore.instance
        .collection('categories')
        .doc('category')
        .get();

    List<dynamic> cat = ds.data()!['cat'];

    for (int i = 0; i < cat.length; i++) {
      MostViewedCat['${cat[i]}'] = 0;
    }
  }

  Future createUser() async {
    await getMostViewedCat();
    await uploadImage();
    var user = FirebaseAuth.instance.currentUser;
    final json = {
      'FirstName': firstNameController.text.trim(),
      'LastName': lastNameController.text.trim(),
      'Username': widget.Username,
      'Email': user!.email,
      'PhoneNumber': phoneNumberController.text.trim(),
      'Bio': bioController.text.trim(),
      'Badge': '',
      'Uid': FirebaseAuth.instance.currentUser!.uid,
      'FollowingBusinessBid': FollowingBusinessBid,
      'OwnedBusinessBid': OwnedBusinessBid,
      'MostViewedCat': MostViewedCat,
      'ImageUrl': ImageUrl,
      'FavoriteBusinessBid': FavoriteBusinessBid
    };

    UserManagement().storeNewUser(json, context);
  }
}
