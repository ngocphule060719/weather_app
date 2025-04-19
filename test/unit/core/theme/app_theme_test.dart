import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/theme/app_theme.dart';

void main() {
  group('AppColors', () {
    test('scaffoldBackground matches expected color', () {
      expect(AppColors.scaffoldBackground, const Color(0xFFF5F6F7));
    });

    test('textPrimary matches expected color', () {
      expect(AppColors.textPrimary, const Color(0xFF2A2A2A));
    });

    test('textSecondary matches expected color', () {
      expect(AppColors.textSecondary, const Color(0xFF556799));
    });

    test('errorBackground matches expected color', () {
      expect(AppColors.errorBackground, const Color(0xFFE85959));
    });

    test('buttonBackground matches expected color', () {
      expect(AppColors.buttonBackground, const Color(0xFF4A4A4A));
    });

    test('white matches expected color', () {
      expect(AppColors.white, Colors.white);
    });

    test('shadow matches expected color', () {
      expect(AppColors.shadow, const Color(0x14000000));
    });

    test('border matches expected color', () {
      expect(AppColors.border, const Color(0xFFE0E0E0));
    });
  });

  group('AppTheme', () {
    testWidgets('theme applies correct scaffoldBackgroundColor',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: Builder(
            builder: (context) => Material(
              child: Scaffold(
                body: Container(), // Ensure Scaffold renders
              ),
            ),
          ),
        ),
      );

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      final context = tester.element(find.byType(Scaffold));
      expect(
          scaffold.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          AppColors.scaffoldBackground);
    });

    testWidgets('textTheme applies correct displayLarge style',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: Builder(
            builder: (context) => Scaffold(
              body: Text(
                'Temperature',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Temperature'));
      expect(text.style?.fontSize, 96);
      expect(text.style?.color, AppColors.textPrimary);
      expect(text.style?.fontFamily, 'Roboto');
      expect(text.style?.fontWeight, FontWeight.w900);
    });

    testWidgets('textTheme applies correct headlineMedium style',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: Builder(
            builder: (context) => Scaffold(
              body: Text(
                'Location',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Location'));
      expect(text.style?.fontSize, 36);
      expect(text.style?.color, AppColors.textSecondary);
      expect(text.style?.fontFamily, 'Roboto');
      expect(text.style?.fontWeight, FontWeight.w100);
    });

    testWidgets('textTheme applies correct bodyMedium style',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: Builder(
            builder: (context) => Scaffold(
              body: Text(
                'Body',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Body'));
      expect(text.style?.fontSize, 16);
      expect(text.style?.color, AppColors.textPrimary);
      expect(text.style?.fontFamily, 'Roboto');
      expect(text.style?.fontWeight, FontWeight.w400);
    });

    testWidgets('textTheme applies correct displayMedium style',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: Builder(
            builder: (context) => Scaffold(
              body: Text(
                'Error',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Error'));
      expect(text.style?.fontSize, 54);
      expect(text.style?.color, AppColors.white);
      expect(text.style?.fontFamily, 'Roboto');
      expect(text.style?.fontWeight, FontWeight.w100);
    });

    testWidgets('elevatedButtonTheme applies correct styles',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: null,
                style: Theme.of(context).elevatedButtonTheme.style,
                child: const Text('Button'),
              ),
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final style = button.style;
      expect(style?.backgroundColor?.resolve({}), AppColors.buttonBackground);
      expect(style?.foregroundColor?.resolve({}), AppColors.white);
      expect(
        style?.padding?.resolve({}),
        const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      );
      expect(
        style?.shape?.resolve({}),
        isA<RoundedRectangleBorder>().having(
          (s) => s.borderRadius,
          'borderRadius',
          BorderRadius.circular(8),
        ),
      );
      expect(style?.textStyle?.resolve({})?.fontSize, 16);
      expect(style?.textStyle?.resolve({})?.fontFamily, 'Roboto');
      expect(style?.textStyle?.resolve({})?.fontWeight, FontWeight.w400);
    });
  });
}
