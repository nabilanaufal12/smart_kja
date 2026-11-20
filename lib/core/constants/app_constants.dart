/// Global application constants, thresholds, and Firebase references
class AppConstants {
  AppConstants._();

  static const String appName = 'SMART KJA';
  static const String appTagline = 'Pantau Tambakmu, Kapan Saja';
  static const String defaultNodeId = 'ID01';

  // Firebase paths
  static const String monitoringPath = 'monitoring';
  static const String historyPath = 'history';

  // Water Quality Thresholds (Sesuai updateStatus() di receiver.ino)
  // Suhu (°C)
  static const double tempDangerLow = 25.0;
  static const double tempWarningLowMin = 25.0;
  static const double tempWarningLowMax = 27.0;
  static const double tempSafeMin = 27.0;
  static const double tempSafeMax = 32.0;
  static const double tempWarningHighMin = 32.0;
  static const double tempWarningHighMax = 35.0;
  static const double tempDangerHigh = 35.0;

  // Dissolved Oxygen / DO (mg/L)
  static const double doDangerLow = 2.5;
  static const double doWarningMin = 3.0;
  static const double doWarningMax = 5.0;
  static const double doSafeMin = 5.0;

  // Turbidity (skala 0 - 100 NTU)
  static const double turbidityMaxSafe = 25.0;
  static const double turbidityMaxWarning = 50.0;

  // Timeouts & Refresh Intervals
  static const Duration dataFreshnessThreshold = Duration(minutes: 20);
  static const int historyBatchSize = 20;

  // Local Storage Keys
  static const String keyCachedSensorData = 'cached_sensor_data';
  static const String keyThemeMode = 'app_theme_mode';
  static const String keyNotificationEnabled = 'app_notification_enabled';
}
