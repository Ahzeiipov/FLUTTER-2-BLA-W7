import '../model/ride/ride_pref.dart';

abstract class RidePreferencesRepository {
  // List<RidePreference> getPastPreferences();

  Future<List<RidePreference>> getPastPreferences();

  Future<void> addPreference(RidePreference preference);
  // void addPreference(RidePreference preference);
}
