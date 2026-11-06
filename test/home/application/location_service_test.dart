import 'package:flutter_test/flutter_test.dart';
import 'package:iqmap/src/home/application/location_service.dart';
import 'package:iqmap/src/home/domain/location_failure.dart';
import 'package:iqmap/src/home/domain/location_permission.dart';

import '../../helpers/fakes.dart';

Matcher throwsLocationFailure(LocationFailure failure) => throwsA(
  isA<LocationException>().having((e) => e.failure, 'failure', failure),
);

void main() {
  late FakeLocationRepository locationRepository;
  late FakeCompassRepository compassRepository;
  late LocationService service;

  setUp(() {
    locationRepository = FakeLocationRepository();
    compassRepository = FakeCompassRepository();
    service = LocationService(locationRepository, compassRepository);
  });

  group('ensurePermission', () {
    test('completes when service is enabled and permission granted', () async {
      await expectLater(service.ensurePermission(), completes);
    });

    test('throws serviceDisabled without asking for permission', () async {
      locationRepository.serviceEnabled = false;

      await expectLater(
        service.ensurePermission(),
        throwsLocationFailure(LocationFailure.serviceDisabled),
      );
      expect(locationRepository.permissionRequests, 0);
    });

    test('throws denied when permission is denied', () async {
      locationRepository.permission = LocationPermissionStatus.denied;

      await expectLater(
        service.ensurePermission(),
        throwsLocationFailure(LocationFailure.denied),
      );
    });

    test('throws permanentlyDenied when permission is permanently denied', () {
      locationRepository.permission =
          LocationPermissionStatus.permanentlyDenied;

      expect(
        service.ensurePermission(),
        throwsLocationFailure(LocationFailure.permanentlyDenied),
      );
    });
  });

  group('watchLocation', () {
    test('emits the current location first, then updates', () async {
      final values = [];
      final subscription = service.watchLocation().listen(values.add);
      await pumpEventQueue();

      locationRepository.emit(basra);
      await pumpEventQueue();

      expect(values, [baghdad, basra]);
      await subscription.cancel();
    });

    test('forwards current location errors', () {
      locationRepository.currentLocationError = Exception('no fix');

      expect(service.watchLocation(), emitsError(isA<Exception>()));
    });
  });

  group('watchHeading', () {
    Future<List<double?>> collect(List<double?> input) async {
      final values = <double?>[];
      final subscription = service.watchHeading().listen(values.add);
      for (final heading in input) {
        compassRepository.emit(heading);
      }
      await pumpEventQueue();
      await subscription.cancel();
      return values;
    }

    test('normalizes the first heading into 0..360', () async {
      expect(await collect([-90]), [270]);
    });

    test('ignores changes smaller than one degree', () async {
      expect(await collect([10, 10.5, 10.9, 12]), [10, 12]);
    });

    test('turns the short way across north', () async {
      expect(await collect([359, 1]), [359, 361]);
    });

    test('turns the short way backwards across north', () async {
      expect(await collect([1, 359]), [1, -1]);
    });

    test('resets when the heading becomes unavailable', () async {
      expect(await collect([90, null, 180]), [90, null, 180]);
    });
  });

  group('openSettingsFor', () {
    test('opens location settings when service is disabled', () async {
      await service.openSettingsFor(LocationFailure.serviceDisabled);

      expect(locationRepository.openLocationSettingsCalls, 1);
      expect(locationRepository.openAppSettingsCalls, 0);
    });

    test('opens app settings when permission is permanently denied', () async {
      await service.openSettingsFor(LocationFailure.permanentlyDenied);

      expect(locationRepository.openAppSettingsCalls, 1);
      expect(locationRepository.openLocationSettingsCalls, 0);
    });

    test('opens nothing for other failures', () async {
      await service.openSettingsFor(LocationFailure.denied);
      await service.openSettingsFor(LocationFailure.unknown);

      expect(locationRepository.openAppSettingsCalls, 0);
      expect(locationRepository.openLocationSettingsCalls, 0);
    });
  });
}
