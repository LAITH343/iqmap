import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iqmap/src/home/data/compass_repository.dart';
import 'package:iqmap/src/home/data/location_repository.dart';
import 'package:iqmap/src/home/domain/location_failure.dart';
import 'package:iqmap/src/home/domain/location_permission.dart';
import 'package:iqmap/src/home/domain/user_location.dart';

final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(
    ref.watch(locationRepositoryProvider),
    ref.watch(compassRepositoryProvider),
  ),
);

class LocationService {
  const LocationService(this._locationRepository, this._compassRepository);

  static const double _headingThreshold = 1;

  final LocationRepository _locationRepository;
  final CompassRepository _compassRepository;

  Future<void> ensurePermission() async {
    if (!await _locationRepository.isServiceEnabled()) {
      throw const LocationException(
        LocationFailure.serviceDisabled,
        'Location services are disabled.',
      );
    }

    switch (await _locationRepository.requestPermission()) {
      case LocationPermissionStatus.granted:
        return;
      case LocationPermissionStatus.permanentlyDenied:
        throw const LocationException(
          LocationFailure.permanentlyDenied,
          'Location permission is permanently denied. Enable it from app settings.',
        );
      case LocationPermissionStatus.denied:
        throw const LocationException(
          LocationFailure.denied,
          'Location permission was denied.',
        );
    }
  }

  Stream<UserLocation> watchLocation() async* {
    yield await _locationRepository.getCurrentLocation();
    yield* _locationRepository.watchLocation();
  }

  Stream<double?> watchHeading() {
    double? last;
    return _compassRepository.watchHeading().map((value) {
      final current = last;
      if (value == null) return last = null;
      if (current == null) return last = (value + 360) % 360;
      final delta = ((value - current) % 360 + 540) % 360 - 180;
      if (delta.abs() < _headingThreshold) return current;
      return last = current + delta;
    }).distinct();
  }

  Future<void> openSettingsFor(LocationFailure failure) async {
    switch (failure) {
      case LocationFailure.serviceDisabled:
        await _locationRepository.openLocationSettings();
      case LocationFailure.permanentlyDenied:
        await _locationRepository.openAppSettings();
      case LocationFailure.denied:
      case LocationFailure.unknown:
        break;
    }
  }
}
