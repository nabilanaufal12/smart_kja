import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class WaterStatusRulesScreen extends StatelessWidget {
  const WaterStatusRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aturan Ambang Batas',
                style: AppTextStyles.titleMd().copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                'KJA 01 - Pondok 1',
                style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                icon: const Icon(Icons.info_outline_rounded, color: AppColors.onSurfaceVariant),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Text('Informasi Standar Air'),
                      content: const Text(
                        'Standar baku mutu air mengacu pada SNI Budidaya Perikanan dan rekomendasi Kementerian Kelautan dan Perikanan (KKP) untuk KJA Teluk Hurun.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Visual Ambient Header Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(18),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Konfigurasi Ambang Batas',
                            style: AppTextStyles.titleMd().copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Atur parameter ambang batas kualitas air budidaya untuk memicu notifikasi peringatan dini dan indikator LED gateway.',
                            style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: AppColors.outline.withValues(alpha: 0.15)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.sensors_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      'Sinkronisasi otomatis ke Gateway LoRa KJA-01',
                      style: AppTextStyles.labelSm(color: AppColors.primary).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 1. Suhu Air Card
          _buildThresholdCard(
            icon: Icons.device_thermostat_rounded,
            title: 'Ambang Suhu Air',
            subtitle: 'Optimalisasi metabolisme ikan',
            rangePill: '25.0°C – 32.0°C',
            accentColor: AppColors.suhuAccent,
            lowerLabel: 'Batas Bawah Aman',
            lowerVal: '25.0 °C',
            upperLabel: 'Batas Atas Aman',
            upperVal: '32.0 °C',
            scaleLabels: ['< 25°C\nBahaya', '25° - 27°\nWaspada', '27° - 32°\nOptimal', '32° - 35°\nWaspada', '> 35°C\nBahaya'],
            scaleFractions: [0.2, 0.15, 0.3, 0.15, 0.2],
            scaleColors: [
              AppColors.statusDanger.withValues(alpha: 0.5),
              AppColors.statusWarning.withValues(alpha: 0.5),
              AppColors.statusSafe,
              AppColors.statusWarning.withValues(alpha: 0.5),
              AppColors.statusDanger.withValues(alpha: 0.5),
            ],
          ),
          const SizedBox(height: 16),

          // 2. Oksigen Terlarut (DO) Card
          _buildThresholdCard(
            icon: Icons.water_drop_rounded,
            title: 'Ambang Oksigen Terlarut (DO)',
            subtitle: 'Respirasi dan kelangsungan hidup ikan',
            rangePill: '>= 5.00 mg/L',
            accentColor: AppColors.doAccent,
            lowerLabel: 'Zona Asfiksia (Kritis)',
            lowerVal: '< 3.00 mg/L',
            upperLabel: 'Target Optimal',
            upperVal: '>= 5.00 mg/L',
            scaleLabels: ['< 3.0\nAsfiksia', '3.0 - 5.0\nWaspada', '> 5.0 mg/L\nOptimal'],
            scaleFractions: [0.35, 0.25, 0.40],
            scaleColors: [
              AppColors.statusDanger,
              AppColors.statusWarning,
              AppColors.statusSafe,
            ],
          ),
          const SizedBox(height: 16),

          // 3. Kekeruhan (Turbidity) Card
          _buildThresholdCard(
            icon: Icons.blur_on_rounded,
            title: 'Ambang Kekeruhan Air',
            subtitle: 'Penetrasi cahaya dan sedimentasi',
            rangePill: '<= 30.0 NTU',
            accentColor: AppColors.turbidityAccent,
            lowerLabel: 'Jernih (Aman)',
            lowerVal: '0 - 30 NTU',
            upperLabel: 'Keruh (Bahaya)',
            upperVal: '> 50 NTU',
            scaleLabels: ['0 - 30 NTU\nJernih', '30 - 50 NTU\nSedang', '> 50 NTU\nKeruh'],
            scaleFractions: [0.45, 0.25, 0.30],
            scaleColors: [
              AppColors.statusSafe,
              AppColors.statusWarning,
              AppColors.statusDanger,
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildThresholdCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String rangePill,
    required Color accentColor,
    required String lowerLabel,
    required String lowerVal,
    required String upperLabel,
    required String upperVal,
    required List<String> scaleLabels,
    required List<double> scaleFractions,
    required List<Color> scaleColors,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
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
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyMd().copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.statusSafe.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  rangePill,
                  style: AppTextStyles.labelCaps(color: AppColors.statusSafe).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Two Target Badges
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lowerLabel,
                        style: AppTextStyles.labelSm(color: AppColors.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lowerVal,
                        style: AppTextStyles.bodyMd().copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        upperLabel,
                        style: AppTextStyles.labelSm(color: AppColors.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        upperVal,
                        style: AppTextStyles.bodyMd().copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Visual Scale Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 10,
              child: Row(
                children: List.generate(
                  scaleFractions.length,
                  (i) => Expanded(
                    flex: (scaleFractions[i] * 100).toInt(),
                    child: Container(color: scaleColors[i]),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Scale Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: scaleLabels.map((lbl) {
              return Text(
                lbl,
                textAlign: TextAlign.center,
                style: AppTextStyles.labelSm(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
