import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:h4h/models/event.dart';
import 'package:h4h/pages/event_page.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});
  final Event event;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.name,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(event.description!),
            event.startTime != null
                ? Row(
                    children: [
                      Text(
                          "${DateFormat.yMd().add_jm().format(event.startTime as DateTime)} - ${DateFormat.yMd().add_jm().format(event.endTime as DateTime)}"),
                    ],
                  )
                : const SizedBox.shrink(),
            Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(event.address)),
          ],
        ),
      )),
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EventPage(event: event))),
    );
  }
}
