import 'package:flutter/material.dart';
import 'package:h4h/backend/database.dart';
import 'package:h4h/pages/event_form_page.dart';
import 'package:h4h/widgets/event_card.dart';
import 'package:h4h/models/event.dart';
import 'map_page.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late List<Event> events;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MapPage(),
        ),
      );
    }
    // if (index == 1) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) => const EventsPage(),
    //     ),
    //   );
    // }
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const EventFormPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: const Text('Events Page'),
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
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Events'),
            BottomNavigationBarItem(
                icon: Icon(Icons.addchart), label: 'Contribute'),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Fetch')
          ],
          backgroundColor: Colors.amber,
          selectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onNavBarTap,
        ));
  }
}
