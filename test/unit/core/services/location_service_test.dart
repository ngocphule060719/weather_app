import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/core/services/location_service.dart';

class FakeGeolocatorPlatform extends GeolocatorPlatform {
  bool serviceEnabled = true;
  LocationPermission permission = LocationPermission.denied;
  Position? position;
  Exception? exception;

  @override
  Future<bool> isLocationServiceEnabled() async {
    return serviceEnabled;
  }

  @override
  Future<LocationPermission> checkPermission() async {
    return permission;
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return permission;
  }

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    if (exception != null) {
      throw exception!;
    }
    if (position != null) {
      return position!;
    }
    throw Exception('No position set');
  }
}

void main() {
  late LocationService locationService;
  late FakeGeolocatorPlatform fakeGeolocator;

  setUp(() {
    fakeGeolocator = FakeGeolocatorPlatform();
    GeolocatorPlatform.instance = fakeGeolocator;
    locationService = LocationService();
  });

  group('requestLocationPermission', () {
    test('returns true when permission is granted', () async {
      fakeGeolocator.serviceEnabled = true;
      fakeGeolocator.permission = LocationPermission.always;

      final result = await locationService.requestLocationPermission();
      expect(result, true);
    });

    test('throws LocationServiceDisabledException when services are disabled',
        () async {
      fakeGeolocator.serviceEnabled = false;

      expect(
        locationService.requestLocationPermission(),
        throwsA(isA<LocationServiceDisabledException>()),
      );
    });

    test('throws PermissionDeniedException when permission is denied',
        () async {
      fakeGeolocator.serviceEnabled = true;
      fakeGeolocator.permission = LocationPermission.denied;

      expect(
        locationService.requestLocationPermission(),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test('throws PermissionDeniedException when permission is denied forever',
        () async {
      fakeGeolocator.serviceEnabled = true;
      fakeGeolocator.permission = LocationPermission.deniedForever;

      expect(
        locationService.requestLocationPermission(),
        throwsA(isA<PermissionDeniedException>()),
      );
    });
  });

  group('getCurrentLocation', () {
    test('returns coordinates when location fetch is successful', () async {
      fakeGeolocator.position = Position(
        latitude: 10.76,
        longitude: 106.66,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );

      final result = await locationService.getCurrentPosition();
      expect(result.$1, 10.76);
      expect(result.$2, 106.66);
    });

    test('throws Exception when location fetch fails', () async {
      fakeGeolocator.exception = Exception('Location fetch failed');

      expect(
        locationService.getCurrentPosition(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
