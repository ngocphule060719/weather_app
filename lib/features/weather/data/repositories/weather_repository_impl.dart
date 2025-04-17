import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<(Failure?, Weather?)> getWeather(double lat, double lon) async {
    final (failure, weather) = await remoteDataSource.getWeather(lat, lon);
    if (failure != null) {
      return (failure, null);
    }

    if (weather != null) {
      return (null, weather.toEntity());
    }

    return (const GeneralFailure('No data available'), null);
  }
}
