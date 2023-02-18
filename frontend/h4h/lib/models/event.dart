import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'event.g.dart';

@HiveType(typeId: 1)
class Event {
  @HiveField(0)
  int id;
  @HiveField(1)
  DateTime time;
  @HiveField(2)
  String name;
  @HiveField(3)
  String? description;
  @HiveField(4)
  IconData icon;

  Event({
    required this.id,
    required this.time,
    required this.name,
    this.description,
    required this.icon,
  });
}
