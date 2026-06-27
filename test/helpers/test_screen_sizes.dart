import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const smallPhone = Size(360, 780);
const iPhoneStandard = Size(393, 852);
const largePhone = Size(430, 932);

/// Sets the test surface to [size] with devicePixelRatio 1.0.
void setTestScreenSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
}

/// Resets to the Flutter test default (800×600).
void resetTestScreenSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 600);
  tester.view.devicePixelRatio = 1.0;
}

/// Pumps a widget at a specific screen size.
Future<void> pumpWithScreenSize(
  WidgetTester tester,
  Widget widget, {
  Size size = iPhoneStandard,
  Duration? pumpDuration,
}) async {
  setTestScreenSize(tester, size);
  await tester.pumpWidget(widget);
  if (pumpDuration != null) {
    await tester.pump(pumpDuration);
  }
  await tester.pump();
}
