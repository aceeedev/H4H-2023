import 'package:flutter/material.dart';
import 'dart:ui';
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

  final CameraPosition _initial = CameraPosition(
    target: LatLng(coords.berkLat, coords.berkLong),
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
    }
  }

  /// Returns a [Map<String, dynamic>] of the following:
  ///   allEvents: List<Event>
  ///   foodEvents: List<Event>
  ///   shelterEvents: List<Event>
  ///   genericMarker: BitmapDescriptor
  ///   foodMarker: BitmapDescriptor
  ///   shelterMarker: BitmapDescriptor
  Future<Map<String, dynamic>> getFutures() async {
    double lat = coords.berkLat;
    double long = coords.berkLong;

    List<Event> foodEvents =
        await findEvents(lat, long, 'homeless soup kitchen');
    List<Event> shelterEvents = await findEvents(lat, long, 'homeless shelter');
    BitmapDescriptor genericMarker = await iconDataToBitmap(Icons.person);

    await DB.instance.saveAllEvents([...foodEvents, ...shelterEvents]);

    return {
      'allEvents': await DB.instance.getAllEvents(),
      'genericMarker': genericMarker
    };
  }

  Future<BitmapDescriptor> iconDataToBitmap(IconData iconData) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final iconStr = String.fromCharCode(iconData.codePoint);

    textPainter.text = TextSpan(
        text: iconStr,
        style: TextStyle(
          letterSpacing: 0.0,
          fontSize: 96.0,
          fontFamily: iconData.fontFamily,
          color: Colors.red,
        ));
    textPainter.layout();
    textPainter.paint(canvas, const Offset(0.0, 0.0));

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(96, 96);
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
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

              if (futureData.isEmpty) return const Text('No events');

              List<Event> allEvents = futureData['allEvents'];
              BitmapDescriptor genericMarker = futureData['genericMarker'];

              for (int index = 0; index < allEvents.length; index++) {
                events.add(Marker(
                    markerId: MarkerId(index.toString()),
                    position:
                        LatLng(allEvents[index].lat, allEvents[index].long),
                    icon: genericMarker));
              }

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
