import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/services/location_service.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/location.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather.dart';
import 'package:weather_app/features/weather/presentation/cubit/weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final GetWeather getWeather;
  final LocationService locationService;

  WeatherCubit({
    required this.getWeather,
    required this.locationService,
  }) : super(const WeatherInitial());

  Future<void> fetchWeather() async {
    emit(const WeatherLoading());
    try {
      await locationService.requestLocationPermission();

      final locationTuple = await locationService.getCurrentPosition();
      final location = Location.fromTuple(locationTuple);

      final result = await getWeather(location);
      _handleResult(result);
    } catch (e) {
      if (e is Failure) {
        emit(WeatherError(e));
      } else {
        emit(WeatherError(GeneralFailure(e.toString())));
      }
    }
  }

  void _handleResult(Result<Weather> result) {
    switch (result) {
      case Success(data: final weather):
        emit(WeatherLoaded(weather.copyWith(
          dailyForecasts: weather.dailyForecasts.take(4).toList(),
        )));
      case Error(error: final error):
        if (error is Failure) {
          emit(WeatherError(error));
        } else {
          emit(WeatherError(GeneralFailure(error.toString())));
        }
    }
  }
}
