import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/data/hive_boxes.dart';
import 'core/error/error_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize global error handler
  KataPlayErrorHandler.init();

  // Initialize Hive for offline storage
  await Hive.initFlutter();

  // Open all required boxes
  await Hive.openBox(HiveBoxes.userProgress);
  await Hive.openBox(HiveBoxes.gameProgress);
  await Hive.openBox(HiveBoxes.onboarding);
  await Hive.openBox(HiveBoxes.settings);

  runApp(
    const ProviderScope(
      child: KataPlayApp(),
    ),
  );
}

class KataPlayApp extends ConsumerWidget {
  const KataPlayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'KataPlay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
