import 'package:flutter/foundation.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/models/sensor_data.dart';
import '../data/repositories/sensor_repository.dart';
import '../core/utils/date_formatter.dart';

enum ChartPeriod { hours24, days7 }
enum SensorParameter { suhu, doVal, turbidity }

class ChartViewModel extends ChangeNotifier {
  final SensorRepository _sensorRepository;

  List<SensorData> _allData = [];
  bool _isLoading = false;
  String? _errorMessage;

  ChartPeriod _selectedPeriod = ChartPeriod.hours24;
  SensorParameter _selectedParameter = SensorParameter.suhu;

  ChartViewModel(this._sensorRepository) {
    loadChartData();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ChartPeriod get selectedPeriod => _selectedPeriod;
  SensorParameter get selectedParameter => _selectedParameter;

  void setPeriod(ChartPeriod period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  void setParameter(SensorParameter parameter) {
    _selectedParameter = parameter;
    notifyListeners();
  }

  Future<void> loadChartData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allData = await _sensorRepository.getHistory(limit: 100);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat data grafik: ${e.toString()}';
      notifyListeners();
    }
  }

  List<SensorData> get filteredData {
    if (_allData.isEmpty) return [];

    final now = DateTime.now();
    final cutoff = _selectedPeriod == ChartPeriod.hours24
        ? now.subtract(const Duration(hours: 24))
        : now.subtract(const Duration(days: 7));

    var list = _allData.where((d) {
      final dt = DateFormatter.tryParseDateTime(d.waktu);
      if (dt == null || DateFormatter.isUncalibratedRTC(dt)) return true;
      return dt.isAfter(cutoff);
    }).toList();

    // If recent points in current 24h/7d period are < 2 (e.g., historical demo dataset),
    // fallback to latest session entries so the chart renders rich telemetry curves!
    if (list.length < 2) {
      final takeCount = _selectedPeriod == ChartPeriod.hours24 ? 15 : 30;
      list = _allData.take(takeCount).toList();
    }

    // Chronological order for chart line
    list.sort((a, b) => a.waktu.compareTo(b.waktu));
    return list;
  }

  List<FlSpot> get spots {
    final data = filteredData;
    if (data.isEmpty) return [];

    return List.generate(data.length, (index) {
      final item = data[index];
      double val = 0.0;
      switch (_selectedParameter) {
        case SensorParameter.suhu:
          val = item.suhu;
          break;
        case SensorParameter.doVal:
          val = item.doValue;
          break;
        case SensorParameter.turbidity:
          val = item.turbidity;
          break;
      }
      return FlSpot(index.toDouble(), val);
    });
  }

  // Statistics
  double get minValue {
    final list = spots.map((s) => s.y).toList();
    if (list.isEmpty) return 0.0;
    return list.reduce((a, b) => a < b ? a : b);
  }

  double get maxValue {
    final list = spots.map((s) => s.y).toList();
    if (list.isEmpty) return 0.0;
    return list.reduce((a, b) => a > b ? a : b);
  }

  double get avgValue {
    final list = spots.map((s) => s.y).toList();
    if (list.isEmpty) return 0.0;
    final sum = list.reduce((a, b) => a + b);
    return sum / list.length;
  }
}
