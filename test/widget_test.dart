import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers/pump_kataplay_app.dart';
import 'helpers/test_screen_sizes.dart';
import 'helpers/fake_lesson_data.dart';
import 'helpers/mock_assets.dart';
import 'package:kataplay_2/app/theme/app_theme.dart';

void main() {
  setUpAll(() async {
    await initTestHive();
  });
  testWidgets('Splash screen renders and navigates to login',
      (WidgetTester tester) async {
    await pumpKataPlayApp(tester);

    expect(find.byType(Image), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
    await tester.pump();

    expect(find.text('Masuk ke KataPlay'), findsOneWidget);
    expect(find.text('Lanjut sebagai Tamu'), findsOneWidget);
  });

  testWidgets('Learning Path shows level titles',
      (WidgetTester tester) async {
    await pumpKataPlayApp(tester, initialRoute: '/learning-path');
    await tester.pump();
    await tester.pump();

    expect(find.text('Petualanganmu'), findsOneWidget);
    expect(find.text('Pra-Baca / TK'), findsOneWidget);
    expect(find.text('Kelas 1'), findsOneWidget);
    expect(find.text('Kelas 2'), findsOneWidget);
    expect(find.text('Kelas 3'), findsOneWidget);
    expect(find.text('Kelas 4'), findsOneWidget);
    expect(find.text('Kelas 5'), findsOneWidget);
    expect(find.text('Kelas 6'), findsOneWidget);
  });

  testWidgets('Lesson screen renders question', (WidgetTester tester) async {
    await pumpKataPlayApp(tester, initialRoute: '/lesson');

    expect(find.text('Huruf apa ini?'), findsOneWidget);
  });

  testWidgets('Correct answer shows success action',
      (WidgetTester tester) async {
    await pumpKataPlayApp(tester, initialRoute: '/lesson');

    await tester.ensureVisible(find.text('A').last);
    await tester.pump();
    await tester.tap(find.text('A').last);
    await tester.pump();
    await tester.pump();

    await tester.ensureVisible(find.text('Periksa'));
    await tester.pump();
    await tester.tap(find.text('Periksa'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
    await tester.pump();

    expect(find.text('Lanjut'), findsOneWidget);
  });

  testWidgets('Wrong answer shows retry option',
      (WidgetTester tester) async {
    await pumpKataPlayApp(tester, initialRoute: '/lesson');

    await tester.ensureVisible(find.text('I').last);
    await tester.pump();
    await tester.tap(find.text('I').last);
    await tester.pump();

    await tester.ensureVisible(find.text('Periksa'));
    await tester.pump();
    await tester.tap(find.text('Periksa'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Coba Lagi'), findsOneWidget);
  });

  testWidgets('Close button exists on lesson', (WidgetTester tester) async {
    await pumpKataPlayApp(tester, initialRoute: '/lesson');

    expect(find.text('Huruf apa ini?'), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
  });

  testWidgets('Home screen renders', (WidgetTester tester) async {
    await pumpKataPlayApp(tester, initialRoute: '/home');

    expect(find.text('Halo, KataPlayer!'), findsOneWidget);
    expect(find.textContaining('Siap bermain'), findsOneWidget);
  });

  testWidgets('Learning Path works on small screen',
      (WidgetTester tester) async {
    await pumpKataPlayAppAtSize(
      tester,
      size: const Size(360, 780),
      initialRoute: '/learning-path',
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Petualanganmu'), findsOneWidget);
    expect(find.text('Pra-Baca / TK'), findsOneWidget);
  });

  testWidgets('Lesson screen works on small screen',
      (WidgetTester tester) async {
    await pumpKataPlayAppAtSize(
      tester,
      size: const Size(360, 780),
      initialRoute: '/lesson',
    );

    expect(find.text('Huruf apa ini?'), findsOneWidget);
    expect(find.text('Periksa'), findsOneWidget);
  });

  testWidgets('Lesson screen works on tablet size',
      (WidgetTester tester) async {
    await pumpKataPlayAppAtSize(
      tester,
      size: const Size(430, 932),
      initialRoute: '/lesson',
    );

    expect(find.text('Huruf apa ini?'), findsOneWidget);
    expect(find.text('Periksa'), findsOneWidget);
  });

  testWidgets('Bottom nav exists on Learning Path',
      (WidgetTester tester) async {
    await pumpKataPlayApp(tester, initialRoute: '/learning-path');

    expect(find.text('Belajar'), findsOneWidget);
    expect(find.text('Beranda'), findsAtLeast(1));
  });

  testWidgets('Lesson engine screen loads and shows first question',
      (WidgetTester tester) async {
    await pumpKataPlayApp(tester, initialRoute: '/lesson');

    expect(find.text('Huruf apa ini?'), findsOneWidget);
    expect(find.text('Periksa'), findsOneWidget);
  });

  testWidgets('Lesson screen is not stuck loading',
      (WidgetTester tester) async {
    await pumpKataPlayApp(tester, initialRoute: '/lesson');

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.text('Memuat pelajaran...'), findsNothing);
    expect(find.text('Huruf apa ini?'), findsOneWidget);
  });

  test('Theme uses Nunito font and no underline', () {
    final theme = AppTheme.lightTheme;
    expect(theme.textTheme.bodyLarge?.fontFamily, 'Nunito');
    expect(theme.textTheme.displayLarge?.decoration, TextDecoration.none);
    expect(theme.textTheme.bodyMedium?.decoration, TextDecoration.none);
    expect(theme.textTheme.labelLarge?.decoration, TextDecoration.none);
  });

  group('Overflow regression tests', () {
    testWidgets('Home screen at smallPhone 360x780',
        (WidgetTester tester) async {
      await pumpKataPlayAppAtSize(
        tester,
        size: smallPhone,
        initialRoute: '/home',
      );
      expect(find.text('Halo, KataPlayer!'), findsOneWidget);
      expect(find.text('Beranda'), findsOneWidget);
    });

    testWidgets('Home screen at iPhoneStandard 393x852',
        (WidgetTester tester) async {
      await pumpKataPlayAppAtSize(
        tester,
        size: iPhoneStandard,
        initialRoute: '/home',
      );
      expect(find.text('Halo, KataPlayer!'), findsOneWidget);
      expect(find.textContaining('Siap bermain'), findsOneWidget);
    });

    testWidgets('Home screen at largePhone 430x932',
        (WidgetTester tester) async {
      await pumpKataPlayAppAtSize(
        tester,
        size: largePhone,
        initialRoute: '/home',
      );
      expect(find.text('Halo, KataPlayer!'), findsOneWidget);
      expect(find.textContaining('Siap bermain'), findsOneWidget);
    });

    testWidgets('Lesson screen at iPhoneStandard 393x852',
        (WidgetTester tester) async {
      await pumpKataPlayAppAtSize(
        tester,
        size: iPhoneStandard,
        initialRoute: '/lesson',
      );
      expect(find.text('Huruf apa ini?'), findsOneWidget);
      expect(find.text('Periksa'), findsOneWidget);
    });

    testWidgets('Learning Path at iPhoneStandard 393x852',
        (WidgetTester tester) async {
      await pumpKataPlayAppAtSize(
        tester,
        size: iPhoneStandard,
        initialRoute: '/learning-path',
      );
      await tester.pump();
      await tester.pump();
      expect(find.text('Petualanganmu'), findsOneWidget);
      expect(find.text('Pra-Baca / TK'), findsOneWidget);
    });

    testWidgets('Home screen at smallPhone 360x780 bottom nav',
        (WidgetTester tester) async {
      await pumpKataPlayAppAtSize(
        tester,
        size: smallPhone,
        initialRoute: '/home',
      );
      expect(find.text('Beranda'), findsOneWidget);
    });
  });
}
