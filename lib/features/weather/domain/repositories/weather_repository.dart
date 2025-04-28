import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Result<Weather>> getWeather(double lat, double lon);
}
