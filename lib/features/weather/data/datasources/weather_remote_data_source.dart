import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<Result<WeatherModel>> getWeather(double lat, double lon);
}
