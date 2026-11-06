import 'package:latlong2/latlong.dart';

abstract final class MapConfig {
  static const LatLng initialCenter = LatLng(33.315241, 44.3660671);
  static const double initialZoom = 15;
  static const double focusZoom = 17;
  static const String tileUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String userAgentPackageName = 'io.github.laith343.iqmap';
}
