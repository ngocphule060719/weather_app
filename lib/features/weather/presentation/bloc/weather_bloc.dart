import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/services/location_service.dart';
import 'package:weather_app/core/utils/error_utils.dart';
import 'package:weather_app/core/utils/result.dart';
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

      final result = await getWeather(LocationParams(
        lat: location.$1,
        lon: location.$2,
      ));

      if (result is Success<Weather>) {
        final weather = result.data;
        emit(WeatherLoaded(weather.copyWith(
          dailyForecasts: weather.dailyForecasts.take(4).toList(),
        )));
      } else if (result is Error) {
        emit(WeatherError(result.error as Failure));
      } else {
        emit(const WeatherError(GeneralFailure()));
      }
    } on Exception catch (e) {
      emit(WeatherError(GeneralFailure(ErrorParser.parseLocationErrror(e))));
    } catch (e) {
      emit(const WeatherError(GeneralFailure()));
    }
  }
}
