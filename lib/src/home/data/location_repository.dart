import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iqmap/src/home/domain/location_permission.dart';
import 'package:iqmap/src/home/domain/user_location.dart';
import 'package:permission_handler/permission_handler.dart';

final locationRepositoryProvider = Provider<LocationRepository>(
  (ref) => const LocationRepository(),
);

class LocationRepository {
  const LocationRepository();

  static const PermissionWithService _permission = Permission.locationWhenInUse;
  static const LocationSettings _settings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5,
  );

  Future<bool> isServiceEnabled() async =>
      (await _permission.serviceStatus).isEnabled;

  Future<LocationPermissionStatus> requestPermission() async {
    final status = await _permission.request();
    if (status.isGranted || status.isLimited) {
      return LocationPermissionStatus.granted;
    }
    if (status.isPermanentlyDenied) {
      return LocationPermissionStatus.permanentlyDenied;
    }
    return LocationPermissionStatus.denied;
  }

  Future<UserLocation> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: _settings,
    );
    return _toUserLocation(position);
  }

  Stream<UserLocation> watchLocation() =>
      Geolocator.getPositionStream(locationSettings: _settings)
          .map(_toUserLocation);

  Future<void> openLocationSettings() => Geolocator.openLocationSettings();

  Future<void> openAppSettings() => Geolocator.openAppSettings();

  UserLocation _toUserLocation(Position position) => UserLocation(
    latitude: position.latitude,
    longitude: position.longitude,
    accuracy: position.accuracy,
  );
}
