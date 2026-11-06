import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iqmap/src/home/data/compass_repository.dart';
import 'package:iqmap/src/home/data/location_repository.dart';
import 'package:iqmap/src/home/domain/location_failure.dart';
import 'package:iqmap/src/home/domain/location_permission.dart';
import 'package:iqmap/src/home/presentation/controllers/follow_controller.dart';
import 'package:iqmap/src/home/presentation/controllers/location_providers.dart';
import 'package:iqmap/src/home/presentation/controllers/tracking_controller.dart';

import '../../../helpers/fakes.dart';

void main() {
  late FakeLocationRepository locationRepository;
  late FakeCompassRepository compassRepository;
  late ProviderContainer container;

  setUp(() {
    locationRepository = FakeLocationRepository();
    compassRepository = FakeCompassRepository();
    container = ProviderContainer.test(
      overrides: [
        locationRepositoryProvider.overrideWithValue(locationRepository),
        compassRepositoryProvider.overrideWithValue(compassRepository),
      ],
    );
  });

  TrackingController tracking() =>
      container.read(trackingControllerProvider.notifier);

  group('TrackingController', () {
    test('starts not tracking', () async {
      expect(await container.read(trackingControllerProvider.future), isFalse);
      expect(container.read(isTrackingProvider), isFalse);
    });

    test('tracks after permission is granted', () async {
      await tracking().start();

      expect(container.read(trackingControllerProvider).value, isTrue);
      expect(container.read(isTrackingProvider), isTrue);
    });

    test('exposes the failure when permission is denied', () async {
      locationRepository.permission = LocationPermissionStatus.denied;

      await tracking().start();

      final state = container.read(trackingControllerProvider);
      expect(
        state.error,
        isA<LocationException>().having(
          (e) => e.failure,
          'failure',
          LocationFailure.denied,
        ),
      );
      expect(container.read(isTrackingProvider), isFalse);
    });

    test('stop ends tracking', () async {
      await tracking().start();
      tracking().stop();

      expect(container.read(isTrackingProvider), isFalse);
    });

    test('openSettingsFor delegates to the service', () async {
      await tracking().openSettingsFor(LocationFailure.permanentlyDenied);

      expect(locationRepository.openAppSettingsCalls, 1);
    });
  });

  group('FollowController', () {
    test('follows when tracking starts and stops with tracking', () async {
      container.listen(followControllerProvider, (_, _) {});
      expect(container.read(followControllerProvider), isFalse);

      await tracking().start();
      expect(container.read(followControllerProvider), isTrue);

      tracking().stop();
      expect(container.read(followControllerProvider), isFalse);
    });

    test('stopFollowing and follow toggle follow mode', () async {
      container.listen(followControllerProvider, (_, _) {});
      await tracking().start();
      final follow = container.read(followControllerProvider.notifier);

      follow.stopFollowing();
      expect(container.read(followControllerProvider), isFalse);

      follow.follow();
      expect(container.read(followControllerProvider), isTrue);
    });
  });

  group('userLocationProvider', () {
    test('is null while not tracking', () async {
      container.listen(userLocationProvider, (_, _) {});

      expect(await container.read(userLocationProvider.future), isNull);
    });

    test('emits the current location then updates while tracking', () async {
      container.listen(userLocationProvider, (_, _) {});
      await tracking().start();

      expect(await container.read(userLocationProvider.future), baghdad);

      await pumpEventQueue();
      locationRepository.emit(basra);
      await pumpEventQueue();
      expect(container.read(userLocationProvider).value, basra);
    });

    test('returns to null when tracking stops', () async {
      container.listen(userLocationProvider, (_, _) {});
      await tracking().start();
      await container.read(userLocationProvider.future);

      tracking().stop();

      expect(await container.read(userLocationProvider.future), isNull);
    });

    test('surfaces stream errors', () async {
      container.listen(userLocationProvider, (_, _) {});
      await tracking().start();
      await container.read(userLocationProvider.future);
      await pumpEventQueue();

      locationRepository.emitError(Exception('lost signal'));
      await pumpEventQueue();

      expect(container.read(userLocationProvider).hasError, isTrue);
    });
  });

  group('headingProvider', () {
    test('emits headings only while tracking', () async {
      container.listen(headingProvider, (_, _) {});
      expect(await container.read(headingProvider.future), isNull);

      await tracking().start();
      container.read(headingProvider);
      await pumpEventQueue();
      compassRepository.emit(45);
      await pumpEventQueue();

      expect(container.read(headingProvider).value, 45);
    });
  });
}
