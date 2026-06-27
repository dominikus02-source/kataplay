import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';

class LessonScaffold extends StatelessWidget {
  final Widget topBar;
  final Widget body;
  final Widget? bottomAction;

  const LessonScaffold({
    super.key,
    required this.topBar,
    required this.body,
    this.bottomAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffoldOuter,
      child: Column(
        children: [
          Container(
            color: AppColors.background,
            child: Center(
              child: SizedBox(
                width: AppDimensions.appMaxWidth,
                child: SafeArea(
                  top: true,
                  bottom: false,
                  child: topBar,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.background,
              width: double.infinity,
              child: Center(
                child: SizedBox(
                  width: AppDimensions.appMaxWidth,
                  child: Material(
                    type: MaterialType.transparency,
                    child: body,
                  ),
                ),
              ),
            ),
          ),
          if (bottomAction != null)
            Container(
              color: AppColors.background,
              child: Center(
                child: SizedBox(
                  width: AppDimensions.appMaxWidth,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 8,
                      ),
                      child: bottomAction!,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
