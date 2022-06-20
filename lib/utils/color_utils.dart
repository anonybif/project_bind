import 'package:flutter/material.dart';

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

primaryThemeColor() {
  // return Colors.blue;
  return Colors.green;
}

secondaryThemeColor() {
  // return hexStringToColor('1a1919');
  return hexStringToColor('262626');
}

tertiaryThemeColor() {
  return hexStringToColor('2d2e2e');
}

primaryTextColor() {
  return Colors.white;
}

secondaryTextColor() {
  return Colors.white;
}

warningColor() {
  return Colors.red;
}
