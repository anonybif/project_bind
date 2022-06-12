import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_bind/main.dart';
import 'package:project_bind/reusable_widgets/business.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/screens/business_page.dart';
import 'package:project_bind/screens/home/home.dart';
import 'package:project_bind/screens/location_picker.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

class AddBusinessInfo extends StatefulWidget {
  final List<String> businessInfo;

  const AddBusinessInfo({Key? key, required this.businessInfo})
      : super(key: key);

  @override
  State<AddBusinessInfo> createState() => _AddBusinessInfoState();
}

class _AddBusinessInfoState extends State<AddBusinessInfo> {
  TimeOfDay timeOpens = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay timeClosed = const TimeOfDay(hour: 24, minute: 0);

  final avgPriceController = TextEditingController();

  String location = '';
  String address = '';
  String locationError = '';

  File? file;
  String path = '';
  String imageName = '';
  UploadTask? uploadTask;
  String ImageUrl = '';

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    final fileName = file != null ? basename(file!.path) : "No file selected";

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryThemeColor(),
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: iconWidget("assets/images/logo1.png"),
          ),
          title: const Text(
            "Add Business",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: secondaryThemeColor(),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(20, sheight * 0.0208, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Average price in ETB',
                style: TextStyle(
                  fontSize: 18,
                  color: primaryTextColor(),
                ),
              ),
              SizedBox(
                height: sheight * 0.0208,
              ),
              reusableTextField("Average Price", FontAwesomeIcons.dollarSign,
                  'number', false, avgPriceController),
              SizedBox(
                height: sheight * 0.0208,
              ),
              Divider(
                thickness: 1,
                color: primaryTextColor(),
              ),
              Text(
                "Working hours",
                style: TextStyle(
                  fontSize: 18,
                  color: primaryTextColor(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return primaryThemeColor();
                          }
                          return primaryThemeColor();
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)))),
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                          context: context, initialTime: timeOpens);
                      if (newTime == null) return;
                      setState(() {
                        timeOpens = newTime;
                      });
                    },
                    child: Text(
                      'Opens',
                      style: TextStyle(
                        color: primaryTextColor(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    timeOpens.format(context),
                    style: TextStyle(fontSize: 16, color: primaryTextColor()),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return primaryThemeColor();
                          }
                          return primaryThemeColor();
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)))),
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                          context: context, initialTime: timeClosed);
                      if (newTime == null) return;
                      setState(() {
                        timeClosed = newTime;
                      });
                    },
                    child: Text(
                      'Closes',
                      style: TextStyle(
                        color: primaryTextColor(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    timeClosed.format(context),
                    style: TextStyle(fontSize: 16, color: primaryTextColor()),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 1,
                color: primaryTextColor(),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Location",
                style: TextStyle(
                  fontSize: 18,
                  color: primaryTextColor(),
                ),
              ),
              reusableIconButton(
                  context, "pick location", Icons.location_on, (sheight * 0.5),
                  () {
                getLocation(context);
              }),
              Text(
                location,
                style: TextStyle(color: primaryTextColor()),
              ),
              Text(
                locationError,
                style: const TextStyle(color: Colors.red),
              ),
              Divider(
                thickness: 1,
                color: primaryTextColor(),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('Upload image',
                  style: TextStyle(
                    fontSize: 18,
                    color: primaryTextColor(),
                  )),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  reusableIconButton(
                      context, "Select", Icons.attach_file, (sheight * 0.33),
                      () {
                    selectFile();
                  }),
                ],
              ),
              Text(
                fileName,
                style: TextStyle(
                  color: primaryTextColor(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              buildProgress(),
              Divider(
                thickness: 1,
                color: primaryTextColor(),
              ),
              const SizedBox(
                height: 10,
              ),
              reusableUIButton(context, "Add", (sheight * 0.33), () async {
                if (location == '') {
                  setState(() {
                    locationError = 'Location must be added';
                  });
                  return;
                }
                await createbusiness(context);

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              }),
            ],
          ),
        )),
      ),
    );
  }

  Widget buildProgress() {
    return StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap!.bytesTransferred / snap.totalBytes;

            return SizedBox(
              height: 20,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: primaryThemeColor(),
                  ),
                  Center(
                    child: Text(
                      '${(100 * progress).roundToDouble()}%',
                      style:
                          TextStyle(fontSize: 20, color: secondaryTextColor()),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Future getLocation(BuildContext context) async {
    final loc = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Locationpicker(
                prevlocation: location,
              )),
    );
    setState(() {
      if (loc != null) {
        location = loc;
        locationError = '';
      } else {
        location = '';
        locationError = 'Location must be added';
      }
    });
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
    });
  }

  Future uploadImage() async {
    final cloudPath = 'business/${widget.businessInfo[0]}/banner/${imageName}';
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

  Future createbusiness(BuildContext context) async {
    await uploadImage();
    final json = {
      'BusinessName': widget.businessInfo[0],
      'Description': widget.businessInfo[1],
      'AveragePrice': avgPriceController.text.trim(),
      'ImageUrl': ImageUrl,
      'Location': location,
      'Category': widget.businessInfo[2],
      'Tag': FieldValue.arrayUnion([
        widget.businessInfo[3],
        widget.businessInfo[4],
        widget.businessInfo[5],
        widget.businessInfo[6],
      ]),
      'Claimed': false,
      'Bid': '',
      'Email': '',
      'PhoneNumber': '',
      'OpeningTime': timeOpens.format(context),
      'ClosingTime': timeClosed.format(context),
      'Uid': '',
      'Reviews': 0,
      'Rating': 0,
      'Follows': 0,
      'BindScore': 0,
      'Clicks': 0
    };

    BusinessManagement().storeNewBusiness(json, context);
  }
}
