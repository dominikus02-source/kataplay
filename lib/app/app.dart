import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/router.dart';
import 'theme/app_theme.dart';

class KataPlayApp extends ConsumerWidget {
  const KataPlayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'KataPlay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: _KataPlayTransitionBuilder(),
            TargetPlatform.iOS: _KataPlayTransitionBuilder(),
            TargetPlatform.macOS: _KataPlayTransitionBuilder(),
          },
        ),
      ),
      routerConfig: router,
      builder: (context, child) {
        return DefaultTextStyle(
          style: const TextStyle(
            decoration: TextDecoration.none,
            fontFamily: 'Nunito',
          ),
          child: child!,
        );
      },
    );
  }
}

class _KataPlayTransitionBuilder extends PageTransitionsBuilder {
  const _KataPlayTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.3, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
