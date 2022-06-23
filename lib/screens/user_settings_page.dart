import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_bind/screens/landing_page.dart';
import 'package:project_bind/shared/reusable_widget.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:project_bind/utils/utils.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final messengerKey = GlobalKey<ScaffoldMessengerState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  bool passVisible = false;
  bool currentPasVisible = false;
  bool newPasVisible = false;
  bool cNewPasVisible = false;

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      home: Scaffold(
        backgroundColor: secondaryThemeColor(),
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
          child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Settings',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor()),
                    ),
                  ),
                  SizedBox(
                    height: sheight * 0.05,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: primaryThemeColor(),
                      ),
                      SizedBox(
                        width: swidth * 0.03,
                      ),
                      Text(
                        'Account',
                        style:
                            TextStyle(color: primaryTextColor(), fontSize: 18),
                      )
                    ],
                  ),
                  Divider(
                    color: primaryTextColor(),
                    height: 15,
                    thickness: 1.5,
                  ),
                  SizedBox(
                    height: sheight * 0.03,
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                          color: tertiaryThemeColor(),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Change Password',
                            style: TextStyle(
                                color: primaryTextColor(), fontSize: 18),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: primaryThemeColor(),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      currentPasVisible = false;
                      newPasVisible = false;
                      cNewPasVisible = false;
                      currentPasswordController.clear();
                      newPasswordController.clear();
                      confirmNewPasswordController.clear();
                      changePasswordDialogue(context);
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                          color: tertiaryThemeColor(),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delete Account',
                            style: TextStyle(
                                color: primaryTextColor(), fontSize: 18),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: primaryThemeColor(),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      passVisible = false;
                      PasswordController.clear();
                      deleteAccountDialogue(context);
                    },
                  ),
                  SizedBox(
                    height: sheight * 0.03,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.settings_applications,
                        color: primaryThemeColor(),
                      ),
                      SizedBox(
                        width: swidth * 0.03,
                      ),
                      Text(
                        'Preferences',
                        style:
                            TextStyle(color: primaryTextColor(), fontSize: 18),
                      )
                    ],
                  ),
                  Divider(
                    color: primaryTextColor(),
                    height: 15,
                    thickness: 1.5,
                  ),
                  SizedBox(
                    height: sheight * 0.03,
                  ),
                  // buildAccountOption('Language'),
                  //   buildAccountOption('Dark mode'),
                  SizedBox(
                    height: sheight * 0.16,
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void changePasswordDialogue(BuildContext context) {
    double sheight = MediaQuery.of(context).size.height;
    double swidth = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              backgroundColor: tertiaryThemeColor(),
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Change Password',
                          style: TextStyle(
                              fontSize: 18, color: primaryTextColor()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 65,
                          child: TextFormField(
                              controller: currentPasswordController,
                              obscureText: !currentPasVisible,
                              enableSuggestions: false,
                              autocorrect: false,
                              style: TextStyle(color: primaryTextColor()),
                              decoration: InputDecoration(
                                suffix: IconButton(
                                  icon: Icon(
                                    currentPasVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: primaryThemeColor(),
                                  ),
                                  splashColor: Colors.transparent,
                                  onPressed: () {
                                    setState(() {
                                      currentPasVisible = !currentPasVisible;
                                    });
                                  },
                                ),
                                labelText: 'Current Password',
                                labelStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.9)),
                                filled: true,
                                fillColor: tertiaryThemeColor(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                      color: primaryThemeColor()),
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: ((value) => value != null &&
                                      value.length < 6
                                  ? 'password needs to be atleast 6 characters'
                                  : null),
                              keyboardType: TextInputType.visiblePassword),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 65,
                          child: TextFormField(
                              controller: newPasswordController,
                              obscureText: !newPasVisible,
                              enableSuggestions: false,
                              autocorrect: false,
                              style: TextStyle(color: primaryTextColor()),
                              decoration: InputDecoration(
                                suffix: IconButton(
                                  icon: Icon(
                                    newPasVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: primaryThemeColor(),
                                  ),
                                  splashColor: Colors.transparent,
                                  onPressed: () {
                                    setState(() {
                                      newPasVisible = !newPasVisible;
                                    });
                                  },
                                ),
                                labelText: 'New Password',
                                labelStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.9)),
                                filled: true,
                                fillColor: tertiaryThemeColor(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                      color: primaryThemeColor()),
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: ((value) => value != null &&
                                      value.length < 6
                                  ? 'password needs to be atleast 6 characters'
                                  : null),
                              keyboardType: TextInputType.visiblePassword),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 65,
                          child: TextFormField(
                              controller: confirmNewPasswordController,
                              obscureText: !cNewPasVisible,
                              enableSuggestions: false,
                              autocorrect: false,
                              style: TextStyle(color: primaryTextColor()),
                              decoration: InputDecoration(
                                suffix: IconButton(
                                  icon: Icon(
                                    cNewPasVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: primaryThemeColor(),
                                  ),
                                  splashColor: Colors.transparent,
                                  onPressed: () {
                                    setState(() {
                                      cNewPasVisible = !cNewPasVisible;
                                    });
                                  },
                                ),
                                labelText: 'Confirm New Password',
                                labelStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.9)),
                                filled: true,
                                fillColor: tertiaryThemeColor(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                      color: primaryThemeColor()),
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: ((value) =>
                                  value != newPasswordController.text
                                      ? 'password doesnt match'
                                      : null),
                              keyboardType: TextInputType.visiblePassword),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              primaryThemeColor())),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel')),
                              SizedBox(
                                width: swidth * 0.167,
                              ),
                              TextButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              primaryThemeColor())),
                                  onPressed: () async {
                                    final isValid =
                                        formKey.currentState!.validate();
                                    if (!isValid) {
                                      return;
                                    }
                                    loading(context);
                                    final user =
                                        await FirebaseAuth.instance.currentUser;
                                    final cred = EmailAuthProvider.credential(
                                        email: user!.email!,
                                        password:
                                            currentPasswordController.text);

                                    user
                                        .reauthenticateWithCredential(cred)
                                        .then((value) {
                                      user
                                          .updatePassword(
                                              confirmNewPasswordController.text)
                                          .then((_) {
                                        Navigator.pop(context);
                                        changePasswordSuccess();
                                      }).catchError((error) {
                                        Navigator.pop(context);
                                        changePasswordError(error);
                                      });
                                    }).catchError((err) {
                                      Navigator.pop(context);
                                      changePasswordError(err);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text('Save'))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  void deleteAccountDialogue(BuildContext context) {
    double sheight = MediaQuery.of(context).size.height;
    double swidth = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              backgroundColor: tertiaryThemeColor(),
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Delete Account?',
                          style: TextStyle(
                              fontSize: 24, color: primaryTextColor()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Do you really want to delete your account?',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: primaryTextColor()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 65,
                          child: TextFormField(
                              controller: PasswordController,
                              obscureText: !passVisible,
                              enableSuggestions: false,
                              autocorrect: false,
                              style: TextStyle(color: primaryTextColor()),
                              decoration: InputDecoration(
                                suffix: IconButton(
                                  icon: Icon(
                                    passVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: primaryThemeColor(),
                                  ),
                                  splashColor: Colors.transparent,
                                  onPressed: () {
                                    setState(() {
                                      passVisible = !passVisible;
                                    });
                                  },
                                ),
                                labelText: 'Current Password',
                                labelStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.9)),
                                filled: true,
                                fillColor: tertiaryThemeColor(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                      color: primaryThemeColor()),
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: ((value) => value != null &&
                                      value.length < 6
                                  ? 'password needs to be atleast 6 characters'
                                  : null),
                              keyboardType: TextInputType.visiblePassword),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              primaryThemeColor())),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel')),
                              SizedBox(
                                width: swidth * 0.167,
                              ),
                              TextButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              primaryThemeColor())),
                                  onPressed: () async {
                                    final isValid =
                                        formKey.currentState!.validate();
                                    if (!isValid) {
                                      return;
                                    }
                                    loading(context);
                                    final user =
                                        await FirebaseAuth.instance.currentUser;
                                    var ds = FirebaseFirestore.instance
                                        .collection('user')
                                        .doc(user!.uid);
                                    final cred = EmailAuthProvider.credential(
                                        email: user.email!,
                                        password: PasswordController.text);

                                    user
                                        .reauthenticateWithCredential(cred)
                                        .then((value) {
                                      ds.delete();
                                      user.delete().then((_) {
                                        Navigator.pop(context);
                                        accountDeletedSuccess();
                                      }).catchError((error) {
                                        Navigator.pop(context);
                                        accountDeletedError(error);
                                      });
                                    }).catchError((err) {
                                      Navigator.pop(context);
                                      accountDeletedError(err);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text('Delete'))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  changePasswordSuccess() async {
    Utils.showSnackBar('Password Changed Succesfully ', messengerKey);
  }

  changePasswordError(dynamic error) async {
    Utils.showSnackBar(error.toString(), messengerKey);
  }

  accountDeletedSuccess() async {
    Utils.showSnackBar('Account deleted Succesfully ', messengerKey);
    await Future.delayed(const Duration(seconds: 2), () {});
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LandingPage()));
  }

  accountDeletedError(dynamic error) async {
    Utils.showSnackBar(error.toString(), messengerKey);
  }
}
