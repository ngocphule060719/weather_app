import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/network/network_client.dart';
import 'package:weather_app/core/utils/datetime_utils.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source_impl.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';

import 'weather_remote_datasource_test.mocks.dart';

@GenerateMocks([NetworkClient])
void main() {
  late WeatherRemoteDataSourceImpl datasource;
  late MockNetworkClient mockNetworkClient;

  setUp(() {
    mockNetworkClient = MockNetworkClient();
    datasource = WeatherRemoteDataSourceImpl(networkClient: mockNetworkClient);
  });

  test('getWeather should return WeatherModel on success', () async {
    final response = Response(
      requestOptions: RequestOptions(path: '/onecall'),
      statusCode: 200,
      data: {
        'current': {'temp': 30.0},
        'timezone': 'Asia/Ho_Chi_Minh',
        'daily': [
          {
            'dt': 1745289600,
            'temp': {'day': 30.0}
          },
          {
            'dt': 1745376000,
            'temp': {'day': 31.0}
          },
        ],
      },
    );

    when(mockNetworkClient.get('/onecall',
            queryParameters: anyNamed('queryParameters')))
        .thenAnswer((_) async => response);

    final result = await datasource.getWeather(10.76, 106.66);

    expect(result, isA<Success<WeatherModel>>());
    final weather = (result as Success<WeatherModel>).data;
    expect(weather.currentWeather.temperature, 30.0);
    expect(weather.locationName, 'Asia/Ho_Chi_Minh');
    expect(weather.dailyWeathers.length, 2);
    expect(
        weather.dailyWeathers[0].date.copyWithoutTime, DateTime(2025, 4, 22));
    expect(weather.dailyWeathers[0].avgTemperature, 30.0);
    expect(
        weather.dailyWeathers[1].date.copyWithoutTime, DateTime(2025, 4, 23));
    expect(weather.dailyWeathers[1].avgTemperature, 31.0);
  });

  test('getWeather should return GeneralFailure on API error', () async {
    final response = Response(
      requestOptions: RequestOptions(path: '/onecall'),
      statusCode: 401,
      data: {'cod': '401', 'message': 'Invalid API key'},
    );
    when(mockNetworkClient.get(
      '/onecall',
      queryParameters: anyNamed('queryParameters'),
    )).thenAnswer((_) async => response);

    final result = await datasource.getWeather(10.76, 106.66);

    expect(result, isA<Error>());
    expect((result as Error).error, isA<GeneralFailure>());
  });

  test('getWeather should return GeneralFailure on Dio error', () async {
    when(mockNetworkClient.get(
      '/onecall',
      queryParameters: anyNamed('queryParameters'),
    )).thenThrow(DioException(
      requestOptions: RequestOptions(path: '/onecall'),
      type: DioExceptionType.connectionTimeout,
    ));

    final result = await datasource.getWeather(10.76, 106.66);

    expect(result, isA<Error>());
    expect((result as Error).error, isA<GeneralFailure>());
  });
}
