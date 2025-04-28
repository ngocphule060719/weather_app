import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/domain/entities/location.dart';

void main() {
  group('Location', () {
    test('should create a valid Location with correct coordinates', () {
      const location = Location(latitude: 10.76, longitude: 106.66);
      expect(location.latitude, 10.76);
      expect(location.longitude, 106.66);
    });

    test('should throw when creating Location with invalid latitude', () {
      expect(
        () => Location(latitude: 91.0, longitude: 106.66),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => Location(latitude: -91.0, longitude: 106.66),
        throwsA(isA<AssertionError>()),
      );
    });

    test('should throw when creating Location with invalid longitude', () {
      expect(
        () => Location(latitude: 10.76, longitude: 181.0),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => Location(latitude: 10.76, longitude: -181.0),
        throwsA(isA<AssertionError>()),
      );
    });

    test('should create Location from tuple', () {
      final location = Location.fromTuple((10.76, 106.66));
      expect(location.latitude, 10.76);
      expect(location.longitude, 106.66);
    });

    test('should convert Location to tuple', () {
      const location = Location(latitude: 10.76, longitude: 106.66);
      final tuple = location.toTuple();
      expect(tuple.$1, 10.76);
      expect(tuple.$2, 106.66);
    });

    test('should create Location from coordinates', () {
      final location = Location.fromCoordinates(
        latitude: 10.76,
        longitude: 106.66,
      );
      expect(location.latitude, 10.76);
      expect(location.longitude, 106.66);
    });

    test('should create a copy with new values', () {
      const original = Location(latitude: 10.76, longitude: 106.66);
      final copy = original.copyWith(latitude: 11.76);
      expect(copy.latitude, 11.76);
      expect(copy.longitude, 106.66);
    });

    test('should validate coordinates', () {
      expect(Location.isValidLatitude(10.76), isTrue);
      expect(Location.isValidLatitude(91.0), isFalse);
      expect(Location.isValidLongitude(106.66), isTrue);
      expect(Location.isValidLongitude(181.0), isFalse);
    });

    test('should check if location is valid', () {
      const validLocation = Location(latitude: 10.76, longitude: 106.66);
      expect(validLocation.isValid, isTrue);
    });

    test('should have correct string representation', () {
      const location = Location(latitude: 10.76, longitude: 106.66);
      expect(
        location.toString(),
        'Location(latitude: 10.76, longitude: 106.66)',
      );
    });

    test('should be equal when coordinates are the same', () {
      const location1 = Location(latitude: 10.76, longitude: 106.66);
      const location2 = Location(latitude: 10.76, longitude: 106.66);
      expect(location1, location2);
    });

    test('should not be equal when coordinates are different', () {
      const location1 = Location(latitude: 10.76, longitude: 106.66);
      const location2 = Location(latitude: 11.76, longitude: 106.66);
      expect(location1, isNot(location2));
    });
  });
}
