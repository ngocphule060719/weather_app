import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/utils/datetime_utils.dart';
import 'package:weather_app/core/utils/parser.dart';

void main() {
  group('Parser', () {
    test('asString', () {
      expect(Parser.asString('weather'), 'weather');
      expect(Parser.asString(30), '30');
      expect(Parser.asString(null, defaultValue: 'default'), 'default');
    });

    test('asStringOrNull', () {
      expect(Parser.asStringOrNull('weather'), 'weather');
      expect(Parser.asStringOrNull(30), '30');
      expect(Parser.asStringOrNull(null), null);
    });

    test('asInt', () {
      expect(Parser.asInt('30'), 30);
      expect(Parser.asInt(30), 30);
      expect(Parser.asInt('weather', defaultValue: 30), 30);
      expect(Parser.asInt(null, defaultValue: 30), 30);
    });

    test('asIntOrNull', () {
      expect(Parser.asIntOrNull('30'), 30);
      expect(Parser.asIntOrNull(30), 30);
      expect(Parser.asIntOrNull('weather'), null);
      expect(Parser.asIntOrNull(null), null);
    });

    test('asDouble', () {
      expect(Parser.asDouble('30.1'), 30.1);
      expect(Parser.asDouble(30), 30.0);
      expect(Parser.asDouble('weather', defaultValue: 30.1), 30.1);
      expect(Parser.asDouble(null, defaultValue: 30.1), 30.1);
    });

    test('asDoubleOrNull', () {
      expect(Parser.asDoubleOrNull('30.1'), 30.1);
      expect(Parser.asDoubleOrNull(30), 30.0);
      expect(Parser.asDoubleOrNull('weather'), null);
      expect(Parser.asDoubleOrNull(null), null);
    });

    test('asDateTime', () {
      final dateTime = DateTime(2025, 4, 20);
      expect(Parser.asDateTime('2025-04-20T00:00:00.000'), dateTime);
      expect(Parser.asDateTime(null, defaultValue: dateTime), dateTime);
      expect(Parser.asDateTime('', defaultValue: dateTime), dateTime);
    });

    test('asDateTimeOrNull', () {
      expect(Parser.asDateTimeOrNull('2025-04-20T00:00:00.000'),
          DateTime(2025, 4, 20));
      expect(Parser.asDateTimeOrNull(''), null);
      expect(Parser.asDateTimeOrNull(null), null);
    });

    test('asMap', () {
      expect(Parser.asMap({'temperature': 30}), {'temperature': 30});
      expect(Parser.asMap({'city': 'HoChiMinh'}), {'city': 'HoChiMinh'});
      expect(Parser.asMap('bad', defaultValue: {'temperature': 30}),
          {'temperature': 30});
    });

    test('asMapOrNull', () {
      expect(Parser.asMapOrNull({'temperature': 30}), {'temperature': 30});
      expect(Parser.asMapOrNull({'city': 'HoChiMinh'}), {'city': 'HoChiMinh'});
      expect(Parser.asMapOrNull('bad'), null);
    });

    test('asListMap', () {
      expect(
          Parser.asListMap([
            {'a': 1},
            {2: 'b'}
          ]),
          [
            {'a': 1},
            {'2': 'b'}
          ]);

      expect(Parser.asListMap('bad', defaultValue: []), []);
    });

    test('asListMapOrNull', () {
      expect(
          Parser.asListMapOrNull([
            {'a': 1},
            {2: 'b'}
          ]),
          [
            {'a': 1},
            {'2': 'b'}
          ]);

      expect(Parser.asListMapOrNull('bad'), null);
    });
  });

  group('MapParser Extension', () {
    final map = {
      'temperature': 30,
      'city': 'HoChiMinh',
      'date': DateTime(2025, 4, 20).copyWithoutTime,
      'map': {'a': 1},
      'list': [
        {'x': 1}
      ],
    };

    test('parseString & parseStringOrNull', () {
      expect(map.parseString('city'), 'HoChiMinh');
      expect(map.parseString('missing', defaultValue: 'default'), 'default');
      expect(map.parseStringOrNull('city'), 'HoChiMinh');
      expect(map.parseStringOrNull('missing'), null);
    });

    test('parseInt & parseIntOrNull', () {
      expect(map.parseInt('temperature'), 30);
      expect(map.parseInt('missing', defaultValue: 99), 99);
      expect(map.parseIntOrNull('temperature'), 30);
      expect(map.parseIntOrNull('missing'), null);
    });

    test('parseDouble & parseDoubleOrNull', () {
      expect(map.parseDouble('temperature'), 30.0);
      expect(map.parseDouble('missing', defaultValue: 1.1), 1.1);
      expect(map.parseDoubleOrNull('temperature'), 30.0);
      expect(map.parseDoubleOrNull('missing'), null);
    });

    test('parseDateTime & parseDateTimeOrNull', () {
      final dateTime = DateTime(2025, 4, 20).copyWithoutTime;
      expect(map.parseDateTime('date'), dateTime);
      expect(map.parseDateTime('missing', defaultValue: dateTime), dateTime);
      expect(map.parseDateTimeOrNull('date'), dateTime);
      expect(map.parseDateTimeOrNull('missing'), null);
    });

    test('parseMap & parseMapOrNull', () {
      expect(map.parseMap('map'), {'a': 1});
      expect(map.parseMapOrNull('map'), {'a': 1});
      expect(map.parseMap('missing', defaultValue: {'city': 'HoChiMinh'}),
          {'city': 'HoChiMinh'});
      expect(map.parseMapOrNull('missing'), null);
    });

    test('parseListMap & parseListMapOrNull', () {
      expect(map.parseListMap('list'), [
        {'x': 1}
      ]);
      expect(map.parseListMapOrNull('list'), [
        {'x': 1}
      ]);
      expect(map.parseListMap('missing', defaultValue: []), []);
      expect(map.parseListMapOrNull('missing'), null);
    });
  });
}
