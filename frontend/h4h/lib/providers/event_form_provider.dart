import 'package:flutter/material.dart';
import 'package:h4h/models/location.dart';

class EventFormProvider with ChangeNotifier {
  Location _location = Location(address: "", latitude: 0, longitude: 0);
  DateTime _lastTimeEditedLocation = DateTime.now();

  Location get location => _location;
  DateTime get lastTimeEditedLocation => _lastTimeEditedLocation;

  void setLocation(Location newLocation) {
    _location = newLocation;
    notifyListeners();
  }

  void setLastTimeEditedLocation(DateTime newDateTime) {
    _lastTimeEditedLocation = newDateTime;
    notifyListeners();
  }

  void reset() {
    _location = Location(address: "", latitude: 0, longitude: 0);
    _lastTimeEditedLocation = DateTime.now();
  }
}
