import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/location.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather.dart';

import 'get_weather_test.mocks.dart';

@GenerateMocks([WeatherRepository])
void main() {
  late GetWeather usecase;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetWeather(repository: mockWeatherRepository);
  });

  const location = Location(latitude: 10.76, longitude: 106.66);

  test('GetWeather should return Weather on success', () async {
    final weather = Weather(
      currentTemperature: 30.0,
      locationName: 'HoChiMinh',
      dailyForecasts: [
        DailyForecast(date: DateTime(2025, 4, 17), avgTemperature: 28.0),
      ],
    );

    when(mockWeatherRepository.getWeather(10.76, 106.66))
        .thenAnswer((_) async => Success(weather));

    final result = await usecase(location);

    switch (result) {
      case Success(data: final data):
        expect(data, weather);
      case Error():
        fail('Expected Success but got Error');
    }
    verify(mockWeatherRepository.getWeather(10.76, 106.66)).called(1);
  });

  test('GetWeather should return Failure on error', () async {
    const failure = GeneralFailure('API error');

    when(mockWeatherRepository.getWeather(10.76, 106.66))
        .thenAnswer((_) async => const Error(failure));

    final result = await usecase(location);

    switch (result) {
      case Success():
        fail('Expected Error but got Success');
      case Error():
        expect(result.error.toString(), failure.toString());
    }
    verify(mockWeatherRepository.getWeather(10.76, 106.66)).called(1);
  });
}
