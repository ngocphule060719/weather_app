import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/core/utils/parser.dart';

class ErrorParser {
  static String parseDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      default:
        return 'Network error: ${error.message}';
    }
  }

  static String parseApiError(Map<String, dynamic> responseData) {
    final code = responseData.parseInt('cod');
    final message = responseData.parseString('message');
    return 'API error [$code]: $message';
  }

  static String parseLocationErrror(Exception error) {
    if (error is PermissionDeniedException) {
      return 'Location permission denied. Please enable location services.';
    }
    if (error is LocationServiceDisabledException) {
      return 'Location services are disabled. Please enable GPS.';
    }
    return 'Location error: ${error.toString()}';
  }
}
