import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            icon: Icons.thermostat_outlined,
            label: 'Avg Suhu 24j: 28,3 °C',
            accent: AppColors.suhuAccent,
          ),
          const SizedBox(width: 8),
          _buildChip(
            icon: Icons.water_drop_outlined,
            label: 'Min DO 24j: 5,20 mg/L',
            accent: AppColors.doAccent,
          ),
          const SizedBox(width: 8),
          _buildChip(
            icon: Icons.blur_on_outlined,
            label: 'Maks NTU 24j: 18,5 NTU',
            accent: AppColors.turbidityAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: accent),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.bodySm()),
        ],
      ),
    );
  }
}
