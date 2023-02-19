import 'package:flutter/material.dart';
import 'package:h4h/models/event.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});
  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [Text(event.name), Text(event.description!)],
      ),
    ));
  }
}
