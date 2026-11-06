import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iqmap/src/home/data/compass_repository.dart';
import 'package:iqmap/src/home/data/location_repository.dart';
import 'package:iqmap/src/home/domain/location_permission.dart';
import 'package:iqmap/src/home/presentation/home_view.dart';
import 'package:iqmap/src/home/presentation/widgets/user_location_indicator.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeLocationRepository locationRepository;

  setUp(() => locationRepository = FakeLocationRepository());

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationRepositoryProvider.overrideWithValue(locationRepository),
          compassRepositoryProvider.overrideWithValue(FakeCompassRepository()),
        ],
        child: const MaterialApp(home: HomeView()),
      ),
    );
  }

  Future<void> tapLocationButton(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.location_searching_rounded));
    await tester.pump();
    await tester.pump();
  }

  testWidgets('shows the user marker and follow icon after locating', (
    tester,
  ) async {
    await pumpHome(tester);
    expect(find.byType(UserLocationIndicator), findsNothing);

    await tapLocationButton(tester);

    expect(find.byType(UserLocationIndicator), findsOneWidget);
    expect(find.byIcon(Icons.my_location_rounded), findsOneWidget);
  });

  testWidgets('long press stops tracking', (tester) async {
    await pumpHome(tester);
    await tapLocationButton(tester);

    await tester.longPress(find.byIcon(Icons.my_location_rounded));
    await tester.pump();

    expect(find.byType(UserLocationIndicator), findsNothing);
    expect(find.byIcon(Icons.location_searching_rounded), findsOneWidget);
  });

  testWidgets('denied permission shows a snackbar without settings action', (
    tester,
  ) async {
    locationRepository.permission = LocationPermissionStatus.denied;
    await pumpHome(tester);

    await tapLocationButton(tester);
    await tester.pump(const Duration(milliseconds: 750));

    expect(find.text('Location permission was denied.'), findsOneWidget);
    expect(find.text('Settings'), findsNothing);
    expect(find.byType(UserLocationIndicator), findsNothing);
  });

  testWidgets('permanently denied permission offers app settings', (
    tester,
  ) async {
    locationRepository.permission = LocationPermissionStatus.permanentlyDenied;
    await pumpHome(tester);

    await tapLocationButton(tester);
    await tester.pump(const Duration(milliseconds: 750));
    await tester.tap(find.text('Settings'));
    await tester.pump();

    expect(locationRepository.openAppSettingsCalls, 1);
  });

  testWidgets('disabled location service offers location settings', (
    tester,
  ) async {
    locationRepository.serviceEnabled = false;
    await pumpHome(tester);

    await tapLocationButton(tester);
    await tester.pump(const Duration(milliseconds: 750));
    await tester.tap(find.text('Settings'));
    await tester.pump();

    expect(locationRepository.openLocationSettingsCalls, 1);
  });

  testWidgets('location stream error stops tracking and shows a snackbar', (
    tester,
  ) async {
    await pumpHome(tester);
    await tapLocationButton(tester);

    locationRepository.emitError(Exception('lost signal'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));

    expect(find.text('Exception: lost signal'), findsOneWidget);
    expect(find.byType(UserLocationIndicator), findsNothing);
  });
}
