import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/sensor_data.dart';

class HistoryDetailScreen extends StatelessWidget {
  final SensorData data;

  const HistoryDetailScreen({super.key, required this.data});

  static String _getFeedingAdvice(WaterStatus status) {
    switch (status) {
      case WaterStatus.aman:
        return 'Pemberian Pakan Optimal (100%)';
      case WaterStatus.waspada:
        return 'Kurangi Porsi Pakan 50%';
      case WaterStatus.bahaya:
        return 'Hentikan Pakan Segera (0%)';
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusTitle;
    IconData statusIcon;

    switch (data.status) {
      case WaterStatus.aman:
        statusColor = AppColors.statusSafe;
        statusTitle = 'STATUS AIR: AMAN';
        statusIcon = Icons.verified_user_rounded;
        break;
      case WaterStatus.waspada:
        statusColor = AppColors.statusWarning;
        statusTitle = 'STATUS AIR: WASPADA';
        statusIcon = Icons.warning_amber_rounded;
        break;
      case WaterStatus.bahaya:
        statusColor = AppColors.statusDanger;
        statusTitle = 'STATUS AIR: BAHAYA';
        statusIcon = Icons.dangerous_rounded;
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detail Riwayat Data',
                style: AppTextStyles.titleMd().copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                'KJA 01 - Pondok 1 • Danau Jatiluhur',
                style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. Top Visual Status Summary Card (Stitch Detail Signature)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.outline.withValues(alpha: 0.15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Header Pill & Verified Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, color: statusColor, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            statusTitle,
                            style: AppTextStyles.labelCaps(color: statusColor).copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.statusSafe,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Terverifikasi',
                            style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant).copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Recording Time & Node Meta
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      DateFormatter.formatFull(data.waktu),
                      style: AppTextStyles.titleMd().copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.hub_rounded, color: AppColors.secondary, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Node ID: ',
                      style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        data.nodeId,
                        style: AppTextStyles.labelSm(color: AppColors.primary).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '(ESP32 - Gateway LoRa Pondok 1)',
                        style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant).copyWith(fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Quick Index Indicator Row (3 columns)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Kondisi Kolam',
                              style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant).copyWith(fontSize: 11),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              data.status == WaterStatus.aman ? '98.5%' : data.status == WaterStatus.waspada ? '72.0%' : '38.0%',
                              style: AppTextStyles.bodyMd(color: statusColor).copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Stres Ikan',
                              style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant).copyWith(fontSize: 11),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              data.status == WaterStatus.aman ? 'Rendah' : data.status == WaterStatus.waspada ? 'Sedang' : 'Tinggi',
                              style: AppTextStyles.bodyMd(color: statusColor).copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Rekomendasi',
                              style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant).copyWith(fontSize: 11),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _getFeedingAdvice(data.status),
                              style: AppTextStyles.bodyMd(color: AppColors.primary).copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
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
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Parameter Details Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.analytics_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Parameter Kualitas Air',
                    style: AppTextStyles.titleMd().copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '3 Sensor Aktif',
                  style: AppTextStyles.labelCaps(color: AppColors.onSurfaceVariant).copyWith(fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3. Suhu Air Card
          _buildDetailMetricCard(
            title: 'Suhu Air',
            sensorName: 'Sensor DS18B20 Submersible Waterproof',
            value: DateFormatter.formatDecimal(data.suhu, fractionDigits: 1),
            unit: '°C',
            icon: Icons.thermostat_rounded,
            iconColor: AppColors.suhuAccent,
            statusBadge: data.suhu >= 25.0 && data.suhu <= 32.0 ? 'Normal' : 'Abnormal',
            isNormal: data.suhu >= 25.0 && data.suhu <= 32.0,
            barSegments: [
              _BarSegment(flex: 30, color: AppColors.statusDanger, label: 'Dingin (<25°)'),
              _BarSegment(flex: 45, color: AppColors.statusSafe, label: 'Optimal (25-32°C)'),
              _BarSegment(flex: 25, color: AppColors.statusWarning, label: 'Panas (>32°)'),
            ],
          ),
          const SizedBox(height: 14),

          // 4. DO Card
          _buildDetailMetricCard(
            title: 'Oksigen Terlarut (DO)',
            sensorName: 'Sensor Analog Dissolved Oxygen Probe',
            value: DateFormatter.formatDecimal(data.doValue, fractionDigits: 2),
            unit: 'mg/L',
            icon: Icons.water_drop_rounded,
            iconColor: AppColors.doAccent,
            statusBadge: data.doValue >= 5.0 ? 'Optimal' : data.doValue >= 3.0 ? 'Waspada' : 'Kritis',
            isNormal: data.doValue >= 5.0,
            barSegments: [
              _BarSegment(flex: 25, color: AppColors.statusDanger, label: 'Kritis (<3)'),
              _BarSegment(flex: 35, color: AppColors.statusWarning, label: 'Waspada (3-5)'),
              _BarSegment(flex: 40, color: AppColors.statusSafe, label: 'Optimal (>5 mg/L)'),
            ],
          ),
          const SizedBox(height: 14),

          // 5. Turbidity Card
          _buildDetailMetricCard(
            title: 'Kekeruhan Air (Turbidity)',
            sensorName: 'Sensor Kekeruhan Optik Spektrofotometri',
            value: DateFormatter.formatDecimal(data.turbidity, fractionDigits: 1),
            unit: 'NTU',
            icon: Icons.blur_on_rounded,
            iconColor: AppColors.turbidityAccent,
            statusBadge: data.turbidity <= 25.0 ? 'Aman' : 'Tinggi',
            isNormal: data.turbidity <= 25.0,
            barSegments: [
              _BarSegment(flex: 45, color: AppColors.statusSafe, label: 'Jernih (<25 NTU)'),
              _BarSegment(flex: 30, color: AppColors.statusWarning, label: 'Keruh (25-50)'),
              _BarSegment(flex: 25, color: AppColors.statusDanger, label: 'Sangat Keruh (>50)'),
            ],
          ),
          const SizedBox(height: 14),

          // 6. Estimasi Jarak Node & LoRa Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outline.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.jarakAccent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.straighten_rounded, color: AppColors.jarakAccent, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Estimasi Jarak Sensor', style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant)),
                          Text(
                            'LoRa 433 MHz',
                            style: AppTextStyles.labelCaps(color: AppColors.primary).copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            DateFormatter.formatDecimal(data.jarak, fractionDigits: 1),
                            style: AppTextStyles.titleLg().copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'meter dari pelampung KJA',
                            style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDetailMetricCard({
    required String title,
    required String sensorName,
    required String value,
    required String unit,
    required IconData icon,
    required Color iconColor,
    required String statusBadge,
    required bool isNormal,
    required List<_BarSegment> barSegments,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyMd().copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        sensorName,
                        style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant).copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (isNormal ? AppColors.statusSafe : AppColors.statusWarning).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isNormal ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                      size: 13,
                      color: isNormal ? AppColors.statusSafe : AppColors.statusWarning,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      statusBadge,
                      style: AppTextStyles.labelCaps(
                        color: isNormal ? AppColors.statusSafe : AppColors.statusWarning,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Main Metric Value
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: AppTextStyles.displayLg().copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                unit,
                style: AppTextStyles.titleMd(color: AppColors.onSurfaceVariant).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Colored Range Segments Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 7,
              child: Row(
                children: barSegments
                    .map((seg) => Expanded(
                          flex: seg.flex,
                          child: Container(color: seg.color),
                        ))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Legend Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: barSegments
                .map((seg) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: seg.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          seg.label,
                          style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant).copyWith(fontSize: 10),
                        ),
                      ],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _BarSegment {
  final int flex;
  final Color color;
  final String label;

  const _BarSegment({required this.flex, required this.color, required this.label});
}
