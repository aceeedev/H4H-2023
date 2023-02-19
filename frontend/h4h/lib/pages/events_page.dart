import 'package:flutter/material.dart';
import 'package:h4h/backend/database.dart';
import 'package:h4h/pages/event_form_page.dart';
import 'package:h4h/widgets/event_card.dart';
import 'package:h4h/models/event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late List<Event> events;

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
          title: const Text('Events Page'),
        ),
        body: FutureBuilder(
            future: DB.instance.getAllEvents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text('An error has occurred, ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  events = snapshot.data!;
                  if (events.isEmpty) return const Text('No events');

                  // sort events by ascending starting time
                  events.sort((a, b) => a.startTime.compareTo(b.startTime));

                  return ListView.builder(
                      itemCount: events.length,
                      itemBuilder: ((context, index) =>
                          EventCard(event: events[index])));
                }
              }
              return const Center(child: CircularProgressIndicator());
            }),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const EventFormPage()),
          ),
        ));
  }
}
