import '../../../model/ride/ride_pref.dart';
import '../ride_preferences_repository.dart';

import '../../../dummy_data/dummy_data.dart';

class MockRidePreferencesRepository extends RidePreferencesRepository {
  final List<RidePreference> _pastPreferences = fakeRidePrefs;

  @override
  // List<RidePreference> getPastPreferences() {
  //   return _pastPreferences;
  // }

  Future<List<RidePreference>> getPastPreferences() async {
    await Future.delayed(const Duration(seconds: 2));
    return _pastPreferences;
  }

  @override
  // void addPreference(RidePreference preference) {
  //   _pastPreferences.add(preference);
  // }
  Future<void> addPreference(RidePreference preference) async {
    await Future.delayed(const Duration(seconds: 2));
    _pastPreferences.add(preference);  // Adding preference to mock database
  }
}
