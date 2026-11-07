import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walid_portfolio/main.dart';

void main() {
  testWidgets('PortfolioApp renders correctly and verifies essential UI components', (WidgetTester tester) async {
    // Set a wide screen size for desktop simulation
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const PortfolioApp());
    await tester.pump();

    // Verify Walid Hassani name is displayed
    expect(find.text('WALID HASSANI'), findsOneWidget);

    // Verify language switcher buttons exist
    expect(find.text('FR'), findsOneWidget);
    expect(find.text('EN'), findsOneWidget);
    expect(find.text('AR'), findsOneWidget);

    // Verify CV download button exists
    expect(find.byIcon(Icons.download), findsOneWidget);

    // Tap on AR button to test language switch
    await tester.tap(find.text('AR'));
    await tester.pump();

    // Verify Arabic text appears
    expect(find.text('وليد الحساني'), findsOneWidget);
  });
}
