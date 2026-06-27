import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigationBar;

  const AppScaffold({
    super.key,
    required this.body,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffoldOuter,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: AppColors.background,
              width: double.infinity,
              child: Center(
                child: SizedBox(
                  width: AppDimensions.appMaxWidth,
                  child: body,
                ),
              ),
            ),
          ),
          if (bottomNavigationBar != null)
            Center(
              child: SizedBox(
                width: AppDimensions.appMaxWidth,
                child: bottomNavigationBar!,
              ),
            ),
        ],
      ),
    );
  }
}
