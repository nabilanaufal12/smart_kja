import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';

class FreshnessIndicator extends StatelessWidget {
  final String waktu;
  final bool isFresh;

  const FreshnessIndicator({
    super.key,
    required this.waktu,
    required this.isFresh,
  });

  @override
  Widget build(BuildContext context) {
    final freshnessText = DateFormatter.formatFreshness(waktu);

    if (!isFresh) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.statusWarning.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.statusWarning.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.statusWarning),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Data belum diperbarui lebih dari 20 menit ($freshnessText)',
                style: AppTextStyles.bodySm(color: const Color(0xFFB45309)),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        const Icon(Icons.access_time_rounded, size: 14, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          'Diperbarui $freshnessText',
          style: AppTextStyles.bodySm(),
        ),
      ],
    );
  }
}
