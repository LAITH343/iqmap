import 'package:flutter_device_compass/flutter_device_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final compassRepositoryProvider = Provider<CompassRepository>(
  (ref) => const CompassRepository(),
);

class CompassRepository {
  const CompassRepository();

  Stream<double?> watchHeading() {
    final events = FlutterCompass.eventsFor(CompassUpdateOptions.balanced);
    if (events == null) return const Stream.empty();
    return events.map((event) => event.heading);
  }
}
