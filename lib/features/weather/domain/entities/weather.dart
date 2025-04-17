import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final double currentTemperature;
  final String locationName;
  final List<DailyForecast> dailyForecasts;

  const Weather({
    required this.currentTemperature,
    required this.locationName,
    required this.dailyForecasts,
  });

  @override
  List<Object?> get props => [currentTemperature, locationName, dailyForecasts];
}

class DailyForecast extends Equatable {
  final DateTime date;
  final double avgTemperature;

  const DailyForecast({
    required this.date,
    required this.avgTemperature,
  });

  @override
  List<Object?> get props => [date, avgTemperature];
}
