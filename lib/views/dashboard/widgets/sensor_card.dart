import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';

class SensorCard extends StatelessWidget {
  final String label;
  final String safeRange;
  final double value;
  final String unit;
  final IconData icon;
  final Color accentColor;
  final Color iconContainerColor;
  final String statusChip;
  final Color statusColor;
  final List<double> sparklineData;
  final String trendSubtitle;
  final int fractionDigits;

  const SensorCard({
    super.key,
    required this.label,
    required this.safeRange,
    required this.value,
    required this.unit,
    required this.icon,
    required this.accentColor,
    required this.iconContainerColor,
    this.statusChip = 'Normal',
    this.statusColor = AppColors.statusSafe,
    required this.sparklineData,
    this.trendSubtitle = '',
    this.fractionDigits = 1,
  });

  @override
  Widget build(BuildContext context) {
    final formattedValue = DateFormatter.formatDecimal(value, fractionDigits: fractionDigits);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1C1E).withValues(alpha: 0.04),
            offset: const Offset(0, 3),
            blurRadius: 10,
          ),
        ],
        border: Border.all(
          color: AppColors.outline.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Icon + Label & Subtitle, plus Status Chip
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconContainerColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.bodyMd().copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      safeRange,
                      style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      statusColor == AppColors.statusSafe
                          ? Icons.check_circle_rounded
                          : (statusColor == AppColors.statusWarning
                              ? Icons.warning_amber_rounded
                              : Icons.error_rounded),
                      color: statusColor,
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      statusChip,
                      style: AppTextStyles.labelCaps(color: statusColor).copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF2F4F5)),
          const SizedBox(height: 12),

          // Bottom Row: Value + Sparkline Chart
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Value and Unit
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    formattedValue,
                    style: AppTextStyles.displayLg().copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    unit,
                    style: AppTextStyles.bodyMd(color: AppColors.onSurfaceVariant).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Sparkline Chart & Trend Subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 110,
                    height: 32,
                    child: sparklineData.isEmpty
                        ? const SizedBox()
                        : LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineTouchData: const LineTouchData(enabled: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: List.generate(
                                    sparklineData.length,
                                    (i) => FlSpot(i.toDouble(), sparklineData[i]),
                                  ),
                                  isCurved: true,
                                  color: accentColor,
                                  barWidth: 2.2,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true,
                                    checkToShowDot: (spot, barData) =>
                                        spot.x == sparklineData.length - 1,
                                    getDotPainter: (spot, percent, barData, index) =>
                                        FlDotCirclePainter(
                                      radius: 3.5,
                                      color: accentColor,
                                      strokeWidth: 0,
                                    ),
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: accentColor.withValues(alpha: 0.06),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  if (trendSubtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      trendSubtitle,
                      style: AppTextStyles.labelSm(
                        color: AppColors.onSurfaceVariant.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
