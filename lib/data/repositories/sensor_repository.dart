import '../models/sensor_data.dart';
import '../services/firebase_service.dart';
import '../services/local_storage_service.dart';

abstract class SensorRepository {
  Stream<SensorData?> getMonitoringStream();
  Future<SensorData?> getLatestMonitoringData();
  Future<List<SensorData>> getHistory({int limit = 50});
  SensorData? getCachedSensorData();
  Future<void> cacheSensorData(SensorData data);
}

class SensorRepositoryImpl implements SensorRepository {
  final AppFirebaseService _firebaseService;
  final LocalStorageService _localStorageService;

  SensorRepositoryImpl({
    required AppFirebaseService firebaseService,
    required LocalStorageService localStorageService,
  })  : _firebaseService = firebaseService, // ignore: prefer_initializing_formals
        _localStorageService = localStorageService; // ignore: prefer_initializing_formals

  @override
  Stream<SensorData?> getMonitoringStream() {
    return _firebaseService.getMonitoringStream().map((data) {
      if (data != null) {
        // Automatically save to local cache for offline resiliency (FR-11)
        _localStorageService.cacheSensorData(data);
      }
      return data;
    });
  }

  @override
  Future<SensorData?> getLatestMonitoringData() async {
    final data = await _firebaseService.getLatestMonitoringData();
    if (data != null) {
      _localStorageService.cacheSensorData(data);
      return data;
    }
    return _localStorageService.getCachedSensorData();
  }

  @override
  Future<List<SensorData>> getHistory({int limit = 50}) async {
    return await _firebaseService.fetchHistory(limit: limit);
  }

  @override
  SensorData? getCachedSensorData() {
    return _localStorageService.getCachedSensorData();
  }

  @override
  Future<void> cacheSensorData(SensorData data) {
    return _localStorageService.cacheSensorData(data);
  }
}
