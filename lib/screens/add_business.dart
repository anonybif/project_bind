import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_bind/reusable_widgets/business.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/screens/business_page.dart';
import 'package:project_bind/screens/home/home.dart';
import 'package:project_bind/screens/location_picker.dart';
import 'package:project_bind/utils/color_utils.dart';

class AddBusiness extends StatefulWidget {
  const AddBusiness({Key? key}) : super(key: key);

  @override
  State<AddBusiness> createState() => _AddBusinessState();
}

class _AddBusinessState extends State<AddBusiness> {
  final businessNameController = TextEditingController();
  final businessDiscController = TextEditingController();
  List<TextEditingController> searchKeyController =
      List.generate(4, (i) => TextEditingController());
  final formKey = GlobalKey<FormState>();

  TimeOfDay timeOpens = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay timeClosed = const TimeOfDay(hour: 24, minute: 0);

  bool isOwner = false;

  String dropdownvalue = 'Restaurant';

  var items = [
    'Restaurant',
    'Bar',
    'Hotel',
    'Gas Station',
    'Shopping',
    'Pharmacy',
    'Club',
    'Delivery',
    'Beauty & Spas',
    'Bakery',
    'Internet Cafe',
    'Garage',
    'Takeout',
    'Security',
    'Real Estate',
    'Car Rental',
    'Education',
    'Hospital',
    'Clinic',
    'Motel',
    'Gym'
  ];
  String location = '';
  String address = '';
  String locationError = '';

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[600],
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
      body: Container(
          width: swidth,
          height: sheight,
          decoration: BoxDecoration(color: hexStringToColor("e8e8e8")),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  reusableTextField("Business Name", Icons.business_center, '',
                      false, businessNameController),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextArea(
                      "Description", Icons.message, businessDiscController),
                  const SizedBox(
                    height: 10,
                  ),
                  reusableIconButton(
                      context, "Add location", Icons.location_on, (swidth / 2),
                      () {
                    getLocation();
                  }),
                  Text(location),
                  Text(
                    locationError,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.black38,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DropdownButton(
                        value: dropdownvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        menuMaxHeight: sheight,
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 32,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: reusableTextField('Keyword', Icons.add, '',
                                  true, searchKeyController[0]),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: reusableTextField('Keyword', Icons.add, '',
                                  true, searchKeyController[1]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 32,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: reusableTextField('Keyword', Icons.add, '',
                                  true, searchKeyController[2]),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: reusableTextField('Keyword', Icons.add, '',
                                  true, searchKeyController[3]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.black38,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Working hours",
                    style: TextStyle(fontSize: 18),
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
                                return Colors.deepOrange[300];
                              }
                              return Colors.deepOrange;
                            }),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
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
                        child: const Text('Opens'),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        timeOpens.format(context),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.deepOrange[300];
                              }
                              return Colors.deepOrange;
                            }),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
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
                        child: const Text('Closes'),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        timeClosed.format(context),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.black38,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  reusableUIButton(context, "List", (swidth / 3), () async {
                    final isValid = formKey.currentState!.validate();
                    if (!isValid) {
                      return;
                    } else if (location == '') {
                      setState(() {
                        locationError = 'Location must be added';
                      });
                      return;
                    }
                    await createbusiness();

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  }),
                ],
              ),
            ),
          ))),
    );
  }

  Future getLocation() async {
    final loc = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Locationpicker(
                prevlocation: location,
              )),
    );
    setState(() {
      location = loc;
      locationError = '';
    });
  }

  Future createbusiness() async {
    final json = {
      'BusinessName': businessNameController.text,
      'Description': businessDiscController.text,
      'Location': location,
      'Category': dropdownvalue,
      'Keyword': FieldValue.arrayUnion([
        searchKeyController[0].text.trim(),
        searchKeyController[1].text.trim(),
        searchKeyController[2].text.trim(),
        searchKeyController[3].text.trim()
      ]),
      'Claimed': 'false',
      'Bid': '',
      'Email': '',
      'PhoneNumber': '',
      'OpeningTime': timeOpens.format(context),
      'ClosingTime': timeClosed.format(context),
      'Uid': '',
      'ReviewNumber': '0',
      'Stars': '0',
      'FollowNumber': '0'
    };

    BusinessManagement().storeNewBusiness(json, context);
  }
}
