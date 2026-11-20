import 'package:flutter_test/flutter_test.dart';
import 'package:smart_kja/data/models/sensor_data.dart';
import 'package:smart_kja/core/utils/date_formatter.dart';

void main() {
  group('Smart KJA Water Quality & Model Tests', () {
    test('WaterStatus parsing from string matches firmware expectations', () {
      expect(WaterStatusExtension.fromString('AMAN'), WaterStatus.aman);
      expect(WaterStatusExtension.fromString('WASPADA'), WaterStatus.waspada);
      expect(WaterStatusExtension.fromString('BAHAYA'), WaterStatus.bahaya);
      expect(WaterStatusExtension.fromString(null), WaterStatus.aman);
    });

    test('SensorData.fromMap correctly parses values from Firebase RTDB format', () {
      final map = {
        'suhu': 28.5,
        'do': 6.80,
        'turbidity': 12.0,
        'jarak': 45.2,
        'status': 'AMAN',
        'waktu': '2026-10-11 22:30:15',
      };

      final data = SensorData.fromMap(map);

      expect(data.suhu, 28.5);
      expect(data.doValue, 6.80);
      expect(data.turbidity, 12.0);
      expect(data.jarak, 45.2);
      expect(data.status, WaterStatus.aman);
      expect(data.nodeId, 'ID01');
    });

    test('DateFormatter handles Indonesian decimal comma formatting', () {
      expect(DateFormatter.formatDecimal(28.5, fractionDigits: 1), '28,5');
      expect(DateFormatter.formatDecimal(6.80, fractionDigits: 2), '6,80');
    });

    test('DateFormatter gracefully detects uncalibrated RTC (Year 2000)', () {
      final dt = DateFormatter.tryParseDateTime('2000-01-01 03:46:18');
      expect(dt, isNotNull);
      expect(DateFormatter.isUncalibratedRTC(dt), isTrue);
      expect(DateFormatter.formatFull('2000-01-01 03:46:18'), contains('Waktu tidak valid'));
    });
  });
}
