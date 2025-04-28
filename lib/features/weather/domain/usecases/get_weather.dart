import 'package:weather_app/core/usecases/usecase.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/location.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class GetWeather implements Usecase<Weather, Location> {
  final WeatherRepository repository;

  GetWeather({
    required this.repository,
  });

  @override
  Future<Result<Weather>> call(Location location) async {
    return await repository.getWeather(
      location.latitude,
      location.longitude,
    );
  }
}
