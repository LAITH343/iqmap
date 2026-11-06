import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iqmap/src/home/presentation/controllers/follow_controller.dart';
import 'package:iqmap/src/home/presentation/controllers/location_providers.dart';
import 'package:iqmap/src/home/presentation/controllers/tracking_controller.dart';

class UserLocationButton extends ConsumerWidget {
  const UserLocationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTracking = ref.watch(isTrackingProvider);
    final following = ref.watch(followControllerProvider);
    final isLoading =
        ref.watch(trackingControllerProvider).isLoading ||
        (isTracking &&
            ref.watch(userLocationProvider.select((s) => s.isLoading)));
    final tracking = ref.read(trackingControllerProvider.notifier);
    final follow = ref.read(followControllerProvider.notifier);

    return Positioned(
      bottom: 100,
      right: 16,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 6,
        shadowColor: Colors.black38,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 56,
          height: 56,
          child: isLoading
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                    strokeWidth: 2,
                  ),
                )
              : InkWell(
                  onTap: isTracking ? follow.follow : tracking.start,
                  onLongPress: isTracking ? tracking.stop : null,
                  splashColor: const Color(0x331A73E8),
                  child: Icon(
                    following
                        ? Icons.my_location_rounded
                        : Icons.location_searching_rounded,
                    color: isTracking ? const Color(0xFF1A73E8) : Colors.grey,
                    size: 26,
                  ),
                ),
        ),
      ),
    );
  }
}
