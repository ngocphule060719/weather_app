class Parser {
  static String asString(dynamic value, {String defaultValue = ''}) {
    try {
      if (value == null) return defaultValue;
      if (value is String) return value;
      return value.toString();
    } catch (_) {
      return defaultValue;
    }
  }

  static String? asStringOrNull(dynamic value) {
    try {
      if (value == null) return null;
      if (value is String) return value;
      return value.toString();
    } catch (_) {
      return null;
    }
  }

  static int asInt(dynamic value, {int defaultValue = 0}) {
    try {
      if (value == null) return defaultValue;
      if (value is int) return value;
      return int.parse(value.toString());
    } catch (_) {
      return defaultValue;
    }
  }

  static int? asIntOrNull(dynamic value) {
    try {
      if (value == null) return null;
      if (value is int) return value;
      return int.tryParse(value.toString());
    } catch (_) {
      return null;
    }
  }

  static double asDouble(dynamic value, {double defaultValue = 0.0}) {
    try {
      if (value == null) return defaultValue;
      if (value is num) return value.toDouble();
      return double.parse(value.toString());
    } catch (_) {
      return defaultValue;
    }
  }

  static double? asDoubleOrNull(dynamic value) {
    try {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    } catch (_) {
      return null;
    }
  }

  static DateTime asDateTime(dynamic value, {DateTime? defaultValue}) {
    try {
      if (value == null) return defaultValue ?? DateTime.now();
      final dateStr = value.toString();
      if (dateStr.isEmpty) return defaultValue ?? DateTime.now();
      return DateTime.parse(dateStr);
    } catch (_) {
      return defaultValue ?? DateTime.now();
    }
  }

  static DateTime? asDateTimeOrNull(dynamic value) {
    try {
      if (value == null) return null;
      final dateStr = value.toString();
      if (dateStr.isEmpty) return null;
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic> asMap(
    dynamic value, {
    Map<String, dynamic> defaultValue = const {},
  }) {
    try {
      if (value is Map<String, dynamic>) return Map.from(value);
      if (value is Map<dynamic, dynamic>) {
        return {for (final k in value.keys) k.toString(): value[k]};
      }
      return defaultValue;
    } catch (_) {
      return defaultValue;
    }
  }

  static Map<String, dynamic>? asMapOrNull(dynamic value) {
    try {
      if (value is Map<String, dynamic>) return Map.from(value);
      if (value is Map<dynamic, dynamic>) {
        return {for (final k in value.keys) k.toString(): value[k]};
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static List<Map<String, dynamic>> asListMap(
    dynamic value, {
    List<Map<String, dynamic>> defaultValue = const [],
  }) {
    try {
      if (value is List<dynamic>) {
        return value
            .map((e) => asMap(e, defaultValue: {}))
            .toList()
            .cast<Map<String, dynamic>>();
      }
      return defaultValue;
    } catch (_) {
      return defaultValue;
    }
  }

  static List<Map<String, dynamic>>? asListMapOrNull(dynamic value) {
    try {
      if (value is List<dynamic>) {
        return value
            .map((e) => asMap(e, defaultValue: {}))
            .toList()
            .cast<Map<String, dynamic>>();
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

extension MapParser on Map<String, dynamic> {
  String parseString(String key, {String defaultValue = ''}) {
    return Parser.asString(this[key], defaultValue: defaultValue);
  }

  String? parseStringOrNull(String key) {
    return Parser.asStringOrNull(this[key]);
  }

  int parseInt(String key, {int defaultValue = 0}) {
    return Parser.asInt(this[key], defaultValue: defaultValue);
  }

  int? parseIntOrNull(String key) {
    return Parser.asIntOrNull(this[key]);
  }

  double parseDouble(String key, {double defaultValue = 0.0}) {
    return Parser.asDouble(this[key], defaultValue: defaultValue);
  }

  double? parseDoubleOrNull(String key) {
    return Parser.asDoubleOrNull(this[key]);
  }

  DateTime parseDateTime(String key, {DateTime? defaultValue}) {
    return Parser.asDateTime(this[key], defaultValue: defaultValue);
  }

  DateTime? parseDateTimeOrNull(String key) {
    return Parser.asDateTimeOrNull(this[key]);
  }

  Map<String, dynamic> parseMap(String key,
      {Map<String, dynamic> defaultValue = const {}}) {
    return Parser.asMap(this[key], defaultValue: defaultValue);
  }

  Map<String, dynamic>? parseMapOrNull(String key) {
    return Parser.asMapOrNull(this[key]);
  }

  List<Map<String, dynamic>> parseListMap(
    String key, {
    List<Map<String, dynamic>> defaultValue = const [],
  }) {
    return Parser.asListMap(this[key], defaultValue: defaultValue);
  }

  List<Map<String, dynamic>>? parseListMapOrNull(String key) {
    return Parser.asListMapOrNull(this[key]);
  }
}
