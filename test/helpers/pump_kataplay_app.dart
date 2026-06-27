import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:kataplay_2/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:kataplay_2/features/home/presentation/screens/home_screen.dart';
import 'package:kataplay_2/features/learning_path/presentation/screens/learning_path_screen.dart';
import 'package:kataplay_2/features/lesson/presentation/lesson_screen.dart';
import 'package:kataplay_2/features/lesson/presentation/result_screen.dart';
import 'package:kataplay_2/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:kataplay_2/features/auth/presentation/screens/login_screen.dart';
import 'package:kataplay_2/features/curriculum/application/curriculum_provider.dart';
import 'package:kataplay_2/features/curriculum/data/curriculum_repository.dart';
import 'package:kataplay_2/features/curriculum/domain/curriculum_catalog.dart';
import 'package:kataplay_2/features/curriculum/domain/curriculum_stage.dart';
import 'package:kataplay_2/features/curriculum/domain/curriculum_unit.dart';
import 'package:kataplay_2/features/curriculum/domain/curriculum_lesson.dart';
// ignore_for_file: unused_import
// ignore_for_file: prefer_const_constructors

GoRouter createTestRouter({String initialLocation = '/splash'}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/learning-path', builder: (_, __) => const LearningPathScreen()),
      GoRoute(
        path: '/lesson',
        builder: (_, state) => LessonScreen(
          key: ValueKey(state.extra?.toString()),
        ),
      ),
      GoRoute(
        path: '/result',
        builder: (_, state) => ResultScreen(
          score: (state.extra as Map<String, dynamic>?)?['score'] as int? ?? 0,
          total: (state.extra as Map<String, dynamic>?)?['total'] as int? ?? 0,
          xpEarned: (state.extra as Map<String, dynamic>?)?['xpEarned'] as int? ?? 0,
          character: (state.extra as Map<String, dynamic>?)?['character'] as String? ?? 'alby',
        ),
      ),
    ],
  );
}

