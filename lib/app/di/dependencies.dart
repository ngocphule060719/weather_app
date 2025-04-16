import 'package:get/get.dart';
import 'package:weather_app/core/network/network_client.dart';

class Dependencies {
  static void init() {
    Get.lazyPut(() => NetworkClient(), fenix: true);
  }
}