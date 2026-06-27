import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/bottom_nav.dart';
import '../../../../shared/widgets/progress_bar.dart';
import '../../../../core/providers/providers.dart';

enum _BadgeCategory { all, level, stage, xp, streak }

class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({super.key});

  static final _allBadges = [
    _BadgeData(assetPath: 'assets/Badges/1.png', name: 'Bintang Huruf', condition: 'Level 1', id: 'level_1_complete', category: _BadgeCategory.level),
    _BadgeData(assetPath: 'assets/Badges/2.png', name: 'Raja Suku Kata', condition: 'Level 2', id: 'level_2_complete', category: _BadgeCategory.level),
    _BadgeData(assetPath: 'assets/Badges/3.png', name: 'Sahabat Kata', condition: 'Level 3', id: 'level_3_complete', category: _BadgeCategory.level),
    _BadgeData(assetPath: 'assets/Badges/4.png', name: 'Pembaca Cilik', condition: 'Level 4', id: 'level_4_complete', category: _BadgeCategory.level),
    _BadgeData(assetPath: 'assets/Badges/5.png', name: 'Juara Kalimat', condition: 'Level 5', id: 'level_5_complete', category: _BadgeCategory.level),
    _BadgeData(assetPath: 'assets/Badges/6.png', name: 'Pendongeng', condition: 'Level 6', id: 'level_6_complete', category: _BadgeCategory.level),
    _BadgeData(assetPath: 'assets/Badges/7.png', name: 'Bintang 1', condition: '100 XP', id: 'xp_100', category: _BadgeCategory.xp),
    _BadgeData(assetPath: 'assets/Badges/8.png', name: 'Bintang 2', condition: '500 XP', id: 'xp_500', category: _BadgeCategory.xp),
    _BadgeData(assetPath: 'assets/Badges/9.png', name: 'Bintang 3', condition: '1000 XP', id: 'xp_1000', category: _BadgeCategory.xp),
    _BadgeData(assetPath: 'assets/Badges/10.png', name: 'Streak Api', condition: '3 hari', id: 'streak_3', category: _BadgeCategory.streak),
    _BadgeData(assetPath: 'assets/Badges/11.png', name: 'Streak Berapi', condition: '7 hari', id: 'streak_7', category: _BadgeCategory.streak),
    _BadgeData(assetPath: 'assets/Badges/12.png', name: 'Pelajar Hebat', condition: 'Semua selesai', id: 'all_complete', category: _BadgeCategory.xp),
    _BadgeData(assetPath: 'assets/Badges/13.png', name: 'Perintis Baca', condition: 'Tahap Pra-Baca', id: 'stage_1_complete', category: _BadgeCategory.stage),
    _BadgeData(assetPath: 'assets/Badges/14.png', name: 'Pembaca Pemula', condition: 'Tahap Kelas 1', id: 'stage_2_complete', category: _BadgeCategory.stage),
    _BadgeData(assetPath: 'assets/Badges/15.png', name: 'Pencari Kata', condition: 'Tahap Kelas 2', id: 'stage_3_complete', category: _BadgeCategory.stage),
    _BadgeData(assetPath: 'assets/Badges/16.png', name: 'Ahli Baca', condition: 'Tahap Kelas 3', id: 'stage_4_complete', category: _BadgeCategory.stage),
    _BadgeData(assetPath: 'assets/Badges/17.png', name: 'Dekoder', condition: 'Tahap Kelas 4', id: 'stage_5_complete', category: _BadgeCategory.stage),
    _BadgeData(assetPath: 'assets/Badges/18.png', name: 'Penguasa Literasi', condition: 'Tahap Kelas 5', id: 'stage_6_complete', category: _BadgeCategory.stage),
    _BadgeData(assetPath: 'assets/Badges/19.png', name: 'Sultan Literasi', condition: 'Tahap Kelas 6', id: 'stage_7_complete', category: _BadgeCategory.stage),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final collectedCount = _allBadges.where((b) => b.isCollected(progress)).length;

    return AppScaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppDimensions.bottomContentPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                _buildHeader(collectedCount),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProgressCard(collectedCount),
                      const SizedBox(height: 16),
                      _CollectionGridSection(progress: progress),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
        onTap: (i) => _onNavTap(context, i),
      ),
    );
  }

  Widget _buildHeader(int collectedCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.gold, AppColors.goldLight],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.2),
                  blurRadius: 10, offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Koleksi Badge',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                Text(
                  '$collectedCount dari ${_allBadges.length} terkumpul',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.goldBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
            ),
            child: Text(
              '${(collectedCount / _allBadges.length * 100).toInt()}%',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.goldDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(int collectedCount) {
    final fraction = collectedCount / _allBadges.length;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppDimensions.softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppColors.goldBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Icon(Icons.bar_chart_rounded, size: 20, color: AppColors.gold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Progres Koleksi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    Text('${(fraction * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.gold)),
                  ],
                ),
                const SizedBox(height: 5),
                AppProgressBar(progress: fraction, height: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const _navRoutes = ['/home', '/learning-path', '/collection', '/profile'];

  void _onNavTap(BuildContext context, int index) {
    context.go(_navRoutes[index]);
  }
}

class _CollectionGridSection extends StatefulWidget {
  final ProgressState progress;
  const _CollectionGridSection({required this.progress});

  @override
  State<_CollectionGridSection> createState() => _CollectionGridSectionState();
}

class _CollectionGridSectionState extends State<_CollectionGridSection> {
  _BadgeCategory _selectedCategory = _BadgeCategory.all;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoryTabs(),
        const SizedBox(height: 14),
        _buildGrid(),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    final tabs = [
      (_BadgeCategory.all, 'Semua'),
      (_BadgeCategory.level, 'Tingkat'),
      (_BadgeCategory.stage, 'Tahap'),
      (_BadgeCategory.xp, 'XP'),
      (_BadgeCategory.streak, 'Rentetan'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          final isSelected = _selectedCategory == tab.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = tab.$1),
              child: AnimatedContainer(
                duration: AppDimensions.durationNormal,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.textLight.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 6, offset: const Offset(0, 2))]
                      : null,
                ),
                child: Text(
                  tab.$2,
                  style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGrid() {
    final filtered = _selectedCategory == _BadgeCategory.all
        ? CollectionScreen._allBadges
        : CollectionScreen._allBadges.where((b) => b.category == _selectedCategory).toList();

    if (filtered.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        width: double.infinity,
        child: Column(
          children: [
            Icon(Icons.search_rounded, size: 36, color: AppColors.textLight.withValues(alpha: 0.35)),
            const SizedBox(height: 8),
            Text('Belum ada badge di kategori ini', style: TextStyle(fontSize: 12, color: AppColors.textSecondary.withValues(alpha: 0.7))),
          ],
        ),
      );
    }

    final crossAxisCount = filtered.length <= 4 ? 2 : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final badge = filtered[index];
        final isCollected = badge.isCollected(widget.progress);
        return _buildBadgeCard(badge, isCollected);
      },
    );
  }

  Widget _buildBadgeCard(_BadgeData badge, bool isCollected) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCollected
              ? AppColors.correct.withValues(alpha: 0.2)
              : AppColors.textLight.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6, offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Opacity(
                  opacity: isCollected ? 1.0 : 0.5,
                  child: Image.asset(
                    badge.assetPath,
                    width: 52, height: 52,
                    fit: BoxFit.contain,
                    errorBuilder: (_, e, s) => Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.goldBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.emoji_events_rounded, size: 24, color: AppColors.gold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                badge.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700,
                  color: isCollected ? AppColors.textPrimary : AppColors.textLight,
                  height: 1.2,
                ),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isCollected
                      ? AppColors.correctBg
                      : AppColors.textLight.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  isCollected ? 'Terkumpul' : badge.condition,
                  style: TextStyle(
                    fontSize: 8, fontWeight: FontWeight.w600,
                    color: isCollected ? AppColors.correct : AppColors.textLight.withValues(alpha: 0.6),
                    height: 1.1,
                  ),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (isCollected)
            Positioned(
              top: 2, right: 2,
              child: Container(
                width: 16, height: 16,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.correct, AppColors.correctLight],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, size: 10, color: Colors.white),
              ),
            ),
          if (!isCollected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Container(
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4),
                      ],
                    ),
                    child: Icon(Icons.lock_rounded, size: 12, color: AppColors.iconLock),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BadgeData {
  final String assetPath;
  final String name;
  final String condition;
  final String id;
  final _BadgeCategory category;

  const _BadgeData({
    required this.assetPath,
    required this.name,
    required this.condition,
    required this.id,
    this.category = _BadgeCategory.all,
  });

  bool isCollected(ProgressState progress) {
    return progress.progress.collectedBadges.contains(id);
  }
}
