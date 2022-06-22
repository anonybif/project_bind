import 'package:flutter/material.dart';
import 'package:project_bind/screens/authenticate/sign_in.dart';
import 'package:project_bind/screens/authenticate/sign_up.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:shimmer/shimmer.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 120,
    height: 120,
    color: primaryThemeColor(),
  );
}

Image iconWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.contain,
    color: primaryTextColor(),
  );
}

TextFormField reusableTextField(String text, IconData icon, String type,
    bool isOptional, TextEditingController controller) {
  bool isPasswordType = false;
  bool isEmail = false;
  bool isUsername = false;
  bool isPhone = false;
  bool isNum = false;
  if (type == 'password') {
    isPasswordType = true;
  } else if (type == 'email') {
    isEmail = true;
  } else if (type == 'username') {
    isUsername = true;
  } else if (type == 'phone') {
    isPhone = true;
  } else if (type == 'number') {
    isNum = true;
  }
  return TextFormField(
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      style: TextStyle(color: primaryTextColor()),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: primaryThemeColor(),
        ),
        labelText: text,
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        fillColor: tertiaryThemeColor(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
              width: 0, style: BorderStyle.none, color: primaryThemeColor()),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: isEmail
          ? ((value) =>
              value != null && value.isEmpty ? 'Enter a valid Email' : null)
          : isPasswordType
              ? ((value) => value != null && value.length < 6
                  ? 'password needs to be atleast 6 characters'
                  : null)
              : isUsername
                  ? ((value) => value != null && value.length < 4
                      ? 'needs to be atleast 4 characters'
                      : null)
                  : isPhone
                      ? ((value) => value != null && value.length < 10
                          ? 'Enter a valid Phone Number'
                          : null)
                      : isOptional
                          ? ((value) => null)
                          : (value) => value != null && value.isEmpty
                              ? 'Field can\'t be empty'
                              : null,
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : isEmail
              ? TextInputType.emailAddress
              : isPhone
                  ? TextInputType.number
                  : isNum
                      ? TextInputType.number
                      : null);
}

TextFormField reusableTextArea(String text, IconData icon, bool isOptional,
    TextEditingController controller) {
  return TextFormField(
      controller: controller,
      maxLines: null,
      style: TextStyle(color: primaryTextColor()),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: primaryThemeColor(),
        ),
        labelText: text,
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        fillColor: tertiaryThemeColor(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
              width: 0, style: BorderStyle.none, color: primaryThemeColor()),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: isOptional
          ? ((value) => null)
          : (value) =>
              value != null && value.isEmpty ? 'Field can\'t be empty' : null,
      keyboardType: TextInputType.multiline);
}

Container reusableUIButton(BuildContext context, String title, double width,
    double height, Function onTap) {
  return Container(
    width: width,
    height: height,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        child: Text(
          title,
          style: TextStyle(
              color: secondaryTextColor(),
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return primaryThemeColor();
            }
            return primaryThemeColor();
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        )),
  );
}

Container reusableIconButton(BuildContext context, String title, IconData icon,
    double width, Function onTap) {
  return Container(
    width: width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: ElevatedButton.icon(
      onPressed: () {
        onTap();
      },
      icon: Icon(
        icon,
        color: secondaryTextColor(),
      ),
      label: Text(
        title,
        style: TextStyle(
            color: secondaryTextColor(),
            fontWeight: FontWeight.bold,
            fontSize: 18),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return primaryThemeColor();
            }
            return primaryThemeColor();
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
    ),
  );
}

loading(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
              child: SpinKitThreeBounce(
            color: primaryThemeColor(),
            size: 32,
          )));
}

void signUpDialogue(BuildContext context, String content) {
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
                  'LogIn or SignUp',
                  style: TextStyle(fontSize: 24, color: primaryTextColor()),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  content,
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()));
                          },
                          child: const Text('SignUp')),
                      SizedBox(
                        width: swidth * 0.167,
                      ),
                      TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(
                                  primaryThemeColor())),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignIn()));
                          },
                          child: const Text('LogIn'))
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

