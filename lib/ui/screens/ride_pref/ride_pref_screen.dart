import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/widgets/errors/bla_error_screen.dart';

import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';
import '../../provider/ride_preferences_provider.dart';
import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';
import '../../provider/async_value.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  // This method will be called when a ride preference is selected
  void onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    final provider = context.read<RidesPreferencesProvider>();
    provider.setCurrentPreferrence(newPreference);

    // Navigate to the rides screen (with a bottom-to-top animation)
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(const RidesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final ridePreferenceProvider = context.watch<RidesPreferencesProvider>();
    final currentRidePreference = ridePreferenceProvider.currentPreference;
    final pastPreferences = ridePreferenceProvider.pastPreferences;

    return Stack(
      children: [
        const BlaBackground(),

        // Foreground content
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: BlaSpacings.m),
              Text(
                "Your pick of rides at low price",
                style: BlaTextStyles.heading.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 100),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    RidePrefForm(
                      initialPreference: currentRidePreference,
                      onSubmit: (preference) =>
                          onRidePrefSelected(context, preference),
                    ),
                    const SizedBox(height: BlaSpacings.m),
                    if (pastPreferences.state == AsyncValueState.loading)
                      const SizedBox(
                        height: 15, // Ensure it takes some space
                        child: Center(
                            child: BlaError(
                                message:
                                    'loading’') // Better than error message
                            ),
                      )
                    else if (pastPreferences.state == AsyncValueState.error)
                      const SizedBox(
                        height: 15,
                        child: Center(
                          child: BlaError(message: 'No connection. Try later.'),
                        ),
                      )
                    else if (pastPreferences.state == AsyncValueState.success)
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: pastPreferences.data?.length ?? 0,
                          itemBuilder: (ctx, index) => RidePrefHistoryTile(
                            ridePref: pastPreferences.data![index],
                            onPressed: () => onRidePrefSelected(
                                context, pastPreferences.data![index]),
                          ),
                        ),
                      )
                    else
                      const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
