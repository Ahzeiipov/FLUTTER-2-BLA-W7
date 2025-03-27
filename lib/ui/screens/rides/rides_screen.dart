import 'package:flutter/material.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';
// import '../../../service/ride_prefs_service.dart';
import 'package:provider/provider.dart';
// import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';
import '../../provider/ride_preferences_provider.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  void onBackPressed(BuildContext context) {
    // 1 - Back to the previous view
    Navigator.of(context).pop();
  }

  Future<void> onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    final provider = context.read<RidesPreferencesProvider>();
    provider.setCurrentPreferrence(newPreference);
    // Handle ride preference selection
  }

  void onPreferencePressed(BuildContext context) async {
    final currentPreference =
        context.read<RidesPreferencesProvider>().currentPreference;
    // Open a modal to edit the ride preferences
    RidePreference? newPreference = await Navigator.of(
      context,
    ).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (newPreference != null) {
      // 1 - Update the current preference
      // RidePrefService.instance.setCurrentPreference(newPreference);
      // Note: State management should handle UI update, if needed.
      context.read<RidesPreferencesProvider>();
    }
  }

  void onFilterPressed() {
    // Filter functionality
  }

  @override
  Widget build(BuildContext context) {
    final ridesPreferencesProvider = context.watch<RidesPreferencesProvider>();
    final currentPreference = ridesPreferencesProvider.currentPreference;
    final currentFilter = RideFilter(); // Adjust as needed

    // Get matching rides based on the current preference and filter
    final matchingRides =
        RidesService.instance.getRidesFor(currentPreference!, currentFilter);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            RidePrefBar(
              ridePreference: currentPreference,
              onBackPressed: () => onBackPressed(context),
              onPreferencePressed: () => onPreferencePressed(context),
              onFilterPressed: onFilterPressed,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
