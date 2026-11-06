enum LocationFailure { serviceDisabled, denied, permanentlyDenied, unknown }

class LocationException implements Exception {
  const LocationException(this.failure, this.message);

  final LocationFailure failure;
  final String message;

  @override
  String toString() => message;
}
