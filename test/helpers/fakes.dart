import 'dart:async';

import 'package:iqmap/src/home/data/compass_repository.dart';
import 'package:iqmap/src/home/data/location_repository.dart';
import 'package:iqmap/src/home/domain/location_permission.dart';
import 'package:iqmap/src/home/domain/user_location.dart';

const baghdad = UserLocation(latitude: 33.3, longitude: 44.4, accuracy: 12);
const basra = UserLocation(latitude: 30.5, longitude: 47.8, accuracy: 8);

class FakeLocationRepository implements LocationRepository {
  bool serviceEnabled = true;
  LocationPermissionStatus permission = LocationPermissionStatus.granted;
  UserLocation current = baghdad;
  Object? currentLocationError;
  int permissionRequests = 0;
  int openLocationSettingsCalls = 0;
  int openAppSettingsCalls = 0;

  final StreamController<UserLocation> _updates =
      StreamController<UserLocation>.broadcast();

  void emit(UserLocation location) => _updates.add(location);

  void emitError(Object error) => _updates.addError(error);

  @override
  Future<bool> isServiceEnabled() async => serviceEnabled;

  @override
  Future<LocationPermissionStatus> requestPermission() async {
    permissionRequests++;
    return permission;
  }

  @override
  Future<UserLocation> getCurrentLocation() async {
    final error = currentLocationError;
    if (error != null) throw error;
    return current;
  }

  @override
  Stream<UserLocation> watchLocation() => _updates.stream;

  @override
  Future<void> openLocationSettings() async => openLocationSettingsCalls++;

  @override
  Future<void> openAppSettings() async => openAppSettingsCalls++;
}

class FakeCompassRepository implements CompassRepository {
  final StreamController<double?> _headings =
      StreamController<double?>.broadcast();

  void emit(double? heading) => _headings.add(heading);

  @override
  Stream<double?> watchHeading() => _headings.stream;
}
