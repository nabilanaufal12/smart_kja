import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../profile/water_status_rules_screen.dart';
import 'widgets/status_banner_card.dart';
import 'widgets/sensor_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          backgroundColor: AppColors.surface.withValues(alpha: 0.95),
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 16,
          title: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        AppConstants.appName,
                        style: AppTextStyles.titleMd(color: AppColors.primary).copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.statusSafe.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'LIVE',
                          style: AppTextStyles.labelCaps(color: AppColors.statusSafe).copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'KJA 01 - Pondok 1 • Beranda',
                    style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.notifications_none_rounded, size: 24, color: AppColors.onSurfaceVariant),
                  if (vm.sensorData != null && vm.sensorData!.status.name != 'aman')
                    Positioned(
                      right: 1,
                      top: 1,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.statusDanger,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WaterStatusRulesScreen()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 4),
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => vm.refresh(),
        color: AppColors.primary,
        child: _buildBody(context, vm),
      ),
    );
  }

  Widget _buildBody(BuildContext context, DashboardViewModel vm) {
    if (vm.isLoading && vm.sensorData == null) {
      return _buildLoadingSkeleton();
    }

    if (vm.sensorData == null) {
      return _buildErrorState(context, vm);
    }

    final data = vm.sensorData!;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // 1. Dynamic Blue Header Context (Stitch Lake Context Banner)
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Node Selector & Online Chip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dropdown pill button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.statusSafe,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'KJA 01 - Pondok 1',
                          style: AppTextStyles.bodyMd().copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.expand_more_rounded,
                          size: 18,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),

                  // Online status pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.sensors_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'ONLINE',
                          style: AppTextStyles.labelCaps(color: Colors.white).copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Freshness subtitle
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    color: Colors.white.withValues(alpha: 0.85),
                    size: 15,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Pembaruan: ${DateFormatter.formatFull(data.waktu)} (Real-time)',
                    style: AppTextStyles.bodySm(color: Colors.white.withValues(alpha: 0.85)),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 2. Overlapping Section (Soft Overlap Card)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Transform.translate(
            offset: const Offset(0, -14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Banner Card
                StatusBannerCard(
                  status: data.status,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WaterStatusRulesScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Offline Notice (If applicable)
                if (vm.isOffline) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.statusWarning.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.statusWarning.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cloud_off_rounded, color: AppColors.statusWarning, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Anda sedang offline. Menampilkan data tersimpan terakhir.',
                            style: AppTextStyles.bodySm(color: const Color(0xFFB45309)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Section Header: Parameter Kualitas Air
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Parameter Kualitas Air',
                          style: AppTextStyles.titleMd().copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Semua Data',
                              style: AppTextStyles.bodySm(color: AppColors.primary).copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.trending_up_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 3. Telemetry Sensor Cards Stack (Stitch-aligned)
                // Sensor 1: Suhu Air
                SensorCard(
                  label: 'Suhu Air',
                  safeRange: 'Batas aman: 25.0 – 32.0 °C',
                  value: data.suhu,
                  unit: '°C',
                  icon: Icons.device_thermostat_rounded,
                  accentColor: AppColors.suhuAccent,
                  iconContainerColor: AppColors.errorContainer.withValues(alpha: 0.7),
                  statusChip: data.suhu >= 25.0 && data.suhu <= 32.0 ? 'Normal' : 'Perhatian',
                  statusColor: data.suhu >= 25.0 && data.suhu <= 32.0
                      ? AppColors.statusSafe
                      : AppColors.statusWarning,
                  sparklineData: vm.tempSparkline,
                  trendSubtitle: '±0.2°C dlm 3 jam',
                  fractionDigits: 1,
                ),
                const SizedBox(height: 12),

                // Sensor 2: Oksigen Terlarut (DO)
                SensorCard(
                  label: 'Oksigen Terlarut (DO)',
                  safeRange: 'Batas aman: 5.0 – 8.0 mg/L',
                  value: data.doValue,
                  unit: 'mg/L',
                  icon: Icons.water_drop_rounded,
                  accentColor: AppColors.doAccent,
                  iconContainerColor: AppColors.primaryFixed,
                  statusChip: data.doValue >= 5.0 ? 'Normal' : 'Kritis',
                  statusColor: data.doValue >= 5.0
                      ? AppColors.statusSafe
                      : AppColors.statusDanger,
                  sparklineData: vm.doSparkline,
                  trendSubtitle: 'Saturasi 94%',
                  fractionDigits: 2,
                ),
                const SizedBox(height: 12),

                // Sensor 3: Kekeruhan Air (Turbidity)
                SensorCard(
                  label: 'Kekeruhan Air (Turbidity)',
                  safeRange: 'Batas jernih: 0.0 – 30.0 NTU',
                  value: data.turbidity,
                  unit: 'NTU',
                  icon: Icons.blur_on_rounded,
                  accentColor: AppColors.turbidityAccent,
                  iconContainerColor: AppColors.tertiaryFixed,
                  statusChip: data.turbidity <= 30.0 ? 'Jernih' : 'Keruh',
                  statusColor: data.turbidity <= 30.0
                      ? AppColors.statusSafe
                      : AppColors.statusWarning,
                  sparklineData: vm.turbiditySparkline,
                  trendSubtitle: 'Kecerahan tinggi',
                  fractionDigits: 1,
                ),
                const SizedBox(height: 16),

                // 4. IoT Node Telemetry & Diagnostic (2-Column Grid)
                Row(
                  children: [
                    // Jarak Node
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.outline.withValues(alpha: 0.4)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.radar_rounded, size: 18, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Jarak Node',
                                    style: AppTextStyles.bodySm().copyWith(fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${DateFormatter.formatDecimal(data.jarak, fractionDigits: 1)} m',
                              style: AppTextStyles.titleMd().copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Dari Pos Pantau 1',
                              style: AppTextStyles.labelSm(color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Kekuatan Sinyal (RSSI)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.outline.withValues(alpha: 0.4)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.wifi_tethering_rounded, size: 18, color: AppColors.statusSafe),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Kekuatan Sinyal',
                                    style: AppTextStyles.bodySm().copyWith(fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  '-72 dBm',
                                  style: AppTextStyles.titleMd().copyWith(fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.statusSafe,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Sinyal LoRa Sangat Baik',
                              style: AppTextStyles.labelSm(color: AppColors.statusSafe).copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 5. Alert Status & Fish Welfare Quick Notification
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.notifications_active_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tidak Ada Peringatan Bahaya',
                              style: AppTextStyles.bodyMd().copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Kualitas air stabil – jadwal tebar pakan aman dilakukan.',
                              style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.onSurfaceVariant,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 6. Quick Feeding Recommendation Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.outline.withValues(alpha: 0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.set_meal_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pemberian Pakan Berikutnya',
                              style: AppTextStyles.bodyMd().copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Pukul 10:30 WIB • 12.5 kg Pelet',
                              style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Jadwal pemberian pakan dicatat!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Catat', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSkeleton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Menghubungkan Sensor KJA...',
              style: AppTextStyles.titleMd().copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Mengambil data telemetri realtime & IoT gateway',
              style: AppTextStyles.bodyMd(color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, DashboardViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.signal_wifi_connected_no_internet_4_rounded,
              size: 64,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text('Terjadi Kesalahan', style: AppTextStyles.titleLg()),
            const SizedBox(height: 8),
            Text(
              vm.errorMessage ?? 'Tidak dapat memuat data sensor.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMd(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => vm.refresh(),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
