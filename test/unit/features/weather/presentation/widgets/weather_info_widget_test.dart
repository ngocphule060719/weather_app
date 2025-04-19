import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/theme/app_theme.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_info_widget.dart';

void main() {
  final weather = Weather(
    currentTemperature: 30.0,
    locationName: 'HoChiMinh',
    dailyForecasts: [
      DailyForecast(date: DateTime.parse('2025-04-20'), avgTemperature: 30.0),
      DailyForecast(date: DateTime.parse('2025-04-21'), avgTemperature: 31.0),
    ],
  );

  testWidgets('WeatherInfoWidget displays temperature and location',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: Scaffold(
          body: WeatherInfoWidget(weather: weather),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('30°'), findsOneWidget);
    expect(find.text('HoChiMinh'), findsOneWidget);
  });

  testWidgets('DailyWeatherInfoWidget displays forecast list',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: Scaffold(
          body: DailyWeatherInfoWidget(dailyForecasts: weather.dailyForecasts),
        ),
      ),
    );

    expect(find.text('Sunday'), findsOneWidget);
    expect(find.text('30°C'), findsOneWidget);
    expect(find.text('Monday'), findsOneWidget);
    expect(find.text('31°C'), findsOneWidget);
  });

  testWidgets('DailyWeatherItem displays single forecast',
      (WidgetTester tester) async {
    final forecast =
        DailyForecast(date: DateTime.parse('2025-04-20'), avgTemperature: 30.0);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: Scaffold(
          body: DailyForecastItem(forecast: forecast),
        ),
      ),
    );

    expect(find.text('Sunday'), findsOneWidget);
    expect(find.text('30°C'), findsOneWidget);
  });
}
