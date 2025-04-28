import 'package:weather_app/core/usecases/usecase.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/location_params.dart';

class GetWeather implements Usecase<Weather, LocationParams> {
  final WeatherRepository repository;

  GetWeather({
    required this.repository,
  });

  @override
  Future<Result<Weather>> call(LocationParams params) async {
    return await repository.getWeather(params.lat, params.lon);
  }
}
