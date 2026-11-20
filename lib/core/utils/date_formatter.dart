import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _indonesianDateFormat =
      DateFormat('d MMM yyyy, HH:mm', 'id_ID');
  static final DateFormat _timeOnlyFormat = DateFormat('HH:mm', 'id_ID');
  static final DateFormat _dateOnlyFormat = DateFormat('d MMM yyyy', 'id_ID');

  static String formatDate(DateTime dt) => _dateOnlyFormat.format(dt);

  /// Parse timestamp string from Firebase: "YYYY-MM-DD HH:mm:ss" or similar
  static DateTime? tryParseDateTime(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final clean = raw.trim().replaceAll(',', '');
    try {
      return DateTime.parse(clean);
    } catch (_) {
      try {
        final parts = clean.split(' ');
        if (parts.length >= 2) {
          final dateParts = parts[0].split('-');
          final timeParts = parts[1].split(':');
          if (dateParts.length == 3 && timeParts.length >= 2) {
            return DateTime(
              int.parse(dateParts[0]),
              int.parse(dateParts[1]),
              int.parse(dateParts[2]),
              int.parse(timeParts[0]),
              int.parse(timeParts[1]),
              timeParts.length > 2 ? int.parse(timeParts[2]) : 0,
            );
          }
        }
      } catch (_) {}
    }
    return null;
  }

  /// Checks if timestamp is invalid or uncalibrated (e.g. year 2000 from default RTC)
  static bool isUncalibratedRTC(DateTime? dt) {
    if (dt == null) return true;
    return dt.year <= 2005;
  }

  /// Formats date for display, handling invalid RTC gracefully
  static String formatFull(String? raw) {
    final dt = tryParseDateTime(raw);
    if (dt == null) return raw ?? '-';
    if (isUncalibratedRTC(dt)) return 'Waktu tidak valid ($raw)';
    try {
      return _indonesianDateFormat.format(dt);
    } catch (_) {
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    }
  }

  /// Formats time only (HH:mm)
  static String formatTime(String? raw) {
    final dt = tryParseDateTime(raw);
    if (dt == null) return '-';
    if (isUncalibratedRTC(dt)) return 'N/A';
    try {
      return _timeOnlyFormat.format(dt);
    } catch (_) {
      return '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    }
  }

  /// Relative freshness text (e.g. "5 menit lalu", "Baru saja", etc.)
  static String formatFreshness(String? raw) {
    final dt = tryParseDateTime(raw);
    if (dt == null || isUncalibratedRTC(dt)) return 'Waktu tidak valid';

    final diff = DateTime.now().difference(dt);
    if (diff.isNegative) return 'Baru saja';
    if (diff.inSeconds < 60) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return formatFull(raw);
  }

  /// Format decimal numbers using Indonesian separator (comma)
  static String formatDecimal(double value, {int fractionDigits = 1}) {
    return value.toStringAsFixed(fractionDigits).replaceAll('.', ',');
  }
}
