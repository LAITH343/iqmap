import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iqmap/src/home/presentation/controllers/location_providers.dart';
import 'package:iqmap/src/home/presentation/controllers/tracking_controller.dart';
import 'package:iqmap/src/home/presentation/widgets/location_error_snackbar.dart';
import 'package:iqmap/src/home/presentation/widgets/map_widget.dart';
import 'package:iqmap/src/home/presentation/widgets/search_for_locations.dart';
import 'package:iqmap/src/home/presentation/widgets/user_location_button.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracking = ref.read(trackingControllerProvider.notifier);

    ref.listen(trackingControllerProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        showLocationErrorSnackBar(
          context,
          error,
          onOpenSettings: tracking.openSettingsFor,
        );
      }
    });

    ref.listen(userLocationProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        tracking.stop();
        showLocationErrorSnackBar(
          context,
          error,
          onOpenSettings: tracking.openSettingsFor,
        );
      }
    });

    return const Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: MapWidget()),
          UserLocationButton(),
          Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: SafeArea(child: SearchForLocations()),
          ),
        ],
      ),
    );
  }
}
