import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:project_bind/shared/reusable_widget.dart';
import 'package:project_bind/utils/color_utils.dart';
//import 'package:geocoder/geocoder.dart';

class Business_direction_page extends StatefulWidget {
  final String location;
  final String deviceLocation;
  const Business_direction_page(
      {Key? key, required this.location, required this.deviceLocation})
      : super(key: key);

  @override
  State<Business_direction_page> createState() =>
      _Business_direction_pageState();
}

class _Business_direction_pageState extends State<Business_direction_page> {
  List<Marker> myMarker = [];

  double lat = 0;
  double long = 0;
  double deviceLat = 0;
  double deviceLong = 0;

  @override
  void initState() {
    setLocation();
    super.initState();
  }

  setLocation() async {
    myMarker = [];

    await getBusinessLocation();

    print(myMarker);
  }

  getBusinessLocation() async {
    List<String> loc = widget.location.split(',');

    if (widget.location != '') {
      lat = num.tryParse(loc[0])!.toDouble();
      long = num.tryParse(loc[1])!.toDouble();
      print('$lat,$long');

      myMarker.add(Marker(
          width: 65.0,
          height: 65.0,
          point: LatLng(lat, long),
          builder: (ctx) =>
              Icon(Icons.location_on, color: primaryThemeColor())));
    }

    List<String> deviceLoc = widget.deviceLocation.split(',');

    if (widget.deviceLocation != '') {
      deviceLat = num.tryParse(deviceLoc[0])!.toDouble();
      deviceLong = num.tryParse(deviceLoc[1])!.toDouble();

      print('$deviceLat,$deviceLong');

      myMarker.add(Marker(
          width: 65.0,
          height: 65.0,
          point: LatLng(deviceLat, deviceLong),
          builder: (ctx) =>
              Icon(Icons.my_location, color: primaryThemeColor())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tertiaryThemeColor(),
        title: const Text(
          "Get Direction",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(lat, long),
          zoom: 15.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/anonybif/cl3cx9hxp000g14s7hw3cq9ql/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYW5vbnliaWYiLCJhIjoiY2wzY3cwdzN0MDJsejNtcHI2NnF1ZjFwdiJ9.KmZURW1zQepysv_g6xyiiw",
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoiYW5vbnliaWYiLCJhIjoiY2wzY3cwdzN0MDJsejNtcHI2NnF1ZjFwdiJ9.KmZURW1zQepysv_g6xyiiw',
              'id': 'mapbox.mapbox-streets-v8'
            },
          ),
          MarkerLayerOptions(markers: myMarker),
        ],
      ),
    );
  }

  // parselocation() {
  //   final firstSplit = location.split(':');
  //   final secondSplit = firstSplit[1].split(',');
  //   lat = secondSplit[0];
  //   final thirdSplit = firstSplit[2].toString().split(')');
  //   long = thirdSplit[0];
  // }
}
