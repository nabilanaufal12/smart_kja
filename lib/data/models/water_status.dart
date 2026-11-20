enum WaterStatus {
  aman,
  waspada,
  bahaya,
}

extension WaterStatusExtension on WaterStatus {
  String get label {
    switch (this) {
      case WaterStatus.aman:
        return 'AMAN';
      case WaterStatus.waspada:
        return 'WASPADA';
      case WaterStatus.bahaya:
        return 'BAHAYA';
    }
  }

  String get description {
    switch (this) {
      case WaterStatus.aman:
        return 'Kualitas air dalam kondisi normal';
      case WaterStatus.waspada:
        return 'Perlu perhatian khusus';
      case WaterStatus.bahaya:
        return 'Segera periksa kondisi tambak!';
    }
  }

  static WaterStatus fromString(String? value) {
    if (value == null) return WaterStatus.aman;
    switch (value.toUpperCase().trim()) {
      case 'BAHAYA':
        return WaterStatus.bahaya;
      case 'WASPADA':
        return WaterStatus.waspada;
      case 'AMAN':
      default:
        return WaterStatus.aman;
    }
  }
}
