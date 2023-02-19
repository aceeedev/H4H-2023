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

  Future<void> saveEvent(Event event) async => (await box).add(event);

  Future<Event> getEvent(int id) async => (await box).getAt(id);

  Future<List<Event>> getAllEvents() async =>
      (await box).values.cast<Event>().toList();
}
