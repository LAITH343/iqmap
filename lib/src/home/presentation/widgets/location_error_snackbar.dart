import 'package:flutter/material.dart';
import 'package:iqmap/src/home/domain/location_failure.dart';

void showLocationErrorSnackBar(
  BuildContext context,
  Object error, {
  required void Function(LocationFailure failure) onOpenSettings,
}) {
  final failure = error is LocationException
      ? error.failure
      : LocationFailure.unknown;
  final canOpenSettings =
      failure == LocationFailure.serviceDisabled ||
      failure == LocationFailure.permanentlyDenied;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(error.toString()),
        action: canOpenSettings
            ? SnackBarAction(
                label: 'Settings',
                onPressed: () => onOpenSettings(failure),
              )
            : null,
      ),
    );
}
