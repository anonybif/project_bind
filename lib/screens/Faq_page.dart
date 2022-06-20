import 'package:flutter/material.dart';
import 'package:project_bind/utils/color_utils.dart';

class Faq extends StatelessWidget {
  const Faq({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryTextColor(),
      appBar: AppBar(
        backgroundColor: tertiaryThemeColor(),
      ),
    );
  }
}
