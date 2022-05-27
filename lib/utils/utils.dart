import 'package:flutter/material.dart';
import 'package:project_bind/utils/color_utils.dart';

class Utils {
  static showSnackBar(
      String? text, GlobalKey<ScaffoldMessengerState> messengerKey) {
    if (text == null) return;

    final snackBar = SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      backgroundColor: primaryThemeColor(),
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
