# 🌊 SMART KJA (Smart Keramba Jaring Apung)
> **Sistem Monitoring Kualitas Air Budidaya Ikan Keramba Jaring Apung Berbasis IoT, LoRa, & Flutter Mobile**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-RTDB-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Architecture](https://img.shields.io/badge/Architecture-MVVM%20%2B%20Provider-4CAF50)](#arsitektur-aplikasi)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## 📌 Ringkasan Proyek
**SMART KJA** adalah aplikasi pemantauan kualitas perairan budidaya Keramba Jaring Apung (KJA) secara *real-time*. Sistem ini menghubungkan node sensor pemantau perairan di keramba terapung melalui komunikasi nirkabel jarak jauh (**LoRa SX1278 433 MHz**) ke gateway darat, yang kemudian disinkronisasikan ke **Firebase Realtime Database** untuk ditampilkan ke petambak melalui aplikasi mobile dengan antarmuka modern (**Stitch Lake Design**).

---

## 🚀 Fitur Utama

1. **Dashboard Telemetri Real-time (Live Monitoring)**
   - Pembacaan sensor air otomatis tanpa jeda (*stream-based*).
   - Indikator status perairan cerdas: **AMAN (Optimal)**, **WASPADA (Perhatian)**, dan **BAHAYA (Kritis)** sesuai ambang baku mutu budidaya perairan.
   - Mini sparkline grafik tren 6-titik terkini untuk setiap sensor.
   - Diagnostik node IoT: Jarak keramba (*ultrasonic range/telemetry*), kekuatan sinyal LoRa (RSSI), dan status daya baterai/solar cell.

2. **Riwayat & Ekspor Data (History & CSV Export)**
   - Rekam jejak telemetri kualitas air hingga 100+ entri terakhir.
   - Filter berdasarkan rentang tanggal.
   - Ekspor log data ke format **CSV** yang identik dengan rekaman SD Card transmitter untuk analisis akademis / laporan berkala.

3. **Grafik Analisis Tren Interaktif (Analytics Charts)**
   - Visualisasi kurva fluktuasi parameter kualitas air menggunakan `fl_chart`.
   - Filter rentang waktu: **24 Jam** dan **7 Hari**.
   - Parameter terpisah: Suhu Air (°C), Oksigen Terlarut / DO (mg/L), dan Kekeruhan Air (NTU).
   - Ringkasan statistik otomatis: Nilai Minimum, Rata-rata, dan Maksimum.

4. **Keandalan Offline & Resiliensi Jaringan**
   - Cache lokal otomatis (`shared_preferences`) sehingga data pemantauan terakhir tetap dapat diakses petambak saat koneksi internet seluler lemah di area perairan/pesisir.
   - Mode Quick Demo / Evaluasi cepat tanpa harus login berulang.

---

## 🧪 Parameter Kualitas Air yang Dipantau

| Parameter | Sensor | Rentang Aman | Keterangan |
| :--- | :--- | :--- | :--- |
| **Suhu Air** | DS18B20 Waterproof | 27.0 – 32.0 °C | Mempengaruhi metabolisme dan nafsu makan ikan |
| **Dissolved Oxygen (DO)** | Analog DO Sensor | $\ge$ 5.0 mg/L | Krusial untuk respirasi biota tambak |
| **Kekeruhan (Turbidity)** | Optical Turbidity Sensor | $\le$ 25.0 NTU | Menentukan penetrasi cahaya dan suspended solids |
| **Jarak & Level Air** | Ultrasonic Sensor | Dinamis | Mengukur elevasi dan jarak jangkau node keramba |

---

## 🏗️ Arsitektur Aplikasi
Aplikasi dibangun menggunakan pola arsitektur **MVVM (Model - View - ViewModel)** dengan manajemen state **Provider**:

```
lib/
├── core/
│   ├── config/          # Firebase options & platform setup
│   ├── constants/       # AppColors, AppConstants, AppTextStyles
│   ├── theme/           # Light & Dark Theme (Stitch Lake styling)
│   └── utils/           # DateFormatter, SensorHelpers
├── data/
│   ├── models/          # SensorData, WaterStatus
│   ├── repositories/    # SensorRepository, AuthRepository
│   └── services/        # AppFirebaseService, LocalStorageService
├── viewmodels/          # DashboardViewModel, HistoryViewModel, ChartViewModel, AuthViewModel
└── views/
    ├── splash/          # Animated Splash Screen
    ├── auth/            # Login & Register Screen
    ├── dashboard/       # Real-time Telemetry Dashboard & Custom Cards
    ├── history/         # History List, Filter, & CSV Export
    ├── chart/           # Interactive Line Chart & Statistics
    ├── profile/         # Node IoT Diagnostics & Threshold Rules
    └── main_navigation_screen.dart # Persistent Bottom Navigation
```

---

## 🛠️ Panduan Menjalankan Proyek

### Prasyarat
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi $\ge$ 3.13)
- Android Studio / VS Code dengan ekstensi Flutter & Dart
- Perangkat Android (Android 8.0+) atau iOS (iOS 13+)

### Langkah Instalasi
1. Clone repositori ini:
   ```bash
   git clone https://github.com/nabilanaufal12/smart_kja.git
   cd smart_kja
   ```
2. Pasang seluruh dependensi:
   ```bash
   flutter pub get
   ```
3. Hubungkan perangkat fisik via USB atau jalankan emulator:
   ```bash
   flutter devices
   ```
4. Jalankan aplikasi:
   ```bash
   flutter run
   ```

---

## 👨‍💻 Pengembang
- **Nama:** Nabil Ali Naufal
- **GitHub:** [@nabilanaufal12](https://github.com/nabilanaufal12)
- **Topik:** IoT Aquaculture & Environmental Monitoring Systems
