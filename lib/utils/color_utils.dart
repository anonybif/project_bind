import 'package:flutter/material.dart';

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

primaryThemeColor() {
  return Colors.blue;
}

secondaryThemeColor() {
  return Colors.black;
}

tertiaryThemeColor() {
  return hexStringToColor('1a1919');
}

primaryTextColor() {
  return Colors.white;
}

secondaryTextColor() {
  return Colors.white;
}
