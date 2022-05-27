import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_bind/reusable_widgets/reusable_widget.dart';
import 'package:project_bind/utils/color_utils.dart';
//import 'package:geocoder/geocoder.dart';

class Locationpicker extends StatefulWidget {
  final String prevlocation;

  const Locationpicker({Key? key, required this.prevlocation})
      : super(key: key);

  @override
  State<Locationpicker> createState() => _LocationpickerState();
}

class _LocationpickerState extends State<Locationpicker> {
  List<Marker> myMarker = [];
  String location = '';
  String loc = '';
  String lat = '';
  String long = '';

  @override
  void initState() {
    setState(() {
      List<String> prevloc = widget.prevlocation.split(',');

      if (widget.prevlocation != '') {
        var prevLat = num.tryParse(prevloc[0])!.toDouble();
        var prevLong = num.tryParse(prevloc[1])!.toDouble();

        myMarker = [];
        myMarker.add(Marker(
            width: 65.0,
            height: 65.0,
            point: LatLng(prevLat, prevLong),
            builder: (ctx) =>
                Icon(Icons.location_on, color: primaryThemeColor())));
      }
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: primaryThemeColor(),
        onPressed: () {
          addLocation();
        },
      ),
      appBar: AppBar(
        backgroundColor: primaryThemeColor()[600],
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: iconWidget("assets/images/logo1.png"),
        ),
        title: const Text(
          "Locate Business",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: FlutterMap(
        options: MapOptions(
          onTap: (tapPosition, point) => {
            handleTap(point),
          },
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
            // attributionBuilder: (_) {
            //   return const Text("© OpenStreetMap contributors");
            // },
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

  handleTap(tapPosition) {
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
          width: 65.0,
          height: 65.0,
          point: tapPosition,
          builder: (ctx) =>
              Icon(Icons.location_on, color: primaryThemeColor())));
    });
    location = tapPosition.toString();
  }

  addLocation() async {
    if (location != '') {
      await parselocation();
      loc = '$lat,$long';
    } else if (widget.prevlocation != '') {
      loc = widget.prevlocation;
    } else {
      return;
    }

    Navigator.pop(context, loc);
  }
}
