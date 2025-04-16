import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/di/dependencies.dart';
import 'package:weather_app/core/network/network_client.dart';

void main() {
  test('Dependencies injects NetworkClient', () {
    Dependencies.init();
    final client = Get.find<NetworkClient>();
    expect(client, isA<NetworkClient>());
    Get.deleteAll();
  });
}
