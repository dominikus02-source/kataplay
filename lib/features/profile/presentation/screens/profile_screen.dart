import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../utils/constants.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/bottom_nav.dart';
import '../../../../shared/widgets/progress_bar.dart';
import '../../../../core/providers/providers.dart';
import 'avatar_picker_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = ref.read(progressProvider).childName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveName() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      ref.read(progressProvider.notifier).setChildName(name);
    }
    setState(() => _isEditingName = false);
  }

  void _openAvatarPicker(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const AvatarPickerScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final name = progress.childName.isEmpty ? 'KataPlayer' : progress.childName;

    return AppScaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppDimensions.bottomContentPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                children: [
                  _buildProfileHero(context, progress, name),
                  const SizedBox(height: 20),
                  _buildStatsRow(progress),
                  const SizedBox(height: 20),
                  _buildXpCard(progress),
                  const SizedBox(height: 20),
                  _buildSettingsSection(context),
                  const SizedBox(height: 16),
                  _buildAboutSection(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: 3, onTap: (i) => _onNavTap(context, i)),
    );
  }

  Widget _buildProfileHero(BuildContext context, ProgressState progress, String name) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.goldBg,
            AppColors.zelbyBg,
            AppColors.primaryBg,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.zelbyColor.withValues(alpha: 0.1), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: AppColors.zelbyColor.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        progress.selectedAvatarPath,
                        fit: BoxFit.contain,
                        errorBuilder: (_, e, s) => Image.asset('assets/characters/alby_happy.png', fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: -2,
                    child: GestureDetector(
                      onTap: () => _openAvatarPicker(context),
                      child: Container(
                        width: 26, height: 26,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryLight],
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                        ),
                        child: const Icon(Icons.edit_rounded, color: Colors.white, size: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _isEditingName ? _buildNameEditor() : _buildNameDisplay(name),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome_rounded, size: 14, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Text('Level ${progress.levelNumber}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.goldDark)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 12, color: AppColors.gold),
                    const SizedBox(width: 3),
                    Text('${progress.xp} XP', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.goldDark)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNameDisplay(String name) {
    return GestureDetector(
      onTap: () => setState(() => _isEditingName = true),
      child: Row(
        children: [
          Flexible(
            child: Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.edit_rounded, size: 14, color: AppColors.textLight.withValues(alpha: 0.5)),
        ],
      ),
    );
  }

  Widget _buildNameEditor() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Nama kamu',
                border: InputBorder.none,
                hintStyle: TextStyle(color: AppColors.textLight, fontSize: 15),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              onSubmitted: (_) => _saveName(),
            ),
          ),
          GestureDetector(
            onTap: _saveName,
            child: Container(
              width: 24, height: 24,
              decoration: BoxDecoration(color: AppColors.correct, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ProgressState progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppDimensions.softShadow,
      ),
      child: Row(
        children: [
          _statItem(AppIcons.xp(size: 20), '${progress.xp}', 'XP', AppColors.goldBg, AppColors.gold),
          _divider(),
          _statItem(AppIcons.streak(size: 20), '${progress.streak}', 'Rentetan', AppColors.primaryBg, AppColors.primary),
          _divider(),
          _statItem(AppIcons.badge(size: 20), '${progress.completedLessonCount}', 'Selesai', AppColors.tertiaryBg, AppColors.tertiary),
        ],
      ),
    );
  }

  Widget _statItem(Widget icon, String value, String label, Color bg, Color accent) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
            ),
            child: Center(child: icon),
          ),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: accent)),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 32, color: AppColors.textLight.withValues(alpha: 0.1));
  }

  Widget _buildXpCard(ProgressState progress) {
    final xpInLevel = progress.xpInCurrentLevel;
    final xpNeeded = 200;
    final fraction = (xpInLevel / xpNeeded).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppDimensions.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: AppColors.goldBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: AppIcons.xp(size: 16)),
              ),
              const SizedBox(width: 10),
              const Text('Naik Level', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const Spacer(),
              Text('${(fraction * 100).toInt()}%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.gold)),
            ],
          ),
          const SizedBox(height: 10),
          AppProgressBar(progress: fraction, height: 7, color: AppColors.gold),
          const SizedBox(height: 6),
          Text(
            '$xpInLevel / $xpNeeded XP (${xpNeeded - xpInLevel} XP lagi)',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppDimensions.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
            child: Row(
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.settings_rounded, size: 16, color: AppColors.primary),
                ),
                const SizedBox(width: 8),
                const Text('Pengaturan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              ],
            ),
          ),
          _settingsTile(
            icon: Icons.volume_up_rounded,
            title: 'Suara',
            trailing: Consumer(
              builder: (context, ref, _) {
                final settings = ref.watch(settingsProvider);
                return SizedBox(
                  width: 44, height: 24,
                  child: Switch.adaptive(
                    value: settings.soundEnabled,
                    activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
                    onChanged: (val) => ref.read(settingsProvider.notifier).setSoundEnabled(val),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                );
              },
            ),
          ),
          _settingsTileDivider(),
          _settingsTile(
            icon: Icons.music_note_rounded,
            title: 'Musik',
            trailing: Consumer(
              builder: (context, ref, _) {
                final settings = ref.watch(settingsProvider);
                return SizedBox(
                  width: 44, height: 24,
                  child: Switch.adaptive(
                    value: settings.musicEnabled,
                    activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
                    onChanged: (val) => ref.read(settingsProvider.notifier).setMusicEnabled(val),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                );
              },
            ),
          ),
          _settingsTileDivider(),
          _settingsTile(
            icon: Icons.refresh_rounded,
            title: 'Atur Ulang',
            trailing: Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textLight),
            onTap: () => _showResetProgressDialog(context),
          ),
          _settingsTileDivider(),
          _settingsTile(
            icon: Icons.exit_to_app_rounded,
            title: 'Keluar',
            trailing: Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textLight),
            onTap: () => _showExitDialog(context),
          ),
          _settingsTileDivider(),
          _settingsTile(
            icon: Icons.tune_rounded,
            title: 'Pengaturan Lengkap',
            trailing: Icon(Icons.open_in_new_rounded, size: 18, color: AppColors.primary),
            onTap: () => context.go('/settings'),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: AppColors.primaryBg.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 14, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _settingsTileDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 58, right: 18),
      child: Divider(height: 1, color: AppColors.textLight.withValues(alpha: 0.08)),
    );
  }

  void _showResetProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Atur Ulang?', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        content: const Text('Semua XP, rentetan, dan badge akan dihapus.', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              ref.read(progressProvider.notifier).resetProgress();
              Navigator.pop(ctx);
            },
            child: const Text('Atur Ulang', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.wrong)),
          ),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar dari KataPlay?', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        content: const Text('Progress kamu tetap tersimpan.', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/onboarding');
            },
            child: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              color: AppColors.primaryBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(child: Icon(Icons.info_rounded, size: 12, color: AppColors.primary)),
          ),
          const SizedBox(height: 6),
          Text('KataPlay v${AppConstants.appVersion}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          const SizedBox(height: 2),
          const Text('Belajar Bahasa Indonesia untuk Anak', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
          const SizedBox(height: 6),
          const Text('© 2024-2026 BahasaCerdas', style: TextStyle(fontSize: 9, color: AppColors.textLight)),
        ],
      ),
    );
  }

  static const _navRoutes = ['/home', '/learning-path', '/collection', '/profile'];

  void _onNavTap(BuildContext context, int index) {
    context.go(_navRoutes[index]);
  }
}
