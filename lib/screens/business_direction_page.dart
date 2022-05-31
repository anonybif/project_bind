import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/utils/color_utils.dart';
//import 'package:geocoder/geocoder.dart';

class Business_direction_page extends StatefulWidget {
  const Business_direction_page({Key? key}) : super(key: key);

  @override
  State<Business_direction_page> createState() =>
      _Business_direction_pageState();
}

class _Business_direction_pageState extends State<Business_direction_page> {
  List<Marker> myMarker = [];
  String location = '';
  String loc = '';
  String lat = '';
  String long = '';

  @override
  void initState() {
    super.initState();
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
          center: LatLng(9, 38.77),
          zoom: 11.0,
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

  parselocation() {
    final firstSplit = location.split(':');
    final secondSplit = firstSplit[1].split(',');
    lat = secondSplit[0];
    final thirdSplit = firstSplit[2].toString().split(')');
    long = thirdSplit[0];
  }
}
