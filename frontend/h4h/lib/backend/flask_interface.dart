import 'dart:convert';
import 'dart:ffi';
import 'package:h4h/models/event.dart';
import 'package:http/http.dart' as http;

String apiUrl = 'http://172.31.197.65:5000';

Future<Event> fetchEvent(double lat, double long, String query) async {
  String endpoint = '/populate';
  var response = await http.Client()
      .get(Uri.parse('$apiUrl$endpoint?lat=$lat&long=$long%query=$query'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Event.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load event');
  }
}
