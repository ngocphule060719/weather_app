import 'package:dio/dio.dart';
import 'package:weather_app/core/utils/parser.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  RetryInterceptor({required this.dio, required this.maxRetries});

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final attempt = err.requestOptions._retryCount;
    if (attempt < maxRetries && _shouldRetry(err)) {
      err.requestOptions._retryCount = attempt + 1;
      final response = await dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } else {
      handler.reject(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}

extension on RequestOptions {
  static const _retryCountKey = 'retry_count';

  int get _retryCount => extra.parseInt(_retryCountKey);

  set _retryCount(int value) {
    extra[_retryCountKey] = value;
  }
}

class CustomHeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }
}
