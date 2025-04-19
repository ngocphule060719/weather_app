import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/theme/app_theme.dart';
import 'package:weather_app/features/weather/presentation/widgets/error_widget.dart';

void main() {
  testWidgets('WeatherErrorWidget displays error message and retry button',
      (WidgetTester tester) async {
    const failure = GeneralFailure('API error');
    var retryCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: Scaffold(
          body: WeatherErrorWidget(
            failure: failure,
            onRetry: () => retryCalled = true,
          ),
        ),
      ),
    );

    expect(find.text(failure.defaultDisplayMessage), findsOneWidget);
    expect(find.text('RETRY'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    expect(retryCalled, isTrue);
  });
}
