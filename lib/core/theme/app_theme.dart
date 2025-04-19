import 'package:flutter/material.dart';

class AppColors {
  static const scaffoldBackground = Color(0xFFF5F6F7);
  static const textPrimary = Color(0xFF2A2A2A);
  static const textSecondary = Color(0xFF556799);
  static const errorBackground = Color(0xFFE85959);
  static const buttonBackground = Color(0xFF4A4A4A);
  static const white = Colors.white;
  static const shadow = Color(0x14000000);
  static const border = Color(0xFFE0E0E0);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.textSecondary,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 96,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w900,
          ),
          headlineMedium: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 36,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w100,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
          ),
          displayMedium: TextStyle(
            color: AppColors.white,
            fontSize: 54,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w100,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonBackground,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
}
