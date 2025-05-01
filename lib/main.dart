import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/di/dependencies.dart';
import 'package:weather_app/core/theme/app_theme.dart';
import 'package:weather_app/features/weather/presentation/cubit/weather_cubit.dart';
import 'package:weather_app/features/weather/presentation/pages/weather_screen.dart';

void main() {
  Dependencies.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: BlocProvider(
        create: (context) => WeatherCubit(
          getWeather: Get.find(),
          locationService: Get.find(),
        )..fetchWeather(),
        child: const WeatherScreen(),
      ),
    );
  }
}
