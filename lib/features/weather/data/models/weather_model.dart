import 'package:weather_app/core/utils/parser.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

class WeatherModel {
  final CurrentWeatherModel currentWeather;
  final String locationName;
  final List<DailyWeatherModel> dailyWeathers;

  WeatherModel({
    required this.currentWeather,
    required this.locationName,
    required this.dailyWeathers,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      currentWeather: CurrentWeatherModel.fromJson(json.parseMap('current')),
      locationName: json.parseString('timezone'),
      dailyWeathers: json
          .parseListMap('daily')
          .map((e) => DailyWeatherModel.fromJson(e))
          .toList(),
    );
  }

  Weather toEntity() {
    return Weather(
      currentTemperature: currentWeather.toEntity(),
      locationName: locationName.split('/').last.replaceAll("_", " "),
      dailyForecasts: dailyWeathers.map((e) => e.toEntity()).toList(),
    );
  }
}

class CurrentWeatherModel {
  final double temperature;

  CurrentWeatherModel({required this.temperature});

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(temperature: json.parseDouble('temp'));
  }

  double toEntity() => temperature;
}

class DailyWeatherModel {
  final DateTime date;
  final double avgTemperature;

  DailyWeatherModel({required this.date, required this.avgTemperature});

  factory DailyWeatherModel.fromJson(Map<String, dynamic> json) {
    final temp = json.parseMap('temp');
    return DailyWeatherModel(
      date: DateTime.fromMillisecondsSinceEpoch(json.parseInt('dt') * 1000),
      avgTemperature: temp.parseDouble('day'),
    );
  }

  DailyForecast toEntity() {
    return DailyForecast(
      date: date,
      avgTemperature: avgTemperature,
    );
  }
}
