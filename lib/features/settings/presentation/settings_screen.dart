import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';

/// Settings Screen - "Setelan"
/// Matches reference design: category groups with icons,
/// toggle switches, pills for values, exit section
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _focusModeEnabled = false;
  bool _highContrastEnabled = false;
  String _language = 'Indonesia';
  String _textSize = 'Sedang';
  String _dailyTarget = '15 menit';
  String _reminderTime = '18.00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Text(
                    'Setelan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('⭐', style: TextStyle(fontSize: 18)),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.settings_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Teman Belajar banner
              _TemanBelajarBanner().animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 24),

              // Section: Umum
              _SettingsSection(
                title: 'Umum',
                dotColor: AppColors.primary,
                children: [
                  _SettingsToggle(
                    icon: Icons.volume_up_rounded,
                    iconColor: AppColors.primary,
                    title: 'Suara & Musik',
                    subtitle: 'Efek suara, musik latar, dan volume',
                    value: _soundEnabled,
                    onChanged: (v) => setState(() => _soundEnabled = v),
                  ),
                  _SettingsToggle(
                    icon: Icons.vibration_rounded,
                    iconColor: AppColors.secondary,
                    title: 'Getar',
                    subtitle: 'Getaran saat mengetuk tombol',
                    value: _vibrationEnabled,
                    onChanged: (v) => setState(() => _vibrationEnabled = v),
                  ),
                  _SettingsToggle(
                    icon: Icons.child_care_rounded,
                    iconColor: AppColors.success,
                    title: 'Mode Fokus Anak',
                    subtitle: 'Sembunyikan gangguan saat belajar',
                    value: _focusModeEnabled,
                    onChanged: (v) => setState(() => _focusModeEnabled = v),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Section: Pembelajaran
              _SettingsSection(
                title: 'Pembelajaran',
                dotColor: AppColors.pink,
                children: [
                  _SettingsPillItem(
                    icon: Icons.notifications_rounded,
                    iconColor: AppColors.pink,
                    title: 'Pengingat Belajar',
                    subtitle: 'Ingatkan jam belajar setiap hari',
                    pillText: _reminderTime,
                    pillColor: AppColors.pink,
                    onTap: () => _showTimePicker(),
                  ),
                  _SettingsPillItem(
                    icon: Icons.track_changes_rounded,
                    iconColor: Colors.blue,
                    title: 'Target Harian',
                    subtitle: 'Jumlah aktivitas harian',
                    pillText: _dailyTarget,
                    pillColor: Colors.blue,
                    onTap: () => _showTargetPicker(),
                  ),
                  _SettingsPillItem(
                    icon: Icons.cloud_download_rounded,
                    iconColor: AppColors.success,
                    title: 'Unduh untuk Offline',
                    subtitle: 'Akses materi tanpa internet',
                    showChevron: true,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Section: Akun & Orang Tua
              _SettingsSection(
                title: 'Akun & Orang Tua',
                dotColor: AppColors.success,
                children: [
                  _SettingsItem(
                    icon: Icons.person_rounded,
                    iconColor: AppColors.primary,
                    title: 'Profil Anak',
                    subtitle: 'Nama, avatar, dan level',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.people_rounded,
                    iconColor: AppColors.primary,
                    title: 'Orang Tua',
                    subtitle: 'Laporan belajar dan kontrol akun',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.shield_rounded,
                    iconColor: Colors.blue,
                    title: 'Keamanan',
                    subtitle: 'PIN orang tua dan privasi',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Section: Bahasa & Aksesibilitas
              _SettingsSection(
                title: 'Bahasa & Aksesibilitas',
                dotColor: AppColors.secondary,
                children: [
                  _SettingsPillItem(
                    icon: Icons.language_rounded,
                    iconColor: Colors.blue,
                    title: 'Bahasa',
                    subtitle: '',
                    pillText: _language,
                    pillColor: Colors.blue,
                    onTap: () {},
                  ),
                  _SettingsPillItem(
                    icon: Icons.text_fields_rounded,
                    iconColor: AppColors.pink,
                    title: 'Ukuran Teks',
                    subtitle: '',
                    pillText: _textSize,
                    pillColor: AppColors.pink,
                    onTap: () {},
                  ),
                  _SettingsToggle(
                    icon: Icons.contrast_rounded,
                    iconColor: AppColors.secondary,
                    title: 'Kontras Ramah Anak',
                    subtitle: '',
                    value: _highContrastEnabled,
                    onChanged: (v) => setState(() => _highContrastEnabled = v),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Section: Informasi
              _SettingsSection(
                title: 'Informasi',
                dotColor: Colors.blue,
                children: [
                  _SettingsItem(
                    icon: Icons.info_rounded,
                    iconColor: Colors.blue,
                    title: 'Tentang KataPlay',
                    subtitle: 'Versi aplikasi 1.0.0',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.help_rounded,
                    iconColor: AppColors.success,
                    title: 'Pusat Bantuan',
                    subtitle: 'FAQ dan dukungan',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.description_rounded,
                    iconColor: AppColors.pink,
                    title: 'Kebijakan Privasi',
                    subtitle: 'Aturan penggunaan data',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.mail_rounded,
                    iconColor: AppColors.accent,
                    title: 'Hubungi Kami',
                    subtitle: 'support@kataplay.app',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Exit section
              _ExitSection(),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimePicker() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Pengingat Belajar'),
        content: const Text('Fitur ini akan hadir segera!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTargetPicker() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Target Harian'),
        content: const Text('Fitur ini akan hadir segera!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Teman Belajar banner at top of settings
class _TemanBelajarBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // Avatar
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text(
                        'P',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -8,
                    right: -4,
                    child: const Text('👑', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Teman Belajar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Level 1',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // XP bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: 0.4,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.25),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '40 / 100 XP',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Dinosaur
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: const [
                  Text('🦕', style: TextStyle(fontSize: 44)),
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Text('⭐', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Settings section with colored dot
class _SettingsSection extends StatelessWidget {
  final String title;
  final Color dotColor;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.dotColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

/// Toggle setting item
class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          // Purple toggle
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

/// Setting item with pill badge
class _SettingsPillItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String? pillText;
  final Color? pillColor;
  final bool showChevron;
  final VoidCallback onTap;

  const _SettingsPillItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.pillText,
    this.pillColor,
    this.showChevron = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            if (pillText != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (pillColor ?? AppColors.primary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  pillText!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: pillColor ?? AppColors.primary,
                  ),
                ),
              ),
            if (showChevron || pillText == null)
              const SizedBox(width: 8),
            if (showChevron)
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey[400],
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

/// Simple setting item
class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// Exit section at bottom
class _ExitSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6), // Light yellow
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text('🚪', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Keluar dari KataPlay',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Sampai jumpa lagi, Teman Belajar! 💜',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Exit button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.error.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.logout_rounded, color: AppColors.error, size: 16),
                SizedBox(width: 6),
                Text(
                  'Keluar',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
