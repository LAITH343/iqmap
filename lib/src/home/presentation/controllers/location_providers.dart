import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iqmap/src/home/application/location_service.dart';
import 'package:iqmap/src/home/domain/user_location.dart';
import 'package:iqmap/src/home/presentation/controllers/tracking_controller.dart';

final userLocationProvider = StreamProvider<UserLocation?>((ref) {
  if (!ref.watch(isTrackingProvider)) return Stream.value(null);
  return ref.watch(locationServiceProvider).watchLocation();
}, retry: (_, _) => null);

final headingProvider = StreamProvider<double?>((ref) {
  if (!ref.watch(isTrackingProvider)) return Stream.value(null);
  return ref.watch(locationServiceProvider).watchHeading();
}, retry: (_, _) => null);
