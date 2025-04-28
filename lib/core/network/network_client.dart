import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:weather_app/core/network/interceptors.dart';
import 'package:weather_app/core/utils/constants.dart';

class NetworkClient {
  final Dio dio;
  final String baseUrl;

  NetworkClient({
    this.baseUrl = WEATHER_API_BASE_URL,
    Map<String, dynamic>? defaultQueryParameters,
    Map<String, String>? defaultHeaders,
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 10),
  }) : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          queryParameters: defaultQueryParameters ??
              {
                'appid': WEATHER_API_KEY,
                'units': 'metric',
              },
          headers: defaultHeaders ?? {'Accept': 'application/json'},
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
        )) {
    dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (message) => log("Dio: $message"),
      ),
      CustomHeaderInterceptor(),
    ]);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.delete<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
