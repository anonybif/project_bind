import 'package:flutter/material.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/utils/color_utils.dart';
import 'package:time_interval_picker/time_interval_picker.dart';

class AddBusiness extends StatefulWidget {
  const AddBusiness({Key? key}) : super(key: key);

  @override
  State<AddBusiness> createState() => _AddBusinessState();
}

class _AddBusinessState extends State<AddBusiness> {
  final businessNameController = TextEditingController();
  final businessDiscController = TextEditingController();
  final locationController = TextEditingController();

  TimeOfDay timeOpens = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay timeClosed = const TimeOfDay(hour: 24, minute: 0);

  void timepicker(TimeOfDay time) async {}

  @override
  Widget build(BuildContext context) {
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
          "Add Business",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: hexStringToColor("e8e8e8")),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                reusableTextField("Business Name", Icons.business_center, false,
                    businessNameController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextArea(
                    "Description", Icons.message, businessDiscController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Location", Icons.pin_drop, false, locationController),
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
                              return Colors.red;
                            }
                            return Colors.deepOrange;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16)))),
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
                    // const SizedBox(width: 5),
                    Text(
                      timeOpens.format(context),
                      style: const TextStyle(fontSize: 16),
                    ),
                    // const SizedBox(width: 15),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.red;
                            }
                            return Colors.deepOrange;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16)))),
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
                    // const SizedBox(width: 5),
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
                TimeIntervalPicker(
                  endLimit: null,
                  startLimit: null,
                  onChanged: (DateTime? startTime, DateTime? endTime,
                      bool isAllDay) {},
                ),
              ],
            ),
          ))),
    );
  }
}
