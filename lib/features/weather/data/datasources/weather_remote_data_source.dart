import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<(Failure?, WeatherModel?)> getWeather(double lat, double lon);
}
