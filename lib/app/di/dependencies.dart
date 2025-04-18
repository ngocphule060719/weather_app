import 'package:get/get.dart';
import 'package:weather_app/core/network/network_client.dart';
import 'package:weather_app/core/services/location_service.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source_impl.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather.dart';

class Dependencies {
  static void init() {
    Get.lazyPut<NetworkClient>(() => NetworkClient(), fenix: true);
    Get.lazyPut<LocationService>(() => LocationService(), fenix: true);
    Get.lazyPut<WeatherRemoteDataSource>(
      () => WeatherRemoteDataSourceImpl(networkClient: Get.find()),
      fenix: true,
    );
    Get.lazyPut<WeatherRepository>(
      () => WeatherRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );
    Get.lazyPut<GetWeather>(
      () => GetWeather(repository: Get.find()),
      fenix: true,
    );
  }
}
