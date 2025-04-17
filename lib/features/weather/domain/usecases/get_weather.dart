import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/usecases/usecase.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class GetWeather implements Usecase<Weather, LocationParams> {
  final WeatherRepository repository;

  GetWeather({
    required this.repository,
  });

  @override
  Future<(Failure?, Weather?)> call(LocationParams params) async {
    return await repository.getWeather(params.lat, params.lon);
  }
}

class LocationParams {
  final double lat;
  final double lon;

  LocationParams({
    required this.lat,
    required this.lon,
  });
}
