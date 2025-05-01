import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/services/location_service.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/location.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather.dart';
import 'package:weather_app/features/weather/presentation/cubit/weather_cubit.dart';
import 'package:weather_app/features/weather/presentation/cubit/weather_state.dart';
import 'package:bloc_test/bloc_test.dart';

import 'weather_cubit_test.mocks.dart';

@GenerateMocks([GetWeather, LocationService])
void main() {
  late WeatherCubit weatherCubit;
  late MockGetWeather mockGetWeather;
  late MockLocationService mockLocationService;

  setUp(() {
    mockGetWeather = MockGetWeather();
    mockLocationService = MockLocationService();
    weatherCubit = WeatherCubit(
      getWeather: mockGetWeather,
      locationService: mockLocationService,
    );
  });

  tearDown(() {
    weatherCubit.close();
  });

  test('initial state is WeatherInitial', () {
    expect(weatherCubit.state, isA<WeatherInitial>());
  });

  group('fetchWeather', () {
    final weather = Weather(
      currentTemperature: 30.0,
      locationName: 'Asia/HoChiMinh',
      dailyForecasts: [
        DailyForecast(date: DateTime(2025, 4, 19), avgTemperature: 30.0),
        DailyForecast(date: DateTime(2025, 4, 20), avgTemperature: 31.0),
      ],
    );
    const locationTuple = (10.76, 106.66);
    final location = Location.fromTuple(locationTuple);

    blocTest<WeatherCubit, WeatherState>(
      'emits [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockLocationService.requestLocationPermission())
            .thenAnswer((_) async => true);
        when(mockLocationService.getCurrentPosition())
            .thenAnswer((_) async => locationTuple);
        when(mockGetWeather(location))
            .thenAnswer((_) async => Result.success(weather));
        return weatherCubit;
      },
      act: (cubit) => cubit.fetchWeather(),
      expect: () => [
        const WeatherLoading(),
        WeatherLoaded(weather.copyWith(
          dailyForecasts: weather.dailyForecasts.take(4).toList(),
        )),
      ],
      verify: (_) {
        verify(mockLocationService.requestLocationPermission()).called(1);
        verify(mockLocationService.getCurrentPosition()).called(1);
        verify(mockGetWeather(location)).called(1);
      },
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [Loading, Error] when location permission is denied',
      build: () {
        when(mockLocationService.requestLocationPermission())
            .thenThrow(const GeneralFailure('Location permission denied'));
        return weatherCubit;
      },
      act: (cubit) => cubit.fetchWeather(),
      expect: () => [
        const WeatherLoading(),
        const WeatherError(GeneralFailure('Location permission denied')),
      ],
      verify: (_) {
        verify(mockLocationService.requestLocationPermission()).called(1);
        verifyNever(mockLocationService.getCurrentPosition());
        verifyNever(mockGetWeather(any));
      },
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [Loading, Error] when location service is disabled',
      build: () {
        when(mockLocationService.requestLocationPermission())
            .thenThrow(const GeneralFailure('Location services are disabled'));
        return weatherCubit;
      },
      act: (cubit) => cubit.fetchWeather(),
      expect: () => [
        const WeatherLoading(),
        const WeatherError(GeneralFailure('Location services are disabled')),
      ],
      verify: (_) {
        verify(mockLocationService.requestLocationPermission()).called(1);
        verifyNever(mockLocationService.getCurrentPosition());
        verifyNever(mockGetWeather(any));
      },
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [Loading, Error] when weather fetch fails',
      build: () {
        when(mockLocationService.requestLocationPermission())
            .thenAnswer((_) async => true);
        when(mockLocationService.getCurrentPosition())
            .thenAnswer((_) async => locationTuple);
        when(mockGetWeather(location))
            .thenAnswer((_) async => const Error(GeneralFailure('API error')));
        return weatherCubit;
      },
      act: (cubit) => cubit.fetchWeather(),
      expect: () => [
        const WeatherLoading(),
        const WeatherError(GeneralFailure('API error')),
      ],
      verify: (_) {
        verify(mockLocationService.requestLocationPermission()).called(1);
        verify(mockLocationService.getCurrentPosition()).called(1);
        verify(mockGetWeather(location)).called(1);
      },
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [Loading, Error] when an unexpected error occurs',
      build: () {
        when(mockLocationService.requestLocationPermission())
            .thenThrow(Exception('Unexpected error'));
        return weatherCubit;
      },
      act: (cubit) => cubit.fetchWeather(),
      expect: () => [
        const WeatherLoading(),
        const WeatherError(GeneralFailure('Exception: Unexpected error')),
      ],
      verify: (_) {
        verify(mockLocationService.requestLocationPermission()).called(1);
        verifyNever(mockLocationService.getCurrentPosition());
        verifyNever(mockGetWeather(any));
      },
    );
  });
}
