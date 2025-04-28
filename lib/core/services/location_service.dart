import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static const _timeoutDuration = Duration(seconds: 10);

  Future<bool> requestLocationPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      throw const LocationServiceDisabledException();
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final newPermission = await Geolocator.requestPermission();
      if (newPermission == LocationPermission.denied) {
        throw const PermissionDeniedException('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const PermissionDeniedException(
          'Location permission permanently denied');
    }

    return true;
  }

  Future<(double lat, double lon)> getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        timeLimit: _timeoutDuration,
      );
      return (position.latitude, position.longitude);
    } on TimeoutException {
      throw Exception('Location request timed out');
    } catch (error) {
      throw Exception('Failed to fetch location: $error');
    }
  }
}
