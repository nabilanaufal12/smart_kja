import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../../data/models/water_status.dart';

class SensorHelpers {
  SensorHelpers._();

  static Color getStatusColor(WaterStatus status) {
    switch (status) {
      case WaterStatus.aman:
        return AppColors.statusSafe;
      case WaterStatus.waspada:
        return AppColors.statusWarning;
      case WaterStatus.bahaya:
        return AppColors.statusDanger;
    }
  }

  static List<Color> getStatusGradient(WaterStatus status) {
    switch (status) {
      case WaterStatus.aman:
        return AppColors.safeGradient;
      case WaterStatus.waspada:
        return AppColors.warningGradient;
      case WaterStatus.bahaya:
        return AppColors.dangerGradient;
    }
  }

  static IconData getStatusIcon(WaterStatus status) {
    switch (status) {
      case WaterStatus.aman:
        return Icons.verified_user_rounded;
      case WaterStatus.waspada:
        return Icons.warning_rounded;
      case WaterStatus.bahaya:
        return Icons.error_rounded;
    }
  }
}
