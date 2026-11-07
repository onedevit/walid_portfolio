import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walid_portfolio/main.dart';

void main() {
  testWidgets('PortfolioApp renders correctly and verifies essential UI components with intro', (WidgetTester tester) async {
    // Set a wide screen size for desktop simulation
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const PortfolioApp());
    await tester.pump();

    // Verify Intro overlay is visible with Passer button and Enter button
    expect(find.text('Passer'), findsOneWidget);
    expect(find.text('Entrer sur le site'), findsOneWidget);

    // Tap Passer to dismiss intro immediately
    await tester.tap(find.text('Passer'));
    await tester.pumpAndSettle();

    // Verify Walid Hassani name is displayed in Hero section
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

    // Verify Arabic Elite Skills section and cards
    expect(find.text('مجالات الخبرة والكفاءات النخبوية'), findsOneWidget);
    expect(find.text('الذكاء الاصطناعي المؤسساتي والنماذج المحلية'), findsOneWidget);
    expect(find.text('الرؤية الحاسوبية واستخراج الوثائق الذكي'), findsOneWidget);

    // Tap on FR button to switch back to French
    await tester.tap(find.text('FR'));
    await tester.pump();

    // Verify French Elite Skills
    expect(find.text('PÔLES D’EXPERTISE & COMPÉTENCES ÉLITES'), findsOneWidget);
    expect(find.text('IA d\'Entreprise & LLMs Locaux'), findsOneWidget);
    expect(find.text('Document AI & OCR Intelligent'), findsOneWidget);
  });
}
