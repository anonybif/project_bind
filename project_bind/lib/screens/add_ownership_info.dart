import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/reusable_widgets/business.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:path/path.dart';

class Addownershipinfo extends StatefulWidget {
  const Addownershipinfo({Key? key}) : super(key: key);

  @override
  State<Addownershipinfo> createState() => _AddownershipinfoState();
}

class _AddownershipinfoState extends State<Addownershipinfo> {
  final businessEmailController = TextEditingController();
  final businessPhoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? file;
  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    final fileName = file != null ? basename(file!.path) : "no file selected";
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[600],
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: iconWidget("assets/images/logo1.png"),
        ),
        title: const Text(
          "Add Ownership Information",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
          width: swidth,
          height: sheight,
          decoration: BoxDecoration(color: hexStringToColor("e8e8e8")),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  reusableIconButton(
                      context, "Select File", Icons.attach_file, (swidth / 2),
                      () {
                    selectFile();
                  }),
                  Text(fileName),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableIconButton(
                      context, "Upload File", Icons.attach_file, (swidth / 2),
                      () {
                    uploadFile();
                  }),
                ],
              ),
            ),
          ))),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    final path = result.files.single.path!;

    setState(() {
      file = File(path);
    });
  }

  Future uploadFile() async {}
}
