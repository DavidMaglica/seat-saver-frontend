import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:table_reserver/pages/mobile/settings/terms_of_service.dart';

void main() {
  testWidgets('should display widget correctly', (tester) async {
    final titleText = find.byKey(const Key('titleText'));
    final acceptanceTitle = find.byKey(const Key('acceptanceTitle'));
    final acceptanceBody = find.byKey(const Key('acceptanceBody'));
    final useOfAppTitle = find.byKey(const Key('useOfAppTitle'));
    final useOfAppBody = find.byKey(const Key('useOfAppBody'));
    final intellectualPropertyTitle = find.byKey(
      const Key('intellectualPropertyTitle'),
    );
    final intellectualPropertyBody = find.byKey(
      const Key('intellectualPropertyBody'),
    );
    final userContentTitle = find.byKey(const Key('userContentTitle'));
    final userContentBody = find.byKey(const Key('userContentBody'));
    final limitationOfLiabilityTitle = find.byKey(
      const Key('limitationOfLiabilityTitle'),
    );
    final limitationOfLiabilityBody = find.byKey(
      const Key('limitationOfLiabilityBody'),
    );
    final governingLawTitle = find.byKey(const Key('governingLawTitle'));
    final governingLawBody = find.byKey(const Key('governingLawBody'));
    final changesToTermsTitle = find.byKey(const Key('changesToTermsTitle'));
    final changesToTermsBody = find.byKey(const Key('changesToTermsBody'));

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: TermsOfService(userId: null))),
    );

    expect(titleText, findsOneWidget);
    expect(acceptanceTitle, findsOneWidget);
    expect(acceptanceBody, findsOneWidget);
    expect(useOfAppTitle, findsOneWidget);
    expect(useOfAppBody, findsOneWidget);
    expect(intellectualPropertyTitle, findsOneWidget);
    expect(intellectualPropertyBody, findsOneWidget);
    expect(userContentTitle, findsOneWidget);
    expect(userContentBody, findsOneWidget);
    expect(limitationOfLiabilityTitle, findsOneWidget);
    expect(limitationOfLiabilityBody, findsOneWidget);
    expect(governingLawTitle, findsOneWidget);
    expect(governingLawBody, findsOneWidget);
    expect(changesToTermsTitle, findsOneWidget);
    expect(changesToTermsBody, findsOneWidget);
  });
}
