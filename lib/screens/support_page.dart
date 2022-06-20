import 'package:flutter/material.dart';
import 'package:project_bind/utils/color_utils.dart';

class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryThemeColor(),
      appBar: AppBar(
        backgroundColor: tertiaryThemeColor(),
      ),
    );
  }
}
