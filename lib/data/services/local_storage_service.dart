import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../models/sensor_data.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // Cache latest sensor data for offline view (FR-11)
  Future<void> cacheSensorData(SensorData data) async {
    final jsonStr = jsonEncode(data.toMap());
    await _prefs.setString(AppConstants.keyCachedSensorData, jsonStr);
  }

  SensorData? getCachedSensorData() {
    final jsonStr = _prefs.getString(AppConstants.keyCachedSensorData);
    if (jsonStr == null) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<dynamic, dynamic>;
      return SensorData.fromMap(map);
    } catch (_) {
      return null;
    }
  }

  // Theme preference ('light', 'dark', 'system')
  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(AppConstants.keyThemeMode, mode);
  }

  String getThemeMode() {
    return _prefs.getString(AppConstants.keyThemeMode) ?? 'system';
  }

  // Notification toggle
  Future<void> setNotificationEnabled(bool enabled) async {
    await _prefs.setBool(AppConstants.keyNotificationEnabled, enabled);
  }

  bool isNotificationEnabled() {
    return _prefs.getBool(AppConstants.keyNotificationEnabled) ?? true;
  }
}