/// A stable curriculum catalog for use in widget tests, so tests don't depend
/// on async asset loading.
final CurriculumCatalog testCurriculumCatalog = CurriculumCatalog(stages: [
  CurriculumStage(
    id: 'stage_01',
    title: 'Pra-Baca / TK',
    subtitle: 'Taman Kanak-Kanak',
    gradeBand: 'TK',
    order: 1,
    themeColor: 0xFF58CC02,
    icon: '🍎',
    units: [
      CurriculumUnit(
        id: 'stage_01_unit_01',
        stageId: 'stage_01',
        title: 'Mengenal Huruf',
        subtitle: 'Kenali huruf A sampai Z',
        order: 1,
        lessons: [
          const CurriculumLesson(
            id: 'stage_01_unit_01_lesson_01',
            unitId: 'stage_01_unit_01',
            title: 'Mengenal A',
            subtitle: 'Kenali huruf A',
            order: 1,
            xpReward: 50,
            lessonType: 'wordChoice',
            questionCount: 5,
          ),
        ],
      ),
    ],
  ),
  CurriculumStage(
    id: 'stage_02',
    title: 'Kelas 1',
    subtitle: 'Kelas Satu SD',
    gradeBand: 'Kelas 1',
    order: 2,
    themeColor: 0xFF1CB0F6,
    icon: '📖',
    units: [
      CurriculumUnit(
        id: 'stage_02_unit_01',
        stageId: 'stage_02',
        title: 'Huruf & Suku Kata',
        subtitle: 'Gabung huruf jadi suku kata',
        order: 1,
        lessons: [
          const CurriculumLesson(
            id: 'stage_02_unit_01_lesson_01',
            unitId: 'stage_02_unit_01',
            title: 'Gabung Huruf',
            subtitle: 'Gabungkan huruf menjadi suku kata',
            order: 1,
            xpReward: 60,
            lessonType: 'soundRecognition',
            questionCount: 5,
          ),
        ],
      ),
    ],
  ),
  CurriculumStage(
    id: 'stage_03',
    title: 'Kelas 2',
    subtitle: 'Kelas Dua SD',
    gradeBand: 'Kelas 2',
    order: 3,
    themeColor: 0xFFFF6B6B,
    icon: '✏️',
    units: [
      CurriculumUnit(
        id: 'stage_03_unit_01',
        stageId: 'stage_03',
        title: 'Kata Kerja',
        subtitle: 'Kata kerja sehari-hari',
        order: 1,
        lessons: [
          const CurriculumLesson(
            id: 'stage_03_unit_01_lesson_01',
            unitId: 'stage_03_unit_01',
            title: 'Kata Tindakan',
            subtitle: 'Belajar kata kerja sehari-hari',
            order: 1,
            xpReward: 70,
            lessonType: 'imageMatch',
            questionCount: 5,
          ),
        ],
      ),
    ],
  ),
  CurriculumStage(
    id: 'stage_04',
    title: 'Kelas 3',
    subtitle: 'Kelas Tiga SD',
    gradeBand: 'Kelas 3',
    order: 4,
    themeColor: 0xFFCE82FF,
    icon: '📝',
    units: [
      CurriculumUnit(
        id: 'stage_04_unit_01',
        stageId: 'stage_04',
        title: 'Paragraf Pendek',
        subtitle: 'Baca paragraf pendek',
        order: 1,
        lessons: [
          const CurriculumLesson(
            id: 'stage_04_unit_01_lesson_01',
            unitId: 'stage_04_unit_01',
            title: 'Membaca Paragraf',
            subtitle: 'Membaca paragraf pendek dengan lancar',
            order: 1,
            xpReward: 80,
            lessonType: 'wordChoice',
            questionCount: 5,
          ),
        ],
      ),
    ],
  ),
  CurriculumStage(
    id: 'stage_05',
    title: 'Kelas 4',
    subtitle: 'Kelas Empat SD',
    gradeBand: 'Kelas 4',
    order: 5,
    themeColor: 0xFFFF9600,
    icon: '📚',
    units: [
      CurriculumUnit(
        id: 'stage_05_unit_01',
        stageId: 'stage_05',
        title: 'Teks Informasi',
        subtitle: 'Baca teks informasi',
        order: 1,
        lessons: [
          const CurriculumLesson(
            id: 'stage_05_unit_01_lesson_01',
            unitId: 'stage_05_unit_01',
            title: 'Baca Informasi',
            subtitle: 'Membaca teks informasi pendek',
            order: 1,
            xpReward: 90,
            lessonType: 'syllableMatch',
            questionCount: 5,
          ),
        ],
      ),
    ],
  ),
  CurriculumStage(
    id: 'stage_06',
    title: 'Kelas 5',
    subtitle: 'Kelas Lima SD',
    gradeBand: 'Kelas 5',
    order: 6,
    themeColor: 0xFF24C96B,
    icon: '🎯',
    units: [
      CurriculumUnit(
        id: 'stage_06_unit_01',
        stageId: 'stage_06',
        title: 'Gagasan Utama',
        subtitle: 'Temukan ide utama',
        order: 1,
        lessons: [
          const CurriculumLesson(
            id: 'stage_06_unit_01_lesson_01',
            unitId: 'stage_06_unit_01',
            title: 'Topik Bacaan',
            subtitle: 'Menentukan topik dari bacaan',
            order: 1,
            xpReward: 100,
            lessonType: 'sentenceBuild',
            questionCount: 5,
          ),
        ],
      ),
    ],
  ),
  CurriculumStage(
    id: 'stage_07',
    title: 'Kelas 6',
    subtitle: 'Kelas Enam SD',
    gradeBand: 'Kelas 6',
    order: 7,
    themeColor: 0xFFFF9600,
    icon: '🏆',
    units: [
      CurriculumUnit(
        id: 'stage_07_unit_01',
        stageId: 'stage_07',
        title: 'Bacaan Panjang',
        subtitle: 'Baca teks panjang',
        order: 1,
        lessons: [
          const CurriculumLesson(
            id: 'stage_07_unit_01_lesson_01',
            unitId: 'stage_07_unit_01',
            title: 'Bacaan Utama',
            subtitle: 'Membaca teks bacaan utama',
            order: 1,
            xpReward: 110,
            lessonType: 'reading',
            questionCount: 5,
          ),
        ],
      ),
    ],
  ),
]);

class _TestCurriculumRepository extends CurriculumRepository {
  @override
  Future<CurriculumCatalog> loadCurriculum() async {
    return testCurriculumCatalog;
  }
}

/// Must be called once before any test that uses providers requiring Hive.
/// Safe to call multiple times — only initializes once.
Future<void> initTestHive() async {
  if (Hive.isBoxOpen('kataplay_data')) return;
  if (!_hiveInited) {
    _hiveInited = true;
    final dir = await Directory.systemTemp.createTemp('kataplay_hive_test_');
    Hive.init(dir.path);
  }
  await Hive.openBox('kataplay_data');
}

bool _hiveInited = false;

Widget createTestApp({
  String initialRoute = '/splash',
  List<Override> overrides = const [],
}) {
  final allOverrides = <Override>[
    curriculumRepositoryProvider.overrideWithValue(
      _TestCurriculumRepository(),
    ),
    ...overrides,
  ];
  return ProviderScope(
    overrides: allOverrides,
    child: MaterialApp.router(
      title: 'KataPlay',
      debugShowCheckedModeBanner: false,
      routerConfig: createTestRouter(initialLocation: initialRoute),
    ),
  );
}

Future<void> pumpKataPlayApp(
  WidgetTester tester, {
  String initialRoute = '/splash',
}) async {
  await tester.pumpWidget(createTestApp(initialRoute: initialRoute));
  await tester.pump();
  await tester.pump();
}

/// Pump at a specific screen size to test layout regressions.
/// Registers a teardown callback to reset the screen size after the test.
Future<void> pumpKataPlayAppAtSize(
  WidgetTester tester, {
  required Size size,
  String initialRoute = '/splash',
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    if (tester.view.physicalSize != const Size(800, 600)) {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
    }
  });
  await pumpKataPlayApp(tester, initialRoute: initialRoute);
}
