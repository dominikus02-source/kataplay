import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/avatar_repository.dart';
import '../../domain/avatar_item.dart';
import '../../../../core/providers/providers.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';

class AvatarPickerScreen extends ConsumerStatefulWidget {
  const AvatarPickerScreen({super.key});

  @override
  ConsumerState<AvatarPickerScreen> createState() => _AvatarPickerScreenState();
}

class _AvatarPickerScreenState extends ConsumerState<AvatarPickerScreen> {
  AvatarCategory _selectedCategory = AvatarCategory.all;

  static const _categoryTabs = [
    _CategoryTab(AvatarCategory.all, 'Semua'),
    _CategoryTab(AvatarCategory.avatar, 'Karakter'),
  ];

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final currentId = progress.selectedAvatarId;
    final avatars = AvatarRepository.getByCategory(_selectedCategory);

    return Container(
      color: AppColors.scaffoldOuter,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: AppColors.background,
                width: double.infinity,
                child: Center(
                  child: SizedBox(
                    width: AppDimensions.appMaxWidth,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Column(
                        children: [
                          SizedBox(
                            width: AppDimensions.appMaxWidth,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 6, 4, 0),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
                                    onPressed: () => Navigator.pop(context),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                                  ),
                                  const Spacer(),
                                  const Text(
                                    'Pilih Avatar',
                                    style: TextStyle(
                                      color: AppColors.textPrimary, fontWeight: FontWeight.w800, fontSize: 18,
                                    ),
                                  ),
                                  const Spacer(),
                                  const SizedBox(width: 40),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 4),
                        _buildCategoryTabs(),
                        const SizedBox(height: 8),
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).padding.bottom + 32),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 1,
                            ),
                            itemCount: avatars.length,
                            itemBuilder: (context, index) {
                              final avatar = avatars[index];
                              final isSelected = avatar.id == currentId;
                              return _AvatarGridItem(
                                avatar: avatar,
                                isSelected: isSelected,
                                onTap: () {
                                  ref.read(progressProvider.notifier).setSelectedAvatar(avatar.id, avatar.assetPath);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 44,
      child: Center(
        child: SizedBox(
          width: AppDimensions.appMaxWidth,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categoryTabs.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final tab = _categoryTabs[index];
              final isActive = tab.category == _selectedCategory;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = tab.category),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? LinearGradient(colors: [AppColors.primary, AppColors.primaryLight], begin: Alignment.topLeft, end: Alignment.bottomRight)
                        : null,
                    color: isActive ? null : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isActive ? AppColors.primary : AppColors.textLight.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    boxShadow: isActive
                        ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 6, offset: const Offset(0, 2))]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      tab.label,
                      style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700,
                        color: isActive ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AvatarGridItem extends StatelessWidget {
  final AvatarItem avatar;
  final bool isSelected;
  final VoidCallback onTap;

  const _AvatarGridItem({
    required this.avatar,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDimensions.durationFast,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppColors.primary.withValues(alpha: 0.06), Colors.white],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.textLight.withValues(alpha: 0.12),
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 12, offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6, offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  avatar.assetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(Icons.broken_image_rounded, color: AppColors.textLight, size: 36),
                  ),
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                top: 4, right: 4,
                child: Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryLight], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 1))],
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTab {
  final AvatarCategory category;
  final String label;
  const _CategoryTab(this.category, this.label);
}
