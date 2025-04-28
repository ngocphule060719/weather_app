import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/services/location_service.dart';
import 'package:weather_app/core/utils/error_utils.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_event.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_state.dart';

import 'weather_bloc_test.mocks.dart';

@GenerateMocks([GetWeather, LocationService])
void main() {
  late WeatherBloc weatherBloc;
  late MockGetWeather mockGetWeather;
  late MockLocationService mockLocationService;

  setUp(() {
    mockGetWeather = MockGetWeather();
    mockLocationService = MockLocationService();
    weatherBloc = WeatherBloc(
      getWeather: mockGetWeather,
      locationService: mockLocationService,
    );
  });

  group('FetchWeather', () {
    final weather = Weather(
      currentTemperature: 30.0,
      locationName: 'Asia/HoChiMinh',
      dailyForecasts: [
        DailyForecast(date: DateTime(2025, 4, 19), avgTemperature: 30.0),
        DailyForecast(date: DateTime(2025, 4, 20), avgTemperature: 31.0),
      ],
    );
    final location = (10.76, 106.66);
    const permissionDeniedException =
        PermissionDeniedException('Location permission denied');
    const locationDisabledException = LocationServiceDisabledException();

    test('initial state is WeatherInitial', () {
      expect(weatherBloc.state, isA<WeatherInitial>());
    });

    blocTest<WeatherBloc, WeatherState>(
      'emits WeatherLoading and WeatherLoaded when location and weather fetch successfully',
      build: () {
        when(mockLocationService.requestLocationPermission())
            .thenAnswer((_) async => true);
        when(mockLocationService.getCurrentPosition())
            .thenAnswer((_) async => location);
        when(mockGetWeather(any))
            .thenAnswer((_) async => Result.success(weather));
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const FetchWeather()),
      expect: () => [const WeatherLoading(), WeatherLoaded(weather)],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits WeatherLoading and WeatherError when permission is denied',
      build: () {
        when(mockLocationService.requestLocationPermission())
            .thenThrow(permissionDeniedException);
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const FetchWeather()),
      expect: () => [
        const WeatherLoading(),
        WeatherError(GeneralFailure(
            ErrorParser.parseLocationErrror(permissionDeniedException))),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits WeatherLoading and WeatherError when location services are disabled',
      build: () {
        when(mockLocationService.requestLocationPermission())
            .thenThrow(locationDisabledException);
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const FetchWeather()),
      expect: () => [
        const WeatherLoading(),
        WeatherError(GeneralFailure(
            ErrorParser.parseLocationErrror(locationDisabledException))),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits WeatherLoading and WeatherError when weather fetch failed',
      build: () {
        when(mockLocationService.requestLocationPermission())
            .thenAnswer((_) async => true);
        when(mockLocationService.getCurrentPosition())
            .thenAnswer((_) async => location);
        when(mockGetWeather(any)).thenAnswer(
            (_) async => Result.error(const GeneralFailure('API error')));
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const FetchWeather()),
      expect: () => [
        const WeatherLoading(),
        const WeatherError(GeneralFailure('API error')),
      ],
    );
  });
}
