import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/bottom_nav.dart';
import '../../../../shared/widgets/kata_decorations.dart';
import '../../../../core/providers/providers.dart';
import '../../../../features/lesson/data/level_content.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    return AppScaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppDimensions.bottomContentPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                _buildHeader(progress),
                const SizedBox(height: 14),
                _buildHeroScene(context, progress),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildActivityGrid(context),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildProgressCard(context, progress),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onTap: (i) => _onNavTap(context, i),
      ),
    );
  }

  Widget _buildHeader(ProgressState progress) {
    final name = progress.childName.isEmpty ? 'KataPlayer' : progress.childName;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                progress.selectedAvatarPath,
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => Icon(
                  Icons.face_rounded, size: 24,
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, $name!',
                  style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary, height: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Siap bermain kata?',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          _buildXpBadge(progress),
        ],
      ),
    );
  }

  Widget _buildXpBadge(ProgressState progress) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gold, AppColors.goldLight],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.25),
            blurRadius: 6, offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 14, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            '${progress.xp}',
            style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroScene(BuildContext context, ProgressState progress) {
    final isComplete = progress.completedLessonCount > 0;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [
            Color(0xFF8B4DFF),
            Color(0xFFB78CFF),
            Color(0xFFBFE2FF),
            Color(0xFF4DD0E1),
          ],
          stops: const [0.0, 0.35, 0.7, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 20, offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 160,
          maxHeight: MediaQuery.of(context).size.height * 0.3,
        ),
        child: Stack(
          children: [
            SoftBlob(top: -30, left: -30, size: 120, color: Colors.white, opacity: 0.08),
            SoftBlob(top: 60, left: 140, size: 50, color: Colors.white, opacity: 0.06),
            SparkleDot(top: 20, left: 40, size: 7, color: Colors.white, opacity: 0.25),
            SparkleDot(top: 50, right: 100, size: 4, color: Colors.white, opacity: 0.2),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, size: 12, color: Colors.white.withValues(alpha: 0.9)),
                          const SizedBox(width: 3),
                          Text(
                            'Level ${progress.levelNumber}',
                            style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isComplete ? 'Lanjutkan\npetualanganmu' : 'Ayo bermain\nkata!',
                            style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w900,
                              color: Colors.white, height: 1.1,
                              shadows: [
                                Shadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                              ],
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isComplete
                                ? 'Tantangan makin seru!'
                                : 'Belajar jadi seru bersama Zelby.',
                            style: TextStyle(
                              fontSize: 12, color: Colors.white.withValues(alpha: 0.9), height: 1.3,
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 12),
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8, offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Mulai Belajar',
                                    style: TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -10,
              bottom: -10,
              child: Image.asset(
                'assets/characters/zelby_happy.png',
                width: 140,
                height: 140,
                fit: BoxFit.contain,
                errorBuilder: (_, e, s) => Icon(
                  Icons.smart_toy_rounded, size: 70,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.go('/learning-path'),
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityGrid(BuildContext context) {
    final cards = [
      ('Mengenal Huruf', 'assets/card_home/mengenal_huruf.png', AppColors.levelColors[0]),
      ('Suku Kata', 'assets/card_home/suku_kata.png', AppColors.levelColors[1]),
      ('Membaca', 'assets/card_home/Membaca.png', AppColors.levelColors[2]),
      ('Cerita', 'assets/card_home/cerita_pendek.png', AppColors.levelColors[3]),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Container(
                width: 26, height: 26,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.rocket_launch_rounded, size: 14, color: AppColors.primary),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Aktivitas Belajar',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/learning-path'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Semua',
                        style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600,
                          color: AppColors.primary.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.arrow_forward_rounded, size: 13, color: AppColors.primary.withValues(alpha: 0.8)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            final (label, assetPath, color) = cards[index];
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.go('/learning-path'),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: const Color(0xFFFDF8EE),
                      child: Image.asset(
                        assetPath,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) => _buildFallbackCard(label, color),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFallbackCard(String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.auto_stories_rounded, color: Colors.white, size: 22),
          ),
          const Spacer(),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, ProgressState progress) {
    final levels = LevelContent.allLevels;
    if (levels.isEmpty) return const SizedBox();

    int currentLevelIndex = 0;
    for (int i = 0; i < levels.length; i++) {
      final lvl = levels[i];
      final completed = lvl.lessons.every((l) => progress.isLessonCompleted(l.id));
      if (!completed) { currentLevelIndex = i; break; }
      currentLevelIndex = i + 1;
    }
    if (currentLevelIndex >= levels.length) currentLevelIndex = levels.length - 1;
    if (currentLevelIndex < 0 || currentLevelIndex >= levels.length) return const SizedBox();

    final currentLevel = levels[currentLevelIndex];
    final completedCount = currentLevel.lessons.where((l) => progress.isLessonCompleted(l.id)).length;
    final totalCount = currentLevel.lessons.length;
    final levelProgress = totalCount > 0 ? completedCount / totalCount : 0.0;
    final color = AppColors.levelColors[currentLevelIndex % AppColors.levelColors.length];

    return GestureDetector(
      onTap: () => context.go('/learning-path'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(AppIcons.fromEmoji(currentLevel.icon), color: Colors.white, size: 24),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Level ${currentLevel.levelNumber}',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: color),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$completedCount/$totalCount',
                        style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentLevel.title,
                    style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: levelProgress,
                      backgroundColor: Colors.grey.withValues(alpha: 0.06),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8, offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  static const _navRoutes = ['/home', '/learning-path', '/collection', '/profile'];

  void _onNavTap(BuildContext context, int index) {
    context.go(_navRoutes[index]);
  }
}
