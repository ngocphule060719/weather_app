import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/services/location_service.dart';
import 'package:weather_app/core/utils/error_utils.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/location.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_event.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeather getWeather;
  final LocationService locationService;

  WeatherBloc({
    required this.getWeather,
    required this.locationService,
  }) : super(const WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
  }

  WeatherState _handleWeatherResult(Result<Weather> result) {
    if (result is Success<Weather>) {
      final weather = result.data;
      return WeatherLoaded(weather.copyWith(
        dailyForecasts: weather.dailyForecasts.take(4).toList(),
      ));
    } else if (result is Error) {
      final error = result.error;
      if (error is Failure) {
        return WeatherError(error);
      } else {
        return WeatherError(GeneralFailure(error.toString()));
      }
    } else {
      return const WeatherError(GeneralFailure('Unknown error'));
    }
  }

  Future<void> _onFetchWeather(
    FetchWeather event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());
    try {
      await locationService.requestLocationPermission();

      final locationTuple = await locationService.getCurrentPosition();
      final location = Location.fromTuple(locationTuple);

      final result = await getWeather(location);
      emit(_handleWeatherResult(result));
    } on Exception catch (e) {
      emit(WeatherError(GeneralFailure(ErrorParser.parseLocationErrror(e))));
    } catch (e) {
      emit(WeatherError(GeneralFailure(e.toString())));
    }
  }
}
