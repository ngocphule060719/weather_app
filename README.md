# weather_app

A Flutter weather app

## Setup
1. Clone the repository.
2. Configure platforms:
    - **iOS**: Update `ios/Podfile` for iOS 12+ and run `pod install` in the `ios` directory.
    - **Android**: Set `minSdkVersion 24` in `android/app/build.gradle`.
3. Run `flutter pub get` to install dependencies (support iOS version 12+ and Android SDK version 24+):
    - flutter_bloc: ^8.1.3
    - equatable: ^2.0.5
    - dio: ^5.3.3
    - intl: ^0.18.1
    - permission_handler: ^10.2.0
    - geolocator: ^9.0.2
    - get: ^4.6.6
4. Configure platform permissions:
    - **iOS**: Add `NSLocationWhenInUseUsageDescription` in `ios/Runner/Info.plist`.
    - **Android**: Add `ACCESS_FINE_LOCATION` and `ACCESS_COARSE_LOCATION` in `android/app/src/main/AndroidManifest.xml`.

## Setup Notes
- Platform permissions are configured separately to enable location-based weather features.
