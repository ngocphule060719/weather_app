import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double latitude;
  final double longitude;

  static const double maxLatitude = 90.0;
  static const double minLatitude = -90.0;
  static const double maxLongitude = 180.0;
  static const double minLongitude = -180.0;

  const Location({
    required this.latitude,
    required this.longitude,
  })  : assert(
          latitude >= minLatitude && latitude <= maxLatitude,
          'Latitude must be between $minLatitude and $maxLatitude',
        ),
        assert(
          longitude >= minLongitude && longitude <= maxLongitude,
          'Longitude must be between $minLongitude and $maxLongitude',
        );

  factory Location.fromTuple((double, double) tuple) {
    return Location(
      latitude: tuple.$1,
      longitude: tuple.$2,
    );
  }

  factory Location.fromCoordinates({
    required double latitude,
    required double longitude,
  }) {
    return Location(
      latitude: latitude,
      longitude: longitude,
    );
  }

  (double, double) toTuple() => (latitude, longitude);

  Location copyWith({
    double? latitude,
    double? longitude,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  static bool isValidLatitude(double latitude) {
    return latitude >= minLatitude && latitude <= maxLatitude;
  }

  static bool isValidLongitude(double longitude) {
    return longitude >= minLongitude && longitude <= maxLongitude;
  }

  bool get isValid => isValidLatitude(latitude) && isValidLongitude(longitude);

  @override
  List<Object?> get props => [latitude, longitude];

  @override
  String toString() => 'Location(latitude: $latitude, longitude: $longitude)';
}
