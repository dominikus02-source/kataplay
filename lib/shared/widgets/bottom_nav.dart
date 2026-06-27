import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _tabs = [
    _NavItem(Icons.home_outlined, Icons.home_rounded, 'Beranda'),
    _NavItem(Icons.auto_stories_outlined, Icons.auto_stories_rounded, 'Belajar'),
    _NavItem(Icons.collections_bookmark_outlined, Icons.collections_bookmark_rounded, 'Koleksi'),
    _NavItem(Icons.person_outlined, Icons.person_rounded, 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final bottomPad = bottom > 0 ? bottom + 6.0 : 12.0;

    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.bottomNavMarginH,
        right: AppDimensions.bottomNavMarginH,
        bottom: bottomPad,
      ),
      child: Container(
        height: AppDimensions.bottomNavHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.bottomNavRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final isSelected = index == currentIndex;
            final tab = _tabs[index];

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: AppDimensions.durationNormal,
                      curve: Curves.easeOutBack,
                      width: isSelected ? 40 : 28,
                      height: isSelected ? 40 : 28,
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [AppColors.primary, AppColors.primaryLight],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isSelected ? null : Colors.transparent,
                        shape: BoxShape.circle,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        isSelected ? tab.activeIcon : tab.icon,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary.withValues(alpha: 0.5),
                        size: isSelected ? 22 : 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tab.label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isSelected ? 13 : 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary.withValues(alpha: 0.6),
                        height: 1.1,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(this.icon, this.activeIcon, this.label);
}
