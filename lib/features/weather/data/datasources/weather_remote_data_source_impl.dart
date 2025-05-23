import 'package:dio/dio.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/network/network_client.dart';
import 'package:weather_app/core/utils/error_utils.dart';
import 'package:weather_app/core/utils/parser.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';

class WeatherRemoteDataSourceImpl extends WeatherRemoteDataSource {
  final NetworkClient networkClient;

  WeatherRemoteDataSourceImpl({required this.networkClient});

  @override
  Future<Result<WeatherModel>> getWeather(double lat, double lon) async {
    try {
      final response = await networkClient.get(
        '/onecall',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'exclude': 'hourly,minutely,alerts',
          'units': 'metric',
        },
      );

      if (_isSuccess(response)) {
        final weather = WeatherModel.fromJson(response.data);
        return Result.success(weather);
      }

      return Result.error(
          GeneralFailure(ErrorParser.parseApiError(response.data)));
    } on DioException catch (error) {
      return Result.error(GeneralFailure(ErrorParser.parseDioError(error)));
    } catch (error) {
      return Result.error(GeneralFailure('Unexpected error: $error'));
    }
  }

  bool _isSuccess(Response<dynamic> response) {
    final data = response.data;
    return data is Map<String, dynamic> && data.parseIntOrNull('cod') == null;
  }
}
