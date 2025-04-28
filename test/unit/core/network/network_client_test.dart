import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/core/network/network_client.dart';
import 'package:weather_app/core/network/interceptors.dart';
import 'package:weather_app/core/utils/constants.dart';

void main() {
  late NetworkClient networkClient;

  setUp(() {
    networkClient = NetworkClient();
  });

  test('NetworkClient initializes with default values', () {
    expect(networkClient.baseUrl, equals(WEATHER_API_BASE_URL));
    expect(networkClient.dio.options.baseUrl, equals(WEATHER_API_BASE_URL));
    expect(
        networkClient.dio.options.queryParameters,
        equals({
          'appid': WEATHER_API_KEY,
          'units': 'metric',
        }));
    expect(networkClient.dio.options.headers,
        equals({'Accept': 'application/json'}));
    expect(networkClient.dio.options.connectTimeout,
        equals(const Duration(seconds: 10)));
    expect(networkClient.dio.options.receiveTimeout,
        equals(const Duration(seconds: 10)));
  });

  test('NetworkClient initializes with custom values', () {
    final customClient = NetworkClient(
      baseUrl: WEATHER_API_BASE_URL,
      defaultQueryParameters: {'key': 'value'},
      defaultHeaders: {'Custom': 'Header'},
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    );

    expect(customClient.baseUrl, equals(WEATHER_API_BASE_URL));
    expect(customClient.dio.options.baseUrl, equals(WEATHER_API_BASE_URL));
    expect(customClient.dio.options.queryParameters, equals({'key': 'value'}));
    expect(customClient.dio.options.headers, equals({'Custom': 'Header'}));
    expect(customClient.dio.options.connectTimeout,
        equals(const Duration(seconds: 20)));
    expect(customClient.dio.options.receiveTimeout,
        equals(const Duration(seconds: 20)));
  });

  test('NetworkClient initializes with required interceptors', () {
    final interceptors = networkClient.dio.interceptors;

    // Check for LogInterceptor
    final logInterceptor =
        interceptors.firstWhere((i) => i is LogInterceptor) as LogInterceptor;
    expect(logInterceptor.requestBody, isTrue);
    expect(logInterceptor.responseBody, isTrue);

    // Check for CustomHeaderInterceptor
    expect(interceptors.any((i) => i is CustomHeaderInterceptor), isTrue);
  });
}
