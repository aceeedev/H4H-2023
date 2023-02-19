import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:h4h/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:h4h/models/location.dart';
import 'package:intl/intl.dart';

String apiUrl = 'https://hands4hope.pythonanywhere.com';

Future<List<Event>> findEvents(double lat, double long, String query) async {
  String endpoint = '/findevents';
  var response = await http.Client()
      .get(Uri.parse('$apiUrl$endpoint?lat=$lat&long=$long&query=$query'));

  if (response.statusCode == 200) {
    List<dynamic> json = jsonDecode(response.body) as List<dynamic>;
    List<Event> foundEvents = [];

    for (Map<String, dynamic> event in json) {
      DateTime? startTime = null;
      DateTime? endTime = null;

      if (event['time'] != null) {
        DateTime now = DateTime.now();

        List<String> startTimeHours = ((event['time'][0]) as String).split(':');
        List<String> endTimeHours = ((event['time'][1]) as String).split(':');

        startTime = DateTime(now.year, now.month, now.day,
            int.parse(startTimeHours[0]), int.parse(startTimeHours[1]));
        endTime = DateTime(now.year, now.month, now.day,
            int.parse(endTimeHours[0]), int.parse(endTimeHours[1]));
      }

      foundEvents.add(
        Event(
            startTime: startTime,
            endTime: endTime,
            name: event['name'],
            long: event['cords'][1],
            lat: event['cords'][0],
            address: event['location']),
      );
    }

    return foundEvents;
  } else {
    throw Exception('Failed to load events');
  }
}

Future<List<Location>> autoCompleteAddress(
    double lat, double long, String address) async {
  String endpoint = '/completeaddress';
  var response = await http.Client()
      .get(Uri.parse('$apiUrl$endpoint?address=$address&$lat=lat&long=$long'));

  if (response.statusCode == 200) {
    List<dynamic> json = jsonDecode(response.body);
    List<Location> autoCompletedAddresses = [];

    for (Map<String, dynamic> location in json) {
      autoCompletedAddresses.add(Location(
          address: location['location'],
          latitude: location['cords'][0],
          longitude: location['cords'][1]));
    }

    return autoCompletedAddresses;
  } else {
    throw Exception('Failed to load addresses, code ${response.statusCode}');
  }
}
