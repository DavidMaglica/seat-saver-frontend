import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:table_reserver/pages/mobile/views/homepage.dart';
import 'package:table_reserver/pages/mobile/views/landing.dart';
import 'package:table_reserver/utils/routes.dart';

import '../../../test_utils/shared_preferences_mock.dart';

void main() {
  setUp(() {
    setupSharedPrefsMock(initialValues: {});
  });

  group('Landing Widget', () {
    testWidgets('should display widget correctly', (tester) async {
      final logo = find.byKey(const Key('logoImage'));
      final title = find.byKey(const Key('welcomeText'));
      final button = find.byKey(const Key('getStartedButton'));
      final titleFinder = find.text('Welcome to TableReserver');
      final buttonFinder = find.text('Get Started');

      await tester.pumpWidget(MaterialApp(home: const Landing()));

      expect(logo, findsOneWidget);
      expect(title, findsOneWidget);
      expect(button, findsOneWidget);
      expect(titleFinder, findsOneWidget);
      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('should navigate to Homepage', (tester) async {
      final button = find.byKey(const Key('getStartedButton'));

      await tester.pumpWidget(
        MaterialApp(
          home: const Landing(),
          routes: {Routes.homepage: (context) => const Homepage()},
        ),
      );

      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.byType(Homepage), findsOneWidget);
    });
  });
}
