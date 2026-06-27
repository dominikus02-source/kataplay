import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/bottom_nav.dart';
import '../../../../shared/widgets/level_path_card.dart';
import '../../../../shared/widgets/kata_decorations.dart';
import '../../../../core/providers/providers.dart';
import '../../../../features/lesson/data/level_content.dart';
import '../../../curriculum/application/curriculum_provider.dart';
import '../../../curriculum/domain/curriculum_catalog.dart';
import '../../../curriculum/domain/curriculum_stage.dart';
import '../../../curriculum/domain/curriculum_lesson.dart';

class LearningPathScreen extends ConsumerWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final curriculumState = ref.watch(curriculumProvider);
    final catalog = curriculumState.catalog;
    return AppScaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Stack(
          children: [
          SoftBlob(top: -40, right: -50, size: 160, color: AppColors.secondary, opacity: 0.04),
          SoftBlob(top: 180, left: -30, size: 100, color: AppColors.primary, opacity: 0.04),
          SoftBlob(bottom: 150, right: -30, size: 120, color: AppColors.tertiary, opacity: 0.04),
          SparkleDot(top: 60, right: 40, size: 6, color: AppColors.primary, opacity: 0.08),
          SparkleDot(top: 280, left: 30, size: 4, color: AppColors.tertiary, opacity: 0.06),
          SparkleDot(bottom: 350, right: 50, size: 5, color: AppColors.gold, opacity: 0.06),
            Column(
              children: [
                _buildHeader(progress, catalog),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGuideCard(progress, catalog),
                      const SizedBox(height: 24),
                      _buildAdventureLabel(),
                      const SizedBox(height: 16),
                      if (catalog != null)
                        _buildLevelPath(progress, catalog, context)
                      else if (curriculumState.isLoading)
                        _buildLoadingState()
                      else
                        _buildLegacyLevelPath(progress, context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onTap: (i) => _onNavTap(context, i),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'Memuat petualangan...',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ProgressState progress, CurriculumCatalog? catalog) {
    final completed = progress.completedLessonCount;
    int total = LevelContent.totalLessons;
    if (catalog != null) {
      total = catalog.totalLessons;
    }
    final ratio = total > 0 ? completed / total : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary.withValues(alpha: 0.06), AppColors.tertiary.withValues(alpha: 0.04)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0.05)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: AppIcons.rocket(size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Petualanganmu',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.1),
                    ),
                    Text(
                      '$completed/$total misi selesai',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.goldBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.3), width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcons.xp(size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${progress.xp} XP',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.goldDark),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Progres', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
              Text('${(ratio * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: AppColors.primary.withValues(alpha: 0.08),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(ProgressState progress, CurriculumCatalog? catalog) {
    int total = LevelContent.totalLessons;
    if (catalog != null) {
      total = catalog.totalLessons;
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.zelbyBg, Colors.white],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.zelbyColor.withValues(alpha: 0.12), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: Colors.white, shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: AppColors.zelbyColor.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: ClipOval(
              child: Image.asset('assets/characters/zelby_happy.png', fit: BoxFit.contain,
                errorBuilder: (_, e, s) => AppIcons.learn(size: 26)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih petualanganmu!',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                Text(
                  '${progress.completedLessonCount}/$total misi selesai',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded, color: AppColors.zelbyColor, size: 20),
        ],
      ),
    );
  }

  Widget _buildAdventureLabel() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0.04)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcons.rocket(size: 14),
              const SizedBox(width: 6),
              const Text(
                'Jalur Petualangan',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLevelPath(ProgressState progress, CurriculumCatalog catalog, BuildContext context) {
    final stages = catalog.stages;
    final completedIds = progress.progress.completedLessonIds.toList();
    return Column(
      children: List.generate(stages.length, (index) {
        final stage = stages[index];
        final stageIndex = stage.order - 1;
        final isUnlocked = stageIndex == 0 ||
            _isStageUnlocked(stage, catalog, completedIds);
        final allLessonsInStage = _getAllLessonsInStage(stage);
        final isCompleted = allLessonsInStage
            .every((l) => completedIds.contains(l.id));
        final completedCount = allLessonsInStage
            .where((l) => completedIds.contains(l.id))
            .length;
        final stageProgress =
            allLessonsInStage.isEmpty ? 0.0 : completedCount / allLessonsInStage.length;
        final color = AppColors.levelColors[index % AppColors.levelColors.length];
        final bgColor = AppColors.levelBgColors[index % AppColors.levelBgColors.length];

        final isPrevCompleted = index == 0 ||
            _getAllLessonsInStage(stages[index - 1])
                .every((l) => completedIds.contains(l.id));
        final prevColor = AppColors.levelColors[(index - 1) % AppColors.levelColors.length];

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (index > 0)
              _buildConnector(
                isCompletedPreviously: isPrevCompleted,
                index: index,
                prevColor: prevColor,
                currColor: color,
              ),
            Padding(
              padding: EdgeInsets.only(
                left: index.isEven ? 0.0 : 24.0,
                right: index.isEven ? 24.0 : 0.0,
              ),
              child: LevelPathCard(
                levelNumber: stage.order,
                title: stage.title,
                description: stage.units.firstOrNull?.title ?? stage.gradeBand,
                icon: stage.icon,
                isUnlocked: isUnlocked,
                isCompleted: isCompleted,
                progress: stageProgress,
                levelColor: color,
                bgColor: bgColor,
                onTap: isUnlocked
                    ? () => _navigateToStage(stage, completedIds, context)
                    : null,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLegacyLevelPath(ProgressState progress, BuildContext context) {
    final levels = LevelContent.allLevels;
    return Column(
      children: List.generate(levels.length, (index) {
        final level = levels[index];
        final levelIndex = level.levelNumber - 1;
        final isUnlocked = progress.isLevelUnlocked(levelIndex);
        final isCompleted = level.lessons.every((l) => progress.isLessonCompleted(l.id));
        final completedCount = level.lessons.where((l) => progress.isLessonCompleted(l.id)).length;
        final levelProgress = level.lessons.isEmpty ? 0.0 : completedCount / level.lessons.length;
        final color = AppColors.levelColors[levelIndex % AppColors.levelColors.length];
        final bgColor = AppColors.levelBgColors[levelIndex % AppColors.levelBgColors.length];

        final prevIndex = (index - 1) % AppColors.levelColors.length;
        final isPrevCompleted = index == 0 || levels[index - 1].lessons.every((l) => progress.isLessonCompleted(l.id));
        final prevColor = AppColors.levelColors[prevIndex < 0 ? 0 : prevIndex];

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (index > 0)
              _buildConnector(
                isCompletedPreviously: isPrevCompleted,
                index: index,
                prevColor: prevColor,
                currColor: color,
              ),
            Padding(
              padding: EdgeInsets.only(
                left: index.isEven ? 0.0 : 24.0,
                right: index.isEven ? 24.0 : 0.0,
              ),
              child: LevelPathCard(
                levelNumber: level.levelNumber,
                title: level.title,
                description: level.description,
                icon: level.icon,
                isUnlocked: isUnlocked,
                isCompleted: isCompleted,
                progress: levelProgress,
                levelColor: color,
                bgColor: bgColor,
                onTap: isUnlocked
                    ? () => context.push('/lesson-engine', extra: {'levelIndex': levelIndex})
                    : null,
              ),
            ),
          ],
        );
      }),
    );
  }

  List<CurriculumLesson> _getAllLessonsInStage(CurriculumStage stage) {
    final lessons = <CurriculumLesson>[];
    for (final unit in stage.units) {
      lessons.addAll(unit.lessons);
    }
    return lessons;
  }

  bool _isStageUnlocked(CurriculumStage stage, CurriculumCatalog catalog, List<String> completedIds) {
    final prevStageOrder = stage.order - 1;
    if (prevStageOrder < 1) return true;
    final prevStage = catalog.stages.where((s) => s.order == prevStageOrder).firstOrNull;
    if (prevStage == null) return true;
    final prevLessons = _getAllLessonsInStage(prevStage);
    return prevLessons.every((l) => completedIds.contains(l.id));
  }

  void _navigateToStage(CurriculumStage stage, List<String> completedIds, BuildContext context) {
    context.push('/unit-detail', extra: {'stageId': stage.id});
  }

  Widget _buildConnector({
    required bool isCompletedPreviously,
    required int index,
    required Color prevColor,
    required Color currColor,
  }) {
    final zigZag = index % 2 == 1;
    final mainColor = isCompletedPreviously ? AppColors.correct : prevColor;

    return SizedBox(
      height: 48,
      child: Center(
        child: Row(
          children: [
            if (zigZag) const Spacer(),
            SizedBox(
              width: 32,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 4, height: 12,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          mainColor.withValues(alpha: 0.5),
                          mainColor.withValues(alpha: 0.15),
                        ],
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 12, height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompletedPreviously ? AppColors.correct : mainColor.withValues(alpha: 0.4),
                      border: Border.all(
                        color: isCompletedPreviously ? Colors.white : Colors.white.withValues(alpha: 0.6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: mainColor.withValues(alpha: 0.15),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 4, height: 16,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          mainColor.withValues(alpha: 0.15),
                          isCompletedPreviously ? AppColors.correct.withValues(alpha: 0.3) : currColor.withValues(alpha: 0.08),
                        ],
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
            if (!zigZag) const Spacer(),
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
