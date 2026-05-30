import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for offline storage
  await Hive.initFlutter();
  // Open boxes for user progress, rewards, etc. (will be registered in later phases)
  await Hive.openBox('user_progress');
  await Hive.openBox('game_progress');

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
