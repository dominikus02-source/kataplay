import 'package:flutter/material.dart';

class QuestionTransitionWrapper extends StatelessWidget {
  final int index;
  final Widget child;

  const QuestionTransitionWrapper({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 380),
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      transitionBuilder: (child, animation) {
        final slideTween = Tween<Offset>(
          begin: const Offset(0.3, 0),
          end: Offset.zero,
        );
        final fadeTween = Tween<double>(begin: 0, end: 1);
        final scaleTween = Tween<double>(begin: 0.95, end: 1.0);

        return SlideTransition(
          position: slideTween.animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
          ),
          child: FadeTransition(
            opacity: fadeTween.animate(animation),
            child: ScaleTransition(
              scale: scaleTween.animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey(index),
        child: child,
      ),
    );
  }
}
