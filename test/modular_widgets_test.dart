import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walid_portfolio/skill_hover_card.dart';
import 'package:walid_portfolio/experience_card.dart';
import 'package:walid_portfolio/project_dialog.dart';

void main() {
  testWidgets('SkillHoverCard renders title, desc, badge and tags', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SkillHoverCard(
            title: 'Test Skill',
            desc: 'This is a test description of skill.',
            tags: ['Tag1', 'Tag2'],
            icon: Icons.star,
            badge: '95%',
            gradientColors: [Colors.teal, Colors.cyan],
          ),
        ),
      ),
    );

    expect(find.text('Test Skill'), findsOneWidget);
    expect(find.text('This is a test description of skill.'), findsOneWidget);
    expect(find.text('95%'), findsOneWidget);
    expect(find.text('Tag1'), findsOneWidget);
    expect(find.text('Tag2'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('ExperienceCard renders role, company and bullet points', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExperienceCard(
            role: 'Senior Consultant',
            company: 'Tech Corp',
            bulletList: ['Led ERP implementation', 'Automated workflows'],
            tags: ['ERP', 'Flutter'],
            icon: Icons.business,
          ),
        ),
      ),
    );

    expect(find.text('Senior Consultant'), findsOneWidget);
    expect(find.text('Tech Corp'), findsOneWidget);
    expect(find.text('Led ERP implementation'), findsOneWidget);
    expect(find.text('Automated workflows'), findsOneWidget);
    expect(find.text('ERP'), findsOneWidget);
    expect(find.text('Flutter'), findsOneWidget);
    expect(find.byIcon(Icons.business), findsOneWidget);
  });

  testWidgets('ProjectCard renders and opens details modal on tap', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProjectCard(
            title: 'Lumina Shop',
            desc: 'E-commerce platform with WooCommerce.',
            tech: 'Flutter, PHP, REST API',
            btnText: 'View Details',
            closeBtnText: 'Close',
            screenWidth: 1000,
          ),
        ),
      ),
    );

    expect(find.text('Lumina Shop'), findsOneWidget);
    expect(find.text('E-commerce platform with WooCommerce.'), findsOneWidget);
    expect(find.text('View Details'), findsOneWidget);

    // Tap to open modal
    await tester.tap(find.text('Lumina Shop'));
    await tester.pumpAndSettle();

    // Verify modal dialog appears
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Technologies & Stack:'), findsOneWidget);
    expect(find.text('Flutter, PHP, REST API'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);

    // Close modal
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
  });
}
