# weather_app

A Flutter Weather app displaying current temperature, location, and a 4-day forecast via OpenWeatherMap One Call API.

## Setup
1. Clone the repository.
2. Using Flutter `3.27.4`, Dart `>=3.0.2 <4.0.0`
3. Configure platforms:
    - **iOS**: Update `ios/Podfile` for iOS 12+ and run `pod install` in the `ios` directory.
    - **Android**: Set `minSdkVersion 24` in `android/app/build.gradle`.
4. Run `flutter pub get` to install dependencies (support iOS version 12+ and Android SDK version 24+):
    - cupertino_icons: ^1.0.2
    - flutter_bloc: ^8.1.3
    - equatable: ^2.0.5
    - get: ^4.6.6
    - dio: ^5.4.0
    - permission_handler: ^10.2.0
    - geolocator: ^10.1.0
    - intl: ^0.19.0
5. Configure platform permissions:
    - **iOS**: Add `NSLocationWhenInUseUsageDescription` in `ios/Runner/Info.plist`.
    - **Android**: Add `ACCESS_FINE_LOCATION` and `ACCESS_COARSE_LOCATION` in `android/app/src/main/AndroidManifest.xml`.
6. Add OpenWeatherMap API key to `lib/core/utils/constants.dart` with:
    ```dart
    const String WEATHER_API_KEY = 'YOUR_API_KEY';
    const String WEATHER_API_BASE_URL = 'https://api.openweathermap.org/data/3.0';
    ```
7. Generate mocks for tests: `flutter pub run build_runner build --delete-conflicting-outputs`.
8. Grant location permissions when prompted (Android: enable GPS and allow location access).

## Setup Notes
- Platform permissions are configured separately to enable location-based weather features.

## Architecture
- Follows Clean Architecture with strict layer separation and dependency rules.
- Core includes:
    - `Failure`: Error handling extend `Equatable` (default display message: "Something went wrong at our end!").
    - `Parser`: Robust JSON parsing with type-safe extensions.
    - `NetworkClient`: Scalable Dio setup (get, post, put, delete methods, interceptors for headers/logging).
    - Use Cases:
        - `Usecase<Type, Params>`: Base class for async operations
    - `LocationService`: Manages location access with two functions:
        - `requestLocationPermission`: Requests/checks location permissions, throwing exceptions.
        - `getCurrentLocation`: Fetches device coordinates with a 10-second timeout.
    - `AppTheme`: Defines light theme with centralized `AppColors`
    - `Result<T>`: Generic wrapper for success/error handling
- App: 
    - Uses `GetX` for dependency injection, initialized in `lib/app/di/dependencies.dart`.
    - `main.dart`: Entry point, applies theme, and renders `WeatherScreen` with `WeatherCubit`.
- Features/Weather:
    - Domain:
        - `Weather`: Entity for current temperature, location, and 4-day forecast.
        - `Location`: Entity for geographical coordinates with validation and conversion utilities.
        - `WeatherRepository`: Interface for weather data.
        - `GetWeather`: Use case to fetch weather using Location entity.
    - Data:
        - `WeatherModel`: Maps `One Call` API responses with `toEntity()`, using `CurrentWeatherModel` and `DailyWeatherModel` for nested parsing.
        - `WeatherRemoteDataSource`: Fetches weather via API, handles general error.
        - `WeatherRepositoryImpl`: Implements repository, converting `WeatherModel` to `Weather`.
    - Presentation:
        - `WeatherCubit`: Manages state for weather fetching with direct method calls, integrates `LocationService`.
        - `WeatherState`: States extend `Equatable` for proper comparison:
            - `WeatherInitial`: Initial state
            - `WeatherLoading`: Loading state during data fetch
            - `WeatherLoaded`: Success state with weather data
            - `WeatherError`: Error state with failure details
        - `WeatherScreen`: Displays loading, weather, or error states using `BlocBuilder`.
        - Widgets: 
            - `WeatherInfoWidget`: Shows temperature, location, and 4-day forecast with slide animation.
            - `WeatherErrorWidget`: Displays error with retry button.
            - `LoadingWidget`: Shows rotating loading icon.

## Running the App
- Analyze: `flutter analyze`
- Test: `flutter test test_file_name.dart`
- Run: `flutter run`

