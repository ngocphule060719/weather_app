# weather_app

A Flutter weather app

## Setup
1. Clone the repository.
2. Configure platforms:
    - **iOS**: Create `ios/Podfile` for iOS 12+ and run `pod install` in the `ios` directory.
    - **Android**: Set `minSdkVersion 24` in `android/app/build.gradle`.
3. Run `flutter pub get` to install dependencies (support iOS version 12+ and Android SDK version 24+):
    - flutter_bloc: ^8.1.3
    - equatable: ^2.0.5
    - dio: ^5.3.3
    - intl: ^0.18.1
    - permission_handler: ^10.2.0
    - geolocator: ^9.0.2
    - get: ^4.6.6
