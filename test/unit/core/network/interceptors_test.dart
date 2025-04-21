import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/network/interceptors.dart';

import 'interceptors_test.mocks.dart';

@GenerateMocks([Dio, ErrorInterceptorHandler])
void main() {
  late MockDio mockDio;
  late RetryInterceptor retryInterceptor;
  late MockErrorInterceptorHandler mockHandler;

  setUp(() {
    mockDio = MockDio();
    retryInterceptor = RetryInterceptor(dio: mockDio, maxRetries: 3);
    mockHandler = MockErrorInterceptorHandler();
  });

  test('should retry on connectionTimeout error and succeed', () async {
    final options = RequestOptions(path: '/weather')..extra['retry_count'] = 0;
    final exception = DioException(
      requestOptions: options,
      type: DioExceptionType.connectionTimeout,
    );

    final response = Response(
      requestOptions: options,
      statusCode: 200,
      data: 'ok',
    );

    when(mockDio.fetch(any)).thenAnswer((_) async => response);

    await retryInterceptor.onError(exception, mockHandler);

    verify(mockDio.fetch(any)).called(1);
    verify(mockHandler.resolve(response)).called(1);
    verifyNever(mockHandler.reject(exception));
  });

  test('should not retry if maxRetries is exceeded', () async {
    final options = RequestOptions(path: '/weather')..extra['retry_count'] = 3;
    final exception = DioException(
      requestOptions: options,
      type: DioExceptionType.connectionTimeout,
    );

    await retryInterceptor.onError(exception, mockHandler);

    verifyNever(mockDio.fetch(any));
    verify(mockHandler.reject(exception)).called(1);
  });

  test('should retry on 500 status code error', () async {
    final options = RequestOptions(path: '/weather')..extra['retry_count'] = 0;

    final response500 = Response(
      requestOptions: options,
      statusCode: 500,
    );

    final exception = DioException(
      requestOptions: options,
      response: response500,
      type: DioExceptionType.badResponse,
    );

    final response = Response(
      requestOptions: options,
      statusCode: 200,
      data: 'success',
    );

    when(mockDio.fetch(any)).thenAnswer((_) async => response);

    await retryInterceptor.onError(exception, mockHandler);

    verify(mockDio.fetch(any)).called(1);
    verify(mockHandler.resolve(response)).called(1);
  });
}
