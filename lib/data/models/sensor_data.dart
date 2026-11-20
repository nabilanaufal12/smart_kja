import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import 'water_status.dart';
export 'water_status.dart';

class SensorData {
  final String? id;
  final String nodeId;
  final double suhu;
  final double doValue;
  final double turbidity;
  final double jarak;
  final WaterStatus status;
  final String waktu;

  const SensorData({
    this.id,
    this.nodeId = AppConstants.defaultNodeId,
    required this.suhu,
    required this.doValue,
    required this.turbidity,
    required this.jarak,
    required this.status,
    required this.waktu,
  });

  /// Factory constructor to parse JSON / Map from Firebase RTDB
  factory SensorData.fromMap(Map<dynamic, dynamic> map, [String? docId]) {
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    final rawStatus = map['status']?.toString();
    final rawWaktu = map['waktu']?.toString() ?? '';
    final rawNodeId = map['nodeId']?.toString() ?? AppConstants.defaultNodeId;

    return SensorData(
      id: docId,
      nodeId: rawNodeId,
      suhu: parseDouble(map['suhu']),
      doValue: parseDouble(map['do']),
      turbidity: parseDouble(map['turbidity']),
      jarak: parseDouble(map['jarak']),
      status: WaterStatusExtension.fromString(rawStatus),
      waktu: rawWaktu,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nodeId': nodeId,
      'suhu': suhu,
      'do': doValue,
      'turbidity': turbidity,
      'jarak': jarak,
      'status': status.label,
      'waktu': waktu,
    };
  }

  /// Checks if data is fresh (within 20 minutes)
  bool get isFresh {
    final dt = DateFormatter.tryParseDateTime(waktu);
    if (dt == null || DateFormatter.isUncalibratedRTC(dt)) return false;
    final diff = DateTime.now().difference(dt);
    return !diff.isNegative && diff <= AppConstants.dataFreshnessThreshold;
  }

  SensorData copyWith({
    String? id,
    String? nodeId,
    double? suhu,
    double? doValue,
    double? turbidity,
    double? jarak,
    WaterStatus? status,
    String? waktu,
  }) {
    return SensorData(
      id: id ?? this.id,
      nodeId: nodeId ?? this.nodeId,
      suhu: suhu ?? this.suhu,
      doValue: doValue ?? this.doValue,
      turbidity: turbidity ?? this.turbidity,
      jarak: jarak ?? this.jarak,
      status: status ?? this.status,
      waktu: waktu ?? this.waktu,
    );
  }
}
