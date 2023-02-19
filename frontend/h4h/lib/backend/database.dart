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
    List<String> allEvents =
        (await getAllEvents()).map((e) => e.address).toList();

    return !allEvents.contains(event.address);
  }

  Future<void> saveEvent(Event event) async {
    if (await checkIfDoesntExists(event)) {
      (await box).add(event);
    }
  }

  Future<void> saveAllEvents(List<Event> events) async {
    for (Event event in events) {
      if (await checkIfDoesntExists(event)) {
        (await box).add(event);
      }
    }
  }

  Future<List<Event>> getAllEvents() async =>
      (await box).values.cast<Event>().toList();
}
