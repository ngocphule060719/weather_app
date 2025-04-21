import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/core/utils/error_utils.dart';

void main() {
  group('ErrorParser', () {
    group('parseDioError', () {
      test('returns connection timeout message', () {
        final error = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        final result = ErrorParser.parseDioError(error);
        expect(result, 'Connection timeout. Please check your internet.');
      });

      test('returns server error message with status code', () {
        final error = DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: ''),
          ),
          requestOptions: RequestOptions(path: ''),
        );

        final result = ErrorParser.parseDioError(error);
        expect(result, 'Server error: 500');
      });

      test('returns generic network error', () {
        final error = DioException(
          type: DioExceptionType.cancel,
          message: 'Request cancelled',
          requestOptions: RequestOptions(path: ''),
        );

        final result = ErrorParser.parseDioError(error);
        expect(result, 'Network error: Request cancelled');
      });
    });

    group('parseApiError', () {
      test('returns formatted API error', () {
        final response = {
          'cod': 404,
          'message': 'Not Found',
        };

        final result = ErrorParser.parseApiError(response);
        expect(result, 'API error [404]: Not Found');
      });
    });

    group('parseLocationError', () {
      test('returns permission denied message', () {
        final error = const PermissionDeniedException('Permission denied');

        final result = ErrorParser.parseLocationErrror(error);
        expect(result, 'Location permission denied. Please enable location services.');
      });

      test('returns service disabled message', () {
        final error = const LocationServiceDisabledException();

        final result = ErrorParser.parseLocationErrror(error);
        expect(result, 'Location services are disabled. Please enable GPS.');
      });

      test('returns unknown error message', () {
        final error = Exception('Some random exception');

        final result = ErrorParser.parseLocationErrror(error);
        expect(result, 'Location error: Exception: Some random exception');
      });
    });
  });
}