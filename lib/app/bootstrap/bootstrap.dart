import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import '../app.dart';

Future<void> runKataPlay() async {
  await Hive.initFlutter();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init skipped: $e');
  }
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    debugPrint('=== FLUTTER ERROR ===');
    debugPrint(details.exceptionAsString());
    debugPrint(details.stack.toString());
  };
  WidgetsBinding.instance.platformDispatcher.onError = (exception, stackTrace) {
    debugPrint('=== PLATFORM ERROR ===');
    debugPrint('$exception');
    debugPrint('$stackTrace');
    return true;
  };

  runApp(
    const ProviderScope(
      child: KataPlayApp(),
    ),
  );
}
