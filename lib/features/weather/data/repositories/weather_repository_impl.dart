import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/entity_transform.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<Weather>> getWeather(double lat, double lon) async {
    final result = await remoteDataSource.getWeather(lat, lon);

    if (result is Success<WeatherModel>) {
      return Result.success(result.data.toEntity());
    }

    if (result is Error) {
      return Result.error(result.error as Failure);
    }

    return Result.error(const GeneralFailure('No data available'));
  }
}
