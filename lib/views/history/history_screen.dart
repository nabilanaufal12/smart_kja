import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/sensor_helpers.dart';
import '../../data/models/water_status.dart';
import '../../viewmodels/history_viewmodel.dart';
import 'history_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  void _showFilterDialog(BuildContext context, HistoryViewModel vm) async {
    final now = DateTime.now();
    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now.add(const Duration(days: 1)),
      initialDateRange: vm.startDate != null && vm.endDate != null
          ? DateTimeRange(start: vm.startDate!, end: vm.endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      vm.setFilter(start: pickedRange.start, end: pickedRange.end);
    }
  }

  void _exportCsv(BuildContext context, HistoryViewModel vm) {
    final csvData = vm.generateCsvContent();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            const Icon(Icons.table_view_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text('Ekspor Data CSV'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Format data identik dengan MicroSD Gateway IoT (Tanggal, Jam, Suhu, DO, Turbidity, Status).',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 140,
              child: SingleChildScrollView(
                child: Text(
                  csvData.isEmpty ? 'Tidak ada data untuk diekspor' : csvData,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoryViewModel>();

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
                'Riwayat Monitoring',
                style: AppTextStyles.titleMd().copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                'Arsip telemetri sensor perairan keramba',
                style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton.icon(
                onPressed: () => _exportCsv(context, vm),
                icon: const Icon(Icons.download_rounded, size: 16),
                label: const Text('Ekspor CSV', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter Accordion / Search Strip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outline.withValues(alpha: 0.15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.filter_alt_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      vm.isFiltered
                          ? 'Rentang: ${vm.startDate != null ? DateFormatter.formatFull(vm.startDate!.toIso8601String()).split(',')[0] : ''} - ${vm.endDate != null ? DateFormatter.formatFull(vm.endDate!.toIso8601String()).split(',')[0] : ''}'
                          : 'Semua Rentang Tanggal (${vm.historyList.length} Entri)',
                      style: AppTextStyles.bodySm().copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (vm.isFiltered)
                    GestureDetector(
                      onTap: () => vm.resetFilter(),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          'Reset',
                          style: AppTextStyles.labelSm(color: AppColors.statusDanger).copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  InkWell(
                    onTap: () => _showFilterDialog(context, vm),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Pilih Tanggal',
                            style: AppTextStyles.labelSm(color: AppColors.primary).copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // List Data Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => vm.fetchHistory(),
              color: AppColors.primary,
              child: _buildListContent(context, vm),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListContent(BuildContext context, HistoryViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.errorMessage != null && vm.historyList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text('Gagal memuat data', style: AppTextStyles.titleMd()),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => vm.fetchHistory(),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (vm.historyList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history_toggle_off_rounded, size: 54, color: AppColors.onSurfaceVariant),
            const SizedBox(height: 12),
            Text('Belum Ada Data Riwayat', style: AppTextStyles.titleMd()),
            const SizedBox(height: 4),
            Text(
              vm.isFiltered ? 'Coba atur ulang rentang tanggal filter' : 'Data sensor akan otomatis muncul di sini',
              style: AppTextStyles.bodySm(),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: vm.historyList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = vm.historyList[index];
        final statusColor = SensorHelpers.getStatusColor(item.status);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HistoryDetailScreen(data: item),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outline.withValues(alpha: 0.15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Top Row: Status badge & timestamp
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.status == WaterStatus.aman
                                  ? Icons.check_circle_rounded
                                  : (item.status == WaterStatus.waspada
                                      ? Icons.warning_amber_rounded
                                      : Icons.error_rounded),
                              size: 13,
                              color: statusColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.status.label.toUpperCase(),
                              style: AppTextStyles.labelCaps(color: statusColor).copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.schedule_rounded, size: 13, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            DateFormatter.formatFull(item.waktu),
                            style: AppTextStyles.labelSm(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(height: 1, color: AppColors.outline.withValues(alpha: 0.15)),
                  const SizedBox(height: 12),

                  // Metrics Row (Suhu, DO, Turbidity)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMiniMetric(
                        label: 'Suhu Air',
                        value: '${DateFormatter.formatDecimal(item.suhu, fractionDigits: 1)} °C',
                        color: AppColors.suhuAccent,
                      ),
                      Container(width: 1, height: 28, color: AppColors.outline.withValues(alpha: 0.15)),
                      _buildMiniMetric(
                        label: 'DO',
                        value: '${DateFormatter.formatDecimal(item.doValue, fractionDigits: 2)} mg/L',
                        color: AppColors.doAccent,
                      ),
                      Container(width: 1, height: 28, color: AppColors.outline.withValues(alpha: 0.15)),
                      _buildMiniMetric(
                        label: 'Kekeruhan',
                        value: '${DateFormatter.formatDecimal(item.turbidity, fractionDigits: 1)} NTU',
                        color: AppColors.turbidityAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniMetric({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.labelSm(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.bodyMd().copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
