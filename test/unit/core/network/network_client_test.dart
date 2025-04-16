import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/network/interceptors.dart';
import 'package:weather_app/core/network/network_client.dart';

void main() {
  test('NetworkClient initializes with maxRetries 0', () {
    final client = NetworkClient();
    expect(
        client.dio.interceptors
            .any((i) => i is RetryInterceptor && i.maxRetries == 0),
        isTrue);
  });
}
