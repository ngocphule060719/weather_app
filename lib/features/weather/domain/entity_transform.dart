import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

extension WeatherExtension on WeatherModel {
  Weather toEntity() {
    return Weather(
      currentTemperature: currentWeather.toEntity(),
      locationName: locationName.split('/').last.replaceAll("_", " "),
      dailyForecasts: dailyWeathers.map((e) => e.toEntity()).toList(),
    );
  }
}
