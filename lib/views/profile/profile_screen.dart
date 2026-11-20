import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../auth/login_screen.dart';
import 'water_status_rules_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context, AuthViewModel authVm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Keluar dari Akun?'),
          ],
        ),
        content: const Text(
          'Anda perlu masuk kembali untuk mengakses data monitoring tambak.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await authVm.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _showThemeSelector(BuildContext context, SettingsViewModel settingsVm) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pilih Tema Tampilan',
                style: AppTextStyles.titleMd().copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Sesuaikan kenyamanan visual di lapangan',
                style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              _buildThemeOptionTile(
                title: 'Sistem (Otomatis)',
                subtitle: 'Mengikuti pengaturan mode gelap/terang ponsel',
                icon: Icons.brightness_auto_rounded,
                isSelected: settingsVm.themeMode == ThemeMode.system,
                onTap: () {
                  settingsVm.setThemeMode(ThemeMode.system);
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 8),
              _buildThemeOptionTile(
                title: 'Tema Terang (Lapang)',
                subtitle: 'Kontras tajam optimal di bawah terik matahari',
                icon: Icons.light_mode_rounded,
                isSelected: settingsVm.themeMode == ThemeMode.light,
                onTap: () {
                  settingsVm.setThemeMode(ThemeMode.light);
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 8),
              _buildThemeOptionTile(
                title: 'Tema Gelap (Malam)',
                subtitle: 'Nyaman di mata dan hemat konsumsi baterai',
                icon: Icons.dark_mode_rounded,
                isSelected: settingsVm.themeMode == ThemeMode.dark,
                onTap: () {
                  settingsVm.setThemeMode(ThemeMode.dark);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildThemeOptionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline.withValues(alpha: 0.15),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMd().copyWith(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant).copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  void _showCalibrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.build_circle_outlined, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            const Text('Kalibrasi Sensor'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status kalibrasi sensor IoT SMART KJA saat ini:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            _buildCalibrationRow('Sensor Suhu (DS18B20)', 'Offset 0.0°C (Terverifikasi)', AppColors.statusSafe),
            const SizedBox(height: 8),
            _buildCalibrationRow('Sensor Oksigen Terlarut (DO)', 'Kalibrasi 100% Saturation', AppColors.statusSafe),
            const SizedBox(height: 8),
            _buildCalibrationRow('Sensor Kekeruhan (Turbidity)', 'Kalibrasi Zero-Water NTU', AppColors.statusSafe),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: AppColors.onSurfaceVariant),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Kalibrasi manual di lapangan dilakukan langsung pada mikrokontroler ESP32.',
                      style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  static Widget _buildCalibrationRow(String sensor, String status, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_rounded, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sensor, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Text(status, style: TextStyle(color: color, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  void _showDocumentationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.menu_book_rounded, color: AppColors.secondary),
            ),
            const SizedBox(width: 12),
            const Text('Dokumentasi'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Panduan Sistem SMART KJA',
                style: AppTextStyles.titleMd(),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sistem Monitoring Kualitas Air Keramba Jaring Apung (KJA) berbasis IoT.\n\n'
                '• Pengambilan Data: Sensor DS18B20 (suhu), Sensor DO Analog, dan Sensor Turbidity membaca kondisi air secara berkala.\n'
                '• Komunikasi: Mikrokontroler ESP32 mengirim data via LoRa 433 MHz ke Gateway lokal, diteruskan ke Firebase Realtime Database.\n'
                '• Klasifikasi Status:\n'
                '  - AMAN: Kondisi optimal bagi kelangsungan hidup ikan.\n'
                '  - WASPADA: Parameter mendekati batas toleransi, periksa aerasi.\n'
                '  - BAHAYA: Parameter kritis, segera aktifkan kincir air/aerator!',
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final settingsVm = context.watch<SettingsViewModel>();
    final user = authVm.currentUser;

    final displayName = user?.displayName ?? 'Bambang Sudirgo';
    final email = user?.email ?? 'bambang.kja@tambakmodern.id';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'B';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Section Title & Status Toast (Stitch Profile Header)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profil & Perangkat',
                      style: AppTextStyles.titleLg().copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Manajemen operator dan telemetri node IoT KJA',
                      style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.statusSafe.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
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
                      const SizedBox(width: 6),
                      Text(
                        'SINKRON',
                        style: AppTextStyles.labelCaps(color: AppColors.statusSafe).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 1. User Profile Card with Avatar & Verification Badge
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
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
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar with verified badge
                      Stack(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0057CD), Color(0xFF0D6EFD)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                initial,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.verified_rounded,
                                color: AppColors.statusSafe,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: AppTextStyles.titleMd().copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Pengelola Keramba Jaring Apung • KJA 01',
                              style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.mail_outline_rounded, size: 15, color: AppColors.onSurfaceVariant),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    email,
                                    style: AppTextStyles.bodySm(color: AppColors.onSurface),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.phone_outlined, size: 15, color: AppColors.onSurfaceVariant),
                                const SizedBox(width: 6),
                                Text(
                                  '+62 812-3456-7890',
                                  style: AppTextStyles.bodySm(color: AppColors.onSurface),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Hardware & IoT Gateway Telemetry Card (Google Stitch High-Tech Architecture)
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
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
                  // Card Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.router_rounded, color: AppColors.primary, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status Perangkat IoT & Gateway',
                                  style: AppTextStyles.bodyMd().copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Konektivitas nirkabel dan sensor live',
                                  style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.statusSafe.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'AKTIF',
                            style: AppTextStyles.labelCaps(color: AppColors.statusSafe).copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Live Connectivity Ribbon
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    color: AppColors.surfaceContainerLow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                              'Firebase Realtime Database',
                              style: AppTextStyles.bodySm().copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Online',
                              style: AppTextStyles.labelCaps(color: AppColors.statusSafe).copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '• Ping 42ms',
                              style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant).copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Node Hardware Metrics
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Node Specs Box
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLowest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.developer_board_rounded, color: AppColors.primary, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Pemancar KJA 01',
                                          style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.surfaceContainerLowest,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: AppColors.outline.withValues(alpha: 0.15)),
                                          ),
                                          child: Text(
                                            'ESP32-WROOM',
                                            style: AppTextStyles.labelSm(color: AppColors.onSurface).copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Suhu DS18B20 • DO Analog • Turbidity',
                                      style: AppTextStyles.bodySm().copyWith(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // LoRa & MAC Grid (2 Columns)
                        Row(
                          children: [
                            // LoRa
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Frekuensi LoRa', style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant)),
                                        const Icon(Icons.sensors_rounded, size: 16, color: AppColors.primary),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '433 MHz',
                                      style: AppTextStyles.titleMd().copyWith(fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.signal_cellular_alt_rounded, size: 14, color: AppColors.statusSafe),
                                        const SizedBox(width: 4),
                                        Text(
                                          '-72 dBm (Kuat)',
                                          style: AppTextStyles.labelCaps(color: AppColors.statusSafe),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // MAC Node
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Alamat MAC', style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant)),
                                        const Icon(Icons.fingerprint_rounded, size: 16, color: AppColors.onSurfaceVariant),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'E4:65:B8:2A:11:0C',
                                      style: AppTextStyles.labelSm().copyWith(fontWeight: FontWeight.w700),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'SX1278 Ra-02 Module',
                                      style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant).copyWith(fontSize: 11),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Battery & Solar Power Box
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.statusSafe.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.solar_power_rounded, color: AppColors.statusSafe, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Baterai & Solar Cell',
                                          style: AppTextStyles.bodySm().copyWith(fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.bolt_rounded, size: 14, color: AppColors.statusSafe),
                                      ],
                                    ),
                                    Text(
                                      'Tegangan 4.12V • Charging Optimal',
                                      style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant).copyWith(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '88%',
                                style: AppTextStyles.titleLg(color: AppColors.statusSafe).copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Firmware Version Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.memory_rounded, size: 16, color: AppColors.onSurfaceVariant),
                                const SizedBox(width: 6),
                                Text(
                                  'Versi Firmware Node',
                                  style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'v2.4.1',
                                  style: AppTextStyles.labelSm().copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.statusSafe.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'MUTAKHIR',
                                    style: AppTextStyles.labelCaps(color: AppColors.statusSafe).copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Settings & Preferences Menu
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'PENGATURAN & PREFERENSI',
                      style: AppTextStyles.labelCaps(color: AppColors.onSurfaceVariant).copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),

                  // Item 1: Water Thresholds
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
                    ),
                    title: Text(
                      'Aturan & Ambang Batas Air',
                      style: AppTextStyles.bodyMd().copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Konfigurasi batas aman pH, DO, & Suhu',
                      style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WaterStatusRulesScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 64),

                  // Item 2: Notification & Audio Alarm
                  SwitchListTile(
                    secondary: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.statusWarning.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.volume_up_rounded, color: AppColors.statusWarning, size: 20),
                    ),
                    title: Text(
                      'Pemberitahuan & Alarm Suara',
                      style: AppTextStyles.bodyMd().copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Bunyikan peringatan saat kondisi bahaya',
                      style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                    ),
                    activeTrackColor: AppColors.primary,
                    value: settingsVm.notificationEnabled,
                    onChanged: (val) => settingsVm.setNotificationEnabled(val),
                  ),
                  const Divider(height: 1, indent: 64),

                  // Item 3: Display Mode
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.palette_outlined, color: AppColors.secondary, size: 20),
                    ),
                    title: Text(
                      'Mode Tampilan',
                      style: AppTextStyles.bodyMd().copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      settingsVm.themeMode == ThemeMode.light
                          ? 'Tema Terang • Kontras Lapangan'
                          : settingsVm.themeMode == ThemeMode.dark
                              ? 'Tema Gelap • Hemat Daya'
                              : 'Mengikuti Sistem Perangkat',
                      style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          settingsVm.themeMode == ThemeMode.light
                              ? 'Terang'
                              : settingsVm.themeMode == ThemeMode.dark
                                  ? 'Gelap'
                                  : 'Otomatis',
                          style: AppTextStyles.bodySm(color: AppColors.primary).copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
                      ],
                    ),
                    onTap: () => _showThemeSelector(context, settingsVm),
                  ),
                  const Divider(height: 1, indent: 64),

                  // Item 4: Sensor Calibration
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.build_circle_outlined, color: AppColors.primary, size: 20),
                    ),
                    title: Text(
                      'Kalibrasi & Diagnostik Sensor',
                      style: AppTextStyles.bodyMd().copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Offset DO, Suhu, & Kekeruhan probe',
                      style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
                    onTap: () => _showCalibrationDialog(context),
                  ),
                  const Divider(height: 1, indent: 64),

                  // Item 5: Documentation & Help
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.onSurfaceVariant.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.menu_book_rounded, color: AppColors.onSurfaceVariant, size: 20),
                    ),
                    title: Text(
                      'Dokumentasi & Bantuan',
                      style: AppTextStyles.bodyMd().copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Buku panduan operasional SMART KJA',
                      style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
                    onTap: () => _showDocumentationDialog(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. Logout Action
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error.withValues(alpha: 0.1),
                  foregroundColor: AppColors.error,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                ),
                icon: const Icon(Icons.logout_rounded, size: 20),
                label: const Text(
                  'Keluar dari Akun (Logout)',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                onPressed: () => _showLogoutDialog(context, authVm),
              ),
            ),
            const SizedBox(height: 16),

            // Footer Version Info
            Center(
              child: Column(
                children: [
                  Text(
                    '${AppConstants.appName} v1.2.0 (Build 42)',
                    style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant).copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Sistem Monitoring Telemetri Akuakultur Presisi • UMRAH',
                    style: AppTextStyles.bodySm(color: AppColors.onSurfaceVariant).copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
