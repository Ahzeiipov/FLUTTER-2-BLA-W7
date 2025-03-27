import 'package:flutter/foundation.dart';
import '../model/ride/ride_pref.dart';
import '../repository/ride_preferences_repository.dart';
import '../provider/async_value.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  // List<RidePreference> _pastPreferences = [];
  late AsyncValue<List<RidePreference>> pastPreferences;
  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    // For now past preferences are fetched only 1 time

    // _pastPreferences = repository.getPastPreferences();

    pastPreferences = AsyncValue.loading();
    _fetchPastPreferences();
  }

  Future<void> _fetchPastPreferences() async {
    pastPreferences = AsyncValue.loading();
    notifyListeners();
    try {
// 2 Fetch data
      List<RidePreference> pastPrefs = await repository.getPastPreferences();
// 3 Handle success
      pastPreferences = AsyncValue.success(pastPrefs);
// 4 Handle error
    } catch (error) {
      pastPreferences = AsyncValue.error(error);
    }
    notifyListeners();
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

//   void _addPreference(RidePreference preference) {
// // Your code
//     if (!_pastPreferences.contains(preference)) {
//       repository.addPreference(preference);
//     }
//   }

  Future<void> _addPreference(RidePreference preference) async {
    try {
      await repository.addPreference(preference);
      _fetchPastPreferences();
    } catch (error) {
      print('Error adding preference: $error');
    }
  }

// History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory =>

      // this is a getter method that returns the past preferences in reverse order
      pastPreferences.data?.reversed.toList() ?? [];
}
