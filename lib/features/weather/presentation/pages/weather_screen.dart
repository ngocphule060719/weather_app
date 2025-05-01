import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/weather/presentation/cubit/weather_cubit.dart';
import 'package:weather_app/features/weather/presentation/cubit/weather_state.dart';
import 'package:weather_app/features/weather/presentation/widgets/error_widget.dart';
import 'package:weather_app/features/weather/presentation/widgets/loading_widget.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_info_widget.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) => switch (state) {
          WeatherInitial() || WeatherLoading() => const LoadingWidget(),
          WeatherLoaded(:final weather) => WeatherInfoWidget(
              weather: weather.copyWith(),
            ),
          WeatherError(:final failure) => WeatherErrorWidget(
              failure: failure,
              onRetry: () => context.read<WeatherCubit>().fetchWeather(),
            ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
