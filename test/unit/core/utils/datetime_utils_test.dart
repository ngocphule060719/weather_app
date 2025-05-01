import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/utils/datetime_utils.dart';

void main() {
  group('DateTimeX extension', () {
    test('copyWithoutTime returns a copy with time fields set to zero', () {
      final date = DateTime(2025, 4, 20, 23, 59, 59, 999, 999);
      final result = date.copyWithoutTime;

      expect(result.year, date.year);
      expect(result.month, date.month);
      expect(result.day, date.day);
      expect(result.hour, 0);
      expect(result.minute, 0);
      expect(result.second, 0);
      expect(result.millisecond, 0);
      expect(result.microsecond, 0);
    });

    test('copyWith overrides specific fields correctly', () {
      final date = DateTime(2024, 4, 20, 12, 30, 0, 0, 0);
      final result = date.copyWith(year: 2025, minute: 45);

      expect(result.year, 2025);
      expect(result.month, 4);
      expect(result.day, 20);
      expect(result.hour, 12);
      expect(result.minute, 45);
      expect(result.second, 0);
    });
  });
}
