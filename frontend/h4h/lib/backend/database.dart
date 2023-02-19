import 'package:hive_flutter/hive_flutter.dart';
import 'package:h4h/models/event.dart';

class DB {
  static final DB instance = DB._init();
  static Box? _box;

  DB._init();

  Future<Box> get box async {
    if (_box != null) return _box!;

    _box = await Hive.openBox('events');
    return _box!;
  }

  Future<bool> checkIfDoesntExists(Event event) async {
    List<Event> allEvents = await getAllEvents();
    return !allEvents.contains(event);
  }

  Future<void> saveEvent(Event event) async {
    if (await checkIfDoesntExists(event)) {
      (await box).add(event);
    }
  }

  Future<void> saveAllEvents(List<Event> events) async {
    for (Event event in events) {
      if (await checkIfDoesntExists(event)) {
        (await box).addAll(events);
      }
    }
  }

  Future<Event> getEvent(int id) async => (await box).getAt(id);

  Future<List<Event>> getAllEvents() async =>
      (await box).values.cast<Event>().toList();
}
