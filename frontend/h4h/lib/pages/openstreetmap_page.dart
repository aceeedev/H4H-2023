/* 
what a shame this does not work

import 'package:flutter/material.dart';
import 'package:h4h/backend/database.dart';
import 'dart:async';
import 'package:h4h/models/event.dart';
import 'package:flutter/services.dart';
// Suitable for most situations
import 'package:flutter_map/flutter_map.dart';
// Only import if required functionality is not exposed by default
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';



class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  // a list of events to plot
  // Set<Marker> events = {};

  // event data we get from the api
  late List<Event> event_data;

  String mapStyle = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    rootBundle
        .loadString('assets/map_styles2.txt')
        .then((string) {
      mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    // call our api to get a list of events
    // and then add them to events
    // build the map after getting data from events
    return Scaffold(
      body: FlutterMap(
    options: MapOptions(
      center: LatLng(51.5, -0.09),
      zoom: 13.0,
    ),
    nonRotatedChildren: [
        // This does NOT fulfill Mapbox's requirements for attribution
        // See https://docs.mapbox.com/help/getting-started/attribution/
        AttributionWidget.defaultWidget(
            source: '© Mapbox © OpenStreetMap',
            onSourceTapped: () async {
                // Requires 'url_launcher'
                if (!await launchUrl(Uri.parse("https://docs.mapbox.com/help/getting-started/attribution/"))) {
                    if (kDebugMode) print('Could not launch URL');
                }
            },
        )
    ],
    children: [
      TileLayer(
        urlTemplate: "https://api.mapbox.com/styles/v1/<user>/<tile-set-id>/tiles/<256/512>/{z}/{x}/{y}@2x?access_token={access_token}",
        additionalOptions: {
            "access_token": "<ACCESS-TOKEN>",
        },
        userAgentPackageName: 'com.example.app',
      ),
    ],
);,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_university));
  }
}
*/