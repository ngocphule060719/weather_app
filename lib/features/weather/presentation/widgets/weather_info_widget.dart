import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/core/theme/app_theme.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

class WeatherInfoWidget extends StatelessWidget {
  final Weather weather;

  const WeatherInfoWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCurrentWeatherInfo(context),
        Expanded(
          child: BottomSlideTransition(
            child: DailyWeatherInfoWidget(
              dailyForecasts: weather.dailyForecasts,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentWeatherInfo(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 56),
          Text(
            '${weather.currentTemperature.toStringAsFixed(0)}°',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Text(
            weather.locationName,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 62),
        ],
      ),
    );
  }
}

class DailyWeatherInfoWidget extends StatelessWidget {
  final List<DailyForecast> dailyForecasts;

  const DailyWeatherInfoWidget({super.key, required this.dailyForecasts});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: dailyForecasts
              .map((e) => DailyForecastItem(forecast: e))
              .toList(),
        ),
      ),
    );
  }
}

class DailyForecastItem extends StatelessWidget {
  final DailyForecast forecast;

  const DailyForecastItem({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              DateFormat('EEEE').format(forecast.date),
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${forecast.avgTemperature.toStringAsFixed(0)}°C',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class BottomSlideTransition extends StatefulWidget {
  final Widget child;

  const BottomSlideTransition({super.key, required this.child});

  @override
  State<BottomSlideTransition> createState() => _BottomSlideTransitionState();
}

class _BottomSlideTransitionState extends State<BottomSlideTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child,
    );
  }
}
