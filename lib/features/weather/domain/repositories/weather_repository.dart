import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<(Failure?, Weather?)> getWeather(double lat, double lon);
}
