import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:h4h/backend/database.dart';
import 'dart:async';
import 'package:h4h/models/event.dart';
import 'package:flutter/services.dart';
import 'events_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  // a list of events to plot
  Set<Marker> events = {};

  // event data we get from the api
  late List<Event> event_data;

  String mapStyle = '';

  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    rootBundle.loadString('assets/map_styles2.txt').then((string) {
      mapStyle = string;
    });
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _initial = CameraPosition(
    target: LatLng(37.783333, -122.416667),
    zoom: 14.4746,
  );


  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const EventsPage(),
        ),
      );
    }
  }

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
                  position: LatLng(37.783333, -122.416667)));
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Events'),
          BottomNavigationBarItem(
              icon: Icon(Icons.addchart), label: 'Contribute'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.offline_share), label: 'Share'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Fetch')
        ],
        backgroundColor: Colors.amber,
        selectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
        // onTap: Null
      ),
      //   floatingActionButton: FloatingActionButton.extended(
      //     onPressed: _goToTheLake,
      //     label:
      //         const Icon(Icons.add_location_alt), // const Text('To the lake!'),
      //     // icon: const Icon(Icons.directions_boat),
      //   ),
      //   floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }
}
