import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

import 'weather_repository_impl_test.mocks.dart';

@GenerateMocks([WeatherRemoteDataSource])
void main() {
  late WeatherRepositoryImpl repository;
  late MockWeatherRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockWeatherRemoteDataSource();
    repository = WeatherRepositoryImpl(remoteDataSource: mockDataSource);
  });

  test('getWeather returns Weather on success', () async {
    final weatherModel = WeatherModel(
      currentWeather: CurrentWeatherModel(temperature: 30.0),
      locationName: 'Asia/Ho_Chi_Minh',
      dailyWeathers: [
        DailyWeatherModel(date: DateTime(2025, 4, 18), avgTemperature: 31.0),
      ],
    );

    when(mockDataSource.getWeather(10.76, 106.66))
        .thenAnswer((_) async => Result.success(weatherModel));

    final result = await repository.getWeather(10.76, 106.66);

    expect(result, isA<Success<Weather>>());
    final weather = (result as Success<Weather>).data;
    expect(weather.locationName, 'Ho Chi Minh');
    expect(weather.currentTemperature, 30.0);
    expect(weather.dailyForecasts.first.avgTemperature, 31.0);
    verify(mockDataSource.getWeather(10.76, 106.66)).called(1);
  });

  test('getWeather returns Failure on error', () async {
    const failure = GeneralFailure();
    when(mockDataSource.getWeather(10.76, 106.66))
        .thenAnswer((_) async => Result.error(failure));

    final result = await repository.getWeather(10.76, 106.66);

    expect(result, isA<Error>());
    expect((result as Error).error, failure);
    verify(mockDataSource.getWeather(10.76, 106.66)).called(1);
  });

  test('getWeather returns Failure when data source returns error', () async {
    when(mockDataSource.getWeather(10.76, 106.66)).thenAnswer(
        (_) async => Result.error(const GeneralFailure('No data available')));

    final result = await repository.getWeather(10.76, 106.66);

    expect(result, isA<Error>());
    expect((result as Error).error, isA<GeneralFailure>());
    verify(mockDataSource.getWeather(10.76, 106.66)).called(1);
  });
}
