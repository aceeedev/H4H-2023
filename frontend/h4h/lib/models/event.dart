import 'package:hive/hive.dart';

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
  double long;
  @HiveField(6)
  double lat;

  Event({
    this.id, // idk
    required this.startTime,
    required this.endTime,
    required this.name,
    this.description,
    required this.long,
    required this.lat,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      startTime: json['time'][0],
      endTime: json['time'][1],
      name: json['name'],
      description: json['description'],
      long: json['coords'][1],
      lat: json['coords'][0],
    );
  }
}
