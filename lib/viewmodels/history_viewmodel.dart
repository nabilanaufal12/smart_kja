import 'package:flutter/foundation.dart';
import '../data/models/sensor_data.dart';
import '../data/repositories/sensor_repository.dart';
import '../core/utils/date_formatter.dart';

class HistoryViewModel extends ChangeNotifier {
  final SensorRepository _sensorRepository;

  List<SensorData> _historyList = [];
  bool _isLoading = false;
  String? _errorMessage;

  DateTime? _startDate;
  DateTime? _endDate;

  HistoryViewModel(this._sensorRepository) {
    fetchHistory();
  }

  List<SensorData> get historyList => _getFilteredList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  bool get isFiltered => _startDate != null || _endDate != null;

  Future<void> fetchHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _historyList = await _sensorRepository.getHistory(limit: 50);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat riwayat data: ${e.toString()}';
      notifyListeners();
    }
  }

  void setFilter({DateTime? start, DateTime? end}) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  void resetFilter() {
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  List<SensorData> _getFilteredList() {
    if (_startDate == null && _endDate == null) {
      return _historyList;
    }

    return _historyList.where((item) {
      final itemDate = DateFormatter.tryParseDateTime(item.waktu);
      if (itemDate == null) return true;

      if (_startDate != null) {
        final startBoundary = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
        if (itemDate.isBefore(startBoundary)) return false;
      }

      if (_endDate != null) {
        final endBoundary = DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59);
        if (itemDate.isAfter(endBoundary)) return false;
      }

      return true;
    }).toList();
  }

  /// Generates CSV content formatted identically to SD Card log (FR-15)
  String generateCsvContent() {
    final buffer = StringBuffer();
    buffer.writeln('Tanggal,Jam,Suhu,DO,Turbidity,Status');

    for (final item in historyList) {
      final parts = item.waktu.split(' ');
      final tanggal = parts.isNotEmpty ? parts[0] : '';
      final jam = parts.length > 1 ? parts[1] : '';

      buffer.writeln('$tanggal,$jam,${item.suhu},${item.doValue},${item.turbidity},${item.status.name.toUpperCase()}');
    }

    return buffer.toString();
  }
}
