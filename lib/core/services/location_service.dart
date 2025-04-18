import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> requestLocationPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      throw const LocationServiceDisabledException();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const PermissionDeniedException('Location permission denied');
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
        timeLimit: const Duration(seconds: 10),
      );
      return (position.latitude, position.longitude);
    } catch (error) {
      throw Exception('Failed to fetch location: $error');
    }
  }
}
