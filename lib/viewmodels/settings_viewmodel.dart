import 'package:flutter/material.dart';
import '../data/services/local_storage_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final LocalStorageService _storageService;

  late ThemeMode _themeMode;
  late bool _notificationEnabled;

  SettingsViewModel(this._storageService) {
    _loadSettings();
  }

  ThemeMode get themeMode => _themeMode;
  bool get notificationEnabled => _notificationEnabled;

  void _loadSettings() {
    final modeStr = _storageService.getThemeMode();
    switch (modeStr) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'system':
      default:
        _themeMode = ThemeMode.system;
        break;
    }

    _notificationEnabled = _storageService.isNotificationEnabled();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    String modeStr = 'system';
    if (mode == ThemeMode.light) modeStr = 'light';
    if (mode == ThemeMode.dark) modeStr = 'dark';
    await _storageService.saveThemeMode(modeStr);
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    _notificationEnabled = enabled;
    notifyListeners();
    await _storageService.setNotificationEnabled(enabled);
  }
}
