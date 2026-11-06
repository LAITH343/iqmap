import 'package:latlong2/latlong.dart';

class UserLocation {
  const UserLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });

  final double latitude;
  final double longitude;
  final double accuracy;

  LatLng get latLng => LatLng(latitude, longitude);
}
