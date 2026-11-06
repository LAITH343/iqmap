import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iqmap/src/home/presentation/controllers/follow_controller.dart';
import 'package:iqmap/src/home/presentation/controllers/location_providers.dart';
import 'package:iqmap/src/home/presentation/map_config.dart';
import 'package:iqmap/src/home/presentation/widgets/user_location_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapWidget extends ConsumerStatefulWidget {
  const MapWidget({super.key});

  @override
  ConsumerState<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends ConsumerState<MapWidget> {
  final MapController _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userLocationProvider, (previous, next) {
      final location = next.value;
      if (location == null || !ref.read(followControllerProvider)) return;
      final isFirstFix = previous?.value == null;
      _mapController.move(
        location.latLng,
        isFirstFix ? MapConfig.focusZoom : _mapController.camera.zoom,
      );
    });

    ref.listen(followControllerProvider, (previous, following) {
      if (!following || previous == true) return;
      final location = ref.read(userLocationProvider).value;
      if (location != null) {
        _mapController.move(location.latLng, MapConfig.focusZoom);
      }
    });

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: MapConfig.initialCenter,
        initialZoom: MapConfig.initialZoom,
        onPositionChanged: (camera, hasGesture) {
          if (hasGesture) {
            ref.read(followControllerProvider.notifier).stopFollowing();
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: MapConfig.tileUrlTemplate,
          userAgentPackageName: MapConfig.userAgentPackageName,
        ),
        const _AccuracyCircleLayer(),
        const _UserMarkerLayer(),
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
      ],
    );
  }
}

class _AccuracyCircleLayer extends ConsumerWidget {
  const _AccuracyCircleLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(userLocationProvider).value;
    if (location == null) return const SizedBox.shrink();
    return CircleLayer(
      circles: [
        CircleMarker(
          point: location.latLng,
          radius: location.accuracy,
          useRadiusInMeter: true,
          color: UserLocationIndicator.color.withValues(alpha: 0.15),
          borderColor: UserLocationIndicator.color.withValues(alpha: 0.4),
          borderStrokeWidth: 1,
        ),
      ],
    );
  }
}

class _UserMarkerLayer extends ConsumerWidget {
  const _UserMarkerLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(userLocationProvider).value;
    if (location == null) return const SizedBox.shrink();
    return MarkerLayer(
      markers: [
        Marker(
          point: location.latLng,
          width: UserLocationIndicator.size,
          height: UserLocationIndicator.size,
          child: const UserLocationIndicator(),
        ),
      ],
    );
  }
}
