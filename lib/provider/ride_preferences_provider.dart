import 'package:flutter/foundation.dart';
import '../model/ride/ride_pref.dart';
import '../repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];

  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    // For now past preferences are fetched only 1 time

    _pastPreferences = repository.getPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

  void setCurrentPreferrence(RidePreference pref) {
    // Your code

    if (_currentPreference != pref) {
      _currentPreference = pref;
      _addPreference(pref);
      notifyListeners();
    }
  }

  void _addPreference(RidePreference preference) {
// Your code
    if (!_pastPreferences.contains(preference)) {
      repository.addPreference(preference);
    }
  }

// History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();
}
