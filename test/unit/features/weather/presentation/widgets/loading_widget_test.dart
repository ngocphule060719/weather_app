import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/theme/app_theme.dart';
import 'package:weather_app/features/weather/presentation/widgets/loading_widget.dart';

void main() {
  testWidgets('LoadingWidget displays rotating image',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: const Scaffold(
          body: LoadingWidget(),
        ),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(RotationTransition), findsAtLeastNWidgets(1));
  });
}
