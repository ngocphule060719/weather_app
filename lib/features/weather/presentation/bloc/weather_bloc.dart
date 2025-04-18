import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/services/location_service.dart';
import 'package:weather_app/core/utils/error_utils.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather.dart';
import 'package:weather_app/features/weather/domain/usecases/location_params.dart';
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

  Future<void> _onFetchWeather(
    FetchWeather event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());
    try {
      await locationService.requestLocationPermission();

      final location = await locationService.getCurrentPosition();

      final (failure, weather) = await getWeather(LocationParams(
        lat: location.$1,
        lon: location.$2,
      ));

      _handleGetWeatherResult(failure, weather, emit);
    } on Exception catch (e) {
      emit(WeatherError(GeneralFailure(ErrorParser.parseLocationErrror(e))));
    } catch (e) {
      emit(const WeatherError(GeneralFailure()));
    }
  }

  void _handleGetWeatherResult(
    Failure? failure,
    Weather? weather,
    Emitter<WeatherState> emit,
  ) {
    if (weather != null) {
      emit(WeatherLoaded(weather));
      return;
    }

    if (failure != null) {
      emit(WeatherError(failure));
      return;
    }

    emit(const WeatherError(GeneralFailure()));
  }
}
