import 'package:hive/hive.dart';
import 'dart:convert';

part 'event.g.dart';

@HiveType(typeId: 1)
class Event {
  @HiveField(0)
  int? id;
  @HiveField(1)
  DateTime startTime;
  @HiveField(2)
  DateTime endTime;
  @HiveField(3)
  String name;
  @HiveField(4)
  String? description;
  @HiveField(5)
  int iconCodePoint;
  @HiveField(6)
  double long;
  @HiveField(7)
  double lat;

  Event({
    this.id,
    required this.startTime,
    required this.endTime,
    required this.name,
    this.description,
    required this.iconCodePoint,
    required this.long,
    required this.lat,
  });

  String toJsonString() {
    return json.encode({
      'startTime': startTime.toString(),
      'endTime': endTime.toString(),
      'name': name,
      'description': description,
      'iconCodePoint': iconCodePoint,
      'long': long,
      'lat': lat,
    });
  }
}
