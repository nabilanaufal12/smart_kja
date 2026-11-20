import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';
import '../../viewmodels/chart_viewmodel.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChartViewModel>();

    Color getParamColor() {
      switch (vm.selectedParameter) {
        case SensorParameter.suhu:
          return AppColors.suhuAccent;
        case SensorParameter.doVal:
          return AppColors.doAccent;
        case SensorParameter.turbidity:
          return AppColors.turbidityAccent;
      }
    }

    String getParamUnit() {
      switch (vm.selectedParameter) {
        case SensorParameter.suhu:
          return '°C';
        case SensorParameter.doVal:
          return 'mg/L';
        case SensorParameter.turbidity:
          return 'NTU';
      }
    }

    String getParamName() {
      switch (vm.selectedParameter) {
        case SensorParameter.suhu:
          return 'Suhu Air';
        case SensorParameter.doVal:
          return 'Oksigen (DO)';
        case SensorParameter.turbidity:
          return 'Kekeruhan';
      }
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 16,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Grafik Tren Kualitas Air',
                style: AppTextStyles.titleMd().copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.water_drop_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'KJA 01 - Pondok 1 • Teluk Hurun',
                    style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.outline.withValues(alpha: 0.5)),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  size: 18,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => vm.loadChartData(),
        color: AppColors.primary,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // 1. Period Selector (Segmented Tab Bar)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  _buildPeriodTab(
                    label: '24 Jam',
                    isSelected: vm.selectedPeriod == ChartPeriod.hours24,
                    onTap: () => vm.setPeriod(ChartPeriod.hours24),
                  ),
                  _buildPeriodTab(
                    label: '7 Hari',
                    isSelected: vm.selectedPeriod == ChartPeriod.days7,
                    onTap: () => vm.setPeriod(ChartPeriod.days7),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 2. Parameter Filter Chips (Horizontal Scrollable)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildParamFilterChip(
                    label: 'Suhu (°C)',
                    dotColor: AppColors.suhuAccent,
                    isSelected: vm.selectedParameter == SensorParameter.suhu,
                    onTap: () => vm.setParameter(SensorParameter.suhu),
                  ),
                  const SizedBox(width: 8),
                  _buildParamFilterChip(
                    label: 'DO (mg/L)',
                    dotColor: AppColors.doAccent,
                    isSelected: vm.selectedParameter == SensorParameter.doVal,
                    onTap: () => vm.setParameter(SensorParameter.doVal),
                  ),
                  const SizedBox(width: 8),
                  _buildParamFilterChip(
                    label: 'Kekeruhan (NTU)',
                    dotColor: AppColors.turbidityAccent,
                    isSelected: vm.selectedParameter == SensorParameter.turbidity,
                    onTap: () => vm.setParameter(SensorParameter.turbidity),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Interactive Chart Card Container (Stitch Design)
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
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Live Tag
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Tren Parameter Air (${vm.selectedPeriod == ChartPeriod.hours24 ? '24 Jam' : '7 Hari'})',
                          style: AppTextStyles.titleMd().copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.statusSafe.withValues(alpha: 0.12),
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
                            const SizedBox(width: 4),
                            Text(
                              'AKTIF',
                              style: AppTextStyles.labelCaps(color: AppColors.statusSafe).copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Telemetri riwayat perairan keramba apung unit 01',
                    style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),

                  // Legend
                  Row(
                    children: [
                      Container(
                        width: 14,
                        height: 4,
                        decoration: BoxDecoration(
                          color: getParamColor(),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${getParamName()} (${getParamUnit()})',
                        style: AppTextStyles.bodySm().copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Chart Area
                  SizedBox(
                    height: 230,
                    child: vm.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : vm.spots.isEmpty
                            ? const Center(child: Text('Data tidak cukup untuk menampilkan grafik'))
                            : LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    getDrawingHorizontalLine: (value) => FlLine(
                                      color: AppColors.outline.withValues(alpha: 0.4),
                                      strokeWidth: 1,
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 42,
                                        getTitlesWidget: (val, meta) => Text(
                                          val.toStringAsFixed(1),
                                          style: AppTextStyles.labelSm(color: AppColors.onSurfaceVariant),
                                        ),
                                      ),
                                    ),
                                    bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: vm.spots,
                                      isCurved: true,
                                      curveSmoothness: 0.35,
                                      color: getParamColor(),
                                      barWidth: 3,
                                      isStrokeCapRound: true,
                                      dotData: const FlDotData(show: false),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        gradient: LinearGradient(
                                          colors: [
                                            getParamColor().withValues(alpha: 0.25),
                                            getParamColor().withValues(alpha: 0.0),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. Statistics Summary Cards (Min, Avg, Max)
            Text(
              'Ringkasan Statistik',
              style: AppTextStyles.titleMd().copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Minimum',
                    value: DateFormatter.formatDecimal(vm.minValue, fractionDigits: 1),
                    unit: getParamUnit(),
                    color: AppColors.statusSafe,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    title: 'Rata-rata',
                    value: DateFormatter.formatDecimal(vm.avgValue, fractionDigits: 1),
                    unit: getParamUnit(),
                    color: getParamColor(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    title: 'Maksimum',
                    value: DateFormatter.formatDecimal(vm.maxValue, fractionDigits: 1),
                    unit: getParamUnit(),
                    color: AppColors.statusDanger,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMd().copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParamFilterChip({
    required String label,
    required Color dotColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodySm().copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: AppTextStyles.titleMd().copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                unit,
                style: AppTextStyles.labelSm(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
