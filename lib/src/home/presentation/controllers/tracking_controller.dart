import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iqmap/src/home/application/location_service.dart';
import 'package:iqmap/src/home/domain/location_failure.dart';

final trackingControllerProvider =
    AsyncNotifierProvider<TrackingController, bool>(TrackingController.new);

final isTrackingProvider = Provider<bool>((ref) {
  final tracking = ref.watch(trackingControllerProvider);
  return !tracking.hasError && (tracking.value ?? false);
});

class TrackingController extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() => false;

  Future<void> start() async {
    if (state.isLoading) return;
    final service = ref.read(locationServiceProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await service.ensurePermission();
      return true;
    });
  }

  void stop() => state = const AsyncData(false);

  Future<void> openSettingsFor(LocationFailure failure) =>
      ref.read(locationServiceProvider).openSettingsFor(failure);
}
