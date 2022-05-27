import 'package:flutter/material.dart';

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

primaryThemeColor() {
  return Colors.deepOrange;
}

secondaryThemeColor() {
  return hexStringToColor('e8e8e8');
}

// tertiaryThemeColor() {
//   return Colors.blue;
// }

primaryTextColor() {
  return Colors.black;
}

secondaryTextColor() {
  return Colors.white;
}