void NoConnectionDialogue(
  BuildContext context,
  Future<dynamic> reload,
) {
  double sheight = MediaQuery.of(context).size.height;
  double swidth = MediaQuery.of(context).size.width;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(warningColor())),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel')),
                  SizedBox(
                    width: swidth * 0.08,
                  ),
                  TextButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(primaryThemeColor())),
                      onPressed: () {
                        reload;
                        Navigator.of(context).pop();
                      },
                      child: const Text('Retry')),
                  SizedBox(
                    width: swidth * 0.08,
                  ),
                ],
              ),
            )
          ],
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No connection',
                style: TextStyle(fontSize: 24, color: primaryTextColor()),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Connect to the internet and tap Retry ',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: primaryTextColor()),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          backgroundColor: secondaryThemeColor(),
        );
      });
}

Widget BusinessShimmerCard(double sheight, double swidth) {
  return Row(
    children: [
      Shimmer.fromColors(
        baseColor: secondaryThemeColor(),
        highlightColor: tertiaryThemeColor(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: sheight * 0.15,
          width: swidth * 0.3,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: tertiaryThemeColor()),
        ),
      ),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Shimmer.fromColors(
            baseColor: secondaryThemeColor(),
            highlightColor: tertiaryThemeColor(),
            child: Container(
              width: swidth * 0.3,
              height: sheight * 0.02,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: tertiaryThemeColor()),
            )),
        SizedBox(
          height: sheight * 0.025,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Shimmer.fromColors(
                baseColor: secondaryThemeColor(),
                highlightColor: tertiaryThemeColor(),
                child: Container(
                  width: swidth * 0.16,
                  height: sheight * 0.02,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: tertiaryThemeColor()),
                )),
            SizedBox(
              width: swidth * 0.1,
            ),
            Shimmer.fromColors(
                baseColor: secondaryThemeColor(),
                highlightColor: tertiaryThemeColor(),
                child: Container(
                  width: swidth * 0.2,
                  height: sheight * 0.02,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: tertiaryThemeColor()),
                )),
          ],
        ),
        SizedBox(
          height: sheight * 0.012,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Shimmer.fromColors(
                baseColor: secondaryThemeColor(),
                highlightColor: tertiaryThemeColor(),
                child: Container(
                  width: swidth * 0.2,
                  height: sheight * 0.02,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: tertiaryThemeColor()),
                )),
            SizedBox(
              width: swidth * 0.1,
            ),
            Shimmer.fromColors(
                baseColor: secondaryThemeColor(),
                highlightColor: tertiaryThemeColor(),
                child: Container(
                  width: swidth * 0.16,
                  height: sheight * 0.02,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: tertiaryThemeColor()),
                )),
          ],
        ),
      ])
    ],
  );
}

class MenuItem {
  final String text;
  final IconData icon;
  const MenuItem({required this.text, required this.icon});
}

class ReviewMenuItems {
  static const List<MenuItem> reportItems = [itemReport];
  static const List<MenuItem> deleteItems = [itemDelete];

  static const itemReport = MenuItem(text: 'Report', icon: Icons.report);
  static const itemDelete = MenuItem(text: 'Delete', icon: Icons.delete);
}

class UserMenuItems {
  static const List<MenuItem> settingItems = [
    itemEditProfile,
    itemSetting,
    itemFaq,
    itemLogout
  ];
  static const itemEditProfile =
      MenuItem(text: 'Edit Profile', icon: Icons.edit);

  static const itemFaq = MenuItem(text: 'FAQ', icon: Icons.question_answer);

  static const itemLogout = MenuItem(text: 'Logout', icon: Icons.logout);
  static const itemSetting = MenuItem(text: 'Settings', icon: Icons.settings);
}

class BusinessMenuItems {
  static const List<MenuItem> settingItems = [itemEdit, itemDelete];

  static const itemEdit = MenuItem(text: 'Edit', icon: Icons.edit);
  static const itemDelete = MenuItem(text: 'Delete', icon: Icons.delete);
}
