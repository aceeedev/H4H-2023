import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:h4h/backend/flask_interface.dart';
import 'package:h4h/coords.dart' as coords;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:h4h/providers/event_form_provider.dart';
import 'package:h4h/backend/database.dart';
import 'dart:async';
import 'package:h4h/models/event.dart';
import 'package:flutter/services.dart';
import 'events_page.dart';
import 'event_form_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  // a list of events to plot
  Set<Marker> events = {};

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

  void _onNavBarTap(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => const MapPage(),
      //   ),
      // );
    }
    if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const EventsPage(),
        ),
      );
    }
    if (index == 2) {
      context.read<EventFormProvider>().reset();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const EventFormPage(),
        ),
      );
    }
    if (index == 3) {
      String eventStringJson = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);

      Map<String, dynamic> eventJson = json.decode(eventStringJson);

      await DB.instance.saveEvent(Event(
        startTime: DateTime.parse(eventJson['startTime']),
        endTime: DateTime.parse(eventJson['endTime']),
        name: eventJson['name'],
        description: eventJson['description'],
        long: eventJson['long'],
        lat: eventJson['lat'],
        address: eventJson['address'],
      ));

      print('\n\n\n');
      print((await DB.instance.getAllEvents()).length);
    }
  }

  /// Returns a [Map<String, dynamic>] of the following:
  ///   allEvents: List<Event>
  ///   foodEvents: List<Event>
  ///   jobEvents: List<Event>
  ///   genericMarker: BitmapDescriptor
  Future<Map<String, dynamic>> getFutures() async {
    Map<String, dynamic> futures = {};
    double lat = coords.scuLat;
    double long = coords.scuLong;

    futures['allEvents'] = await DB.instance.getAllEvents();
    futures['foodEvents'] = await findEvents(lat, long, 'soup kitchens');
    futures['jobEvents'] = await findEvents(lat, long, '');
    futures['genericMarker'] = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 3.2),
        'frontend/h4h/assets/icons/frame_person_FILL0_wght400_GRAD0_opsz48.png');

    return futures;
  }

  @override
  Widget build(BuildContext context) {
    // call our api to get a list of events
    // and then add them to events
    return FutureBuilder(
        future: getFutures(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('An error has occurred, ${snapshot.error}'));
            } else if (snapshot.hasData) {
              Map<String, dynamic> futureData = snapshot.data!;

              List<Event> allEvents = futureData['allEvents'];
              List<Event> foodEvents = futureData['foodEvents'];
              List<Event> jobEvents = futureData['jobEvents'];
              BitmapDescriptor genericMarker = futureData['genericMarker'];

              if (futureData.isEmpty) return const Text('No events');

              for (int index = 0; index < allEvents.length; index++) {
                print('${allEvents[index].lat} ${allEvents[index].long}');
                events.add(Marker(
                    markerId: MarkerId(index.toString()),
                    position:
                        LatLng(allEvents[index].lat, allEvents[index].long),
                    icon: genericMarker));
              }

              events.add(const Marker(
                  markerId: MarkerId("1"),
                  position: LatLng(37.783333, -122.416667)));
              // icon: BitmapDescriptor.fromAssetImage(configuration, assetName)

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
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.list), label: 'Events'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.addchart), label: 'Contribute'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.qr_code), label: 'Scan')
                  ],
                  backgroundColor: Colors.amber,
                  selectedItemColor: Colors.white,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex,
                  onTap: _onNavBarTap,
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
          return const Center(child: CircularProgressIndicator());
        });
  }
}
