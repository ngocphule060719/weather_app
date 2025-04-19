import 'package:flutter/material.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/theme/app_theme.dart';

class WeatherErrorWidget extends StatelessWidget {
  final Failure failure;
  final VoidCallback onRetry;

  const WeatherErrorWidget({
    super.key,
    required this.failure,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.errorBackground,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                failure.defaultDisplayMessage,
                style: AppTheme.theme.textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 44),
              ElevatedButton(
                key: const Key('retry_button'),
                onPressed: onRetry,
                style: AppTheme.theme.elevatedButtonTheme.style,
                child: const Text('RETRY'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
