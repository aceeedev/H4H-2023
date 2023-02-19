import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:h4h/models/event.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key, required this.event});
  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.name)),
      body: Center(
        child: QrImage(
          data: event.toJsonString(),
          version: QrVersions.auto,
          size: 300.0,
        ),
      ),
    );
  }
}
