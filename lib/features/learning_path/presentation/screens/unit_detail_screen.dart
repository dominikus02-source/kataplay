import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/progress_bar.dart';
import '../../../../core/providers/providers.dart';
import '../../../curriculum/application/curriculum_provider.dart';
import '../../../curriculum/domain/curriculum_stage.dart';
import '../../../curriculum/domain/curriculum_unit.dart';
import '../../../curriculum/domain/curriculum_lesson.dart';

class UnitDetailScreen extends ConsumerWidget {
  final String stageId;

  const UnitDetailScreen({super.key, required this.stageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final curriculumState = ref.watch(curriculumProvider);
    final catalog = curriculumState.catalog;
    final stage = catalog?.stages.where((s) => s.id == stageId).firstOrNull;

    if (stage == null) {
      return AppScaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textLight),
              const SizedBox(height: 12),
              const Text('Tahap tidak ditemukan', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/learning-path'),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      );
    }

    final completedIds = progress.progress.completedLessonIds.toList();
    final stageIndex = stage.order - 1;
    final color = AppColors.levelColors[stageIndex % AppColors.levelColors.length];
    final bgColor = AppColors.levelBgColors[stageIndex % AppColors.levelBgColors.length];

    final allLessons = _getAllLessons(stage);
    final completedCount = allLessons.where((l) => completedIds.contains(l.id)).length;

    return AppScaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(stage, color, context),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                _buildProgressCard(stage, completedCount, allLessons.length, color),
                const SizedBox(height: 16),
                ...stage.units.map((unit) => _buildUnitCard(unit, stage, completedIds, color, bgColor, context)),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(CurriculumStage stage, Color color, BuildContext context) {
    return SliverAppBar(
      expandedHeight: 80,
      pinned: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      leading: IconButton(
        icon: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: const Icon(Icons.arrow_back_rounded, size: 18, color: AppColors.textPrimary),
        ),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Row(
          children: [
            Text(stage.icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              stage.title,
              style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        titlePadding: const EdgeInsets.only(left: 72, bottom: 12),
      ),
    );
  }

  Widget _buildProgressCard(CurriculumStage stage, int completed, int total, Color color) {
    final fraction = total > 0 ? completed / total : 0.0;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.06), Colors.white],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.trending_up_rounded, size: 20, color: color),
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
                    Text('$completed dari $total pelajaran', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    Text('${(fraction * 100).toInt()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color)),
                  ],
                ),
                const SizedBox(height: 6),
                AppProgressBar(progress: fraction, height: 6, color: color),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitCard(CurriculumUnit unit, CurriculumStage stage, List<String> completedIds, Color color, Color bgColor, BuildContext context) {
    final completedInUnit = unit.lessons.where((l) => completedIds.contains(l.id)).length;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10, offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${unit.order}',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        unit.title,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$completedInUnit/${unit.lessons.length} selesai',
                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppIcons.xp(size: 10),
                      const SizedBox(width: 3),
                      Text(
                        '${unit.lessons.fold(0, (sum, l) => sum + l.xpReward)}',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(unit.lessons.length, (i) {
            final lesson = unit.lessons[i];
            final isCompleted = completedIds.contains(lesson.id);
            final isUnlocked = lesson.requiredCompletedLessons <= completedIds.length;
            return _buildLessonTile(lesson, isCompleted, isUnlocked, i, unit.lessons.length, color, context);
          }),
        ],
      ),
    );
  }

  Widget _buildLessonTile(CurriculumLesson lesson, bool isCompleted, bool isUnlocked, int index, int total, Color color, BuildContext context) {
    return Column(
      children: [
        if (index > 0)
          Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: AppColors.textLight.withValues(alpha: 0.08)),
        GestureDetector(
          onTap: isUnlocked
              ? () => context.push('/lesson-engine', extra: {'lessonId': lesson.id})
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.correct
                        : isUnlocked
                            ? color
                            : AppColors.textLight.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                        : isUnlocked
                            ? Text(
                                '${lesson.order}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                              )
                            : Icon(Icons.lock_rounded, size: 14, color: AppColors.textLight.withValues(alpha: 0.4)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600,
                          color: isCompleted
                              ? AppColors.correct
                              : isUnlocked
                                  ? AppColors.textPrimary
                                  : AppColors.textLight,
                        ),
                      ),
                      if (lesson.subtitle.isNotEmpty)
                        Text(
                          lesson.subtitle,
                          style: TextStyle(
                            fontSize: 10,
                            color: isUnlocked ? AppColors.textSecondary : AppColors.textLight,
                          ),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.correctBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIcons.xp(size: 10),
                        const SizedBox(width: 3),
                        Text(
                          '+${lesson.xpReward}',
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.correct),
                        ),
                      ],
                    ),
                  )
                else if (isUnlocked)
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.play_arrow_rounded, size: 16, color: color),
                  )
                else
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.textLight.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.lock_rounded, size: 12, color: AppColors.textLight.withValues(alpha: 0.3)),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<CurriculumLesson> _getAllLessons(CurriculumStage stage) {
    final lessons = <CurriculumLesson>[];
    for (final unit in stage.units) {
      lessons.addAll(unit.lessons);
    }
    return lessons;
  }
}
