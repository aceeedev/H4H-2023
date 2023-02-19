import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:h4h/backend/database.dart';
import 'dart:async';
import 'package:h4h/models/event.dart';
import 'package:flutter/services.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  // a list of events to plot
  Set<Marker> events = {};

  // event data we get from the api
  late List<Event> event_data;

  String mapStyle = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    rootBundle
        .loadString('frontend/h4h/lib/assets/map_styles2.txt')
        .then((string) {
      mapStyle = string;
    });
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _initial = CameraPosition(
    target: LatLng(37.3496418, -121.9447969),
    zoom: 14.4746,
  );

  static const CameraPosition _university = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.3496418, -121.9447969),
      zoom: 14.4746);

  @override
  Widget build(BuildContext context) {
    // call our api to get a list of events
    // and then add them to events
    FutureBuilder(
        future: DB.instance.getAllEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('An error has occurred, ${snapshot.error}'));
            } else if (snapshot.hasData) {
              event_data = snapshot.data!;
              if (event_data.isEmpty) return const Text('No events');

              events.add(const Marker(
                  markerId: MarkerId("1"),
                  position: LatLng(37.3542894, -121.9359333)));
            }
          }
          return const Center(child: CircularProgressIndicator());
        });

    // build the map after getting data from events
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          controller.setMapStyle(mapStyle);
        },
        markers: events,
      ),
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
