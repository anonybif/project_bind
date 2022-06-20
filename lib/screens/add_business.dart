import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_bind/shared/business.dart';
import 'package:project_bind/shared/reusable_widget.dart';
import 'package:project_bind/screens/add_business_info.dart';
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

  final formKey = GlobalKey<FormState>();

  List<String> businessInfo = List.filled(7, '');

  List<String> items = <String>[];

  String location = '';
  String address = '';
  String locationError = '';

  bool catPick = true;
  String catPickWarning = '';
  List<String> tags = [];
  bool disabletag = false;
  TextEditingController tagController = TextEditingController();
  List<bool> selected = [];

  @override
  void initState() {
    fetchCategory();
    super.initState();
  }

  List<bool> catSelected() {
    List<bool> selected = List.filled(items.length, false);
    return selected;
  }

  fetchCategory() async {
    await FirebaseFirestore.instance
        .collection('categories')
        .get()
        .then((value) {
      setState(() {
        items = List.from(value.docs[0]["cat"]);
        for (int i = 0; i < items.length; i++) {
          selected.add(false);
        }
      });
    }).catchError((e) => null);
    print(items);
  }

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: tertiaryThemeColor(),
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: iconWidget("assets/images/logo1.png"),
          ),
          title: Text(
            "Add Business",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryTextColor(),
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: secondaryThemeColor(),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(20, sheight / 48, 20, 0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                reusableTextField("Business Name", Icons.business_center, '',
                    false, businessNameController),
                SizedBox(
                  height: sheight * 0.0208,
                ),
                reusableTextArea("Description", Icons.message, false,
                    businessDiscController),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                  color: primaryTextColor(),
                ),
                Container(
                    height: sheight * 0.2,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: sheight * 0.04167,
                            child: Text(
                              'Categories',
                              style: TextStyle(
                                fontSize: 18,
                                color: primaryTextColor(),
                              ),
                            ),
                          ),
                          Container(
                            height: sheight * 0.1428,
                            decoration: BoxDecoration(
                                color: tertiaryThemeColor(),
                                borderRadius: BorderRadius.circular(16)),
                            child: GridView.builder(
                              itemCount: items.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final item = items[index];

                                return Container(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        for (int i = 0; i < items.length; i++) {
                                          selected[i] = false;
                                        }
                                        selected[index] = !selected[index];
                                        setState(() {
                                          catPick = true;
                                          catPickWarning = '';
                                        });
                                        print('cat selected');
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: selected[index]
                                              ? primaryThemeColor()
                                              : tertiaryThemeColor(),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: primaryThemeColor())),
                                      child: Center(
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                              color: selected[index]
                                                  ? tertiaryThemeColor()
                                                  : primaryThemeColor()),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: (1 / 2),
                              ),
                            ),
                          ),
                        ])),
                catPick
                    ? Container()
                    : Text(
                        catPickWarning,
                        style: TextStyle(color: Colors.red),
                      ),
                Divider(
                  thickness: 1,
                  color: primaryTextColor(),
                ),
                Container(
                  height: sheight * 0.278,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: sheight * 0.04166,
                        child: Text(
                          'Tags',
                          style: TextStyle(
                            fontSize: 18,
                            color: primaryTextColor(),
                          ),
                        ),
                      ),
                      Container(
                        height: sheight * 0.1428,
                        decoration: BoxDecoration(
                            color: tertiaryThemeColor(),
                            borderRadius: BorderRadius.circular(16)),
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: tags.length,
                          itemBuilder: (context, index) {
                            final item = tags[index];
                            return Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: primaryThemeColor(),
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: primaryThemeColor())),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 12),
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                            color: secondaryTextColor()),
                                      ),
                                    ),
                                    IconButton(
                                        color: secondaryTextColor(),
                                        onPressed: () {
                                          tags.removeAt(index);
                                          setState(() {
                                            disabletag = false;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.cancel,
                                          size: 15,
                                        ))
                                  ]),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: (3 / 1),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: swidth / 2,
                            height: swidth / 9,
                            child: TextField(
                              enabled: !disabletag,
                              controller: tagController,
                              style: TextStyle(color: primaryTextColor()),
                              cursorColor: primaryTextColor(),
                              decoration: InputDecoration(
                                labelText: 'Add a Tag',
                                labelStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                fillColor: tertiaryThemeColor(),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none)),
                              ),
                            ),
                          ),
                          IconButton(
                              color: primaryThemeColor(),
                              onPressed: () {
                                setState(() {
                                  if (tags.length < 4 &&
                                      tagController.text.trim() != '') {
                                    tags.add(tagController.text.trim());
                                  } else if (tags.length >= 4 &&
                                      tagController.text.trim() != '') {
                                    disabletag = true;
                                  }
                                });
                              },
                              icon: Icon(Icons.add))
                        ],
                      )
                    ],
                  ),
                ),
                disabletag
                    ? Text(
                        'Maximum of 4 tags allowed',
                        style: TextStyle(color: Colors.red),
                      )
                    : Text(''),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                  color: primaryTextColor(),
                ),
                reusableUIButton(context, "Next", (swidth / 3),50, () async {
                  final isValid = formKey.currentState!.validate();
                  if (!isValid) {
                    return;
                  }
                  bool catPicked = false;
                  for (int i = 0; i < items.length; i++) {
                    if (selected[i]) {
                      catPicked = true;
                    }
                  }
                  if (!catPicked) {
                    setState(() {
                      catPick = false;
                      catPickWarning = 'Select a category';
                    });
                    print('cat not selected');
                    return;
                  }
                  setState(() {});
                  businessInfo[0] = businessNameController.text;
                  businessInfo[1] = businessDiscController.text;
                  for (int i = 0; i < items.length; i++) {
                    if (selected[i]) {
                      businessInfo[2] = items[i];
                    }
                  }

                  for (int i = 0; i < tags.length; i++) {
                    if (tags[i] != '') {
                      businessInfo[i + 3] = tags[i];
                    }
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddBusinessInfo(businessInfo: businessInfo)));
                }),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
