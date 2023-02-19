import 'dart:convert';
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
    List<Map<String, dynamic>> json =
        jsonDecode(response.body) as List<Map<String, dynamic>>;
    List<Event> foundEvents = [];

    for (Map<String, dynamic> event in json) {
      foundEvents.add(
        Event(
            startTime: DateFormat().parse(event['time'][0]),
            endTime: DateFormat().parse(event['time'][1]),
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
