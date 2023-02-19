import 'package:flutter/material.dart';
import 'dart:convert';
import 'map_page.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:h4h/pages/events_page.dart';
import 'package:h4h/backend/database.dart';
import 'package:h4h/models/event.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MapPage())),
              child: const Text('Leo\'s map')),
          TextButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const EventsPage())),
              child: const Text('Events page')),
          TextButton(
            onPressed: () async {
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
              ));

              print('\n\n\n');
              print((await DB.instance.getAllEvents()).length);
            },
            child: Text('Scan QR Code'),
          ),
        ],
      ),
    );
  }
}
