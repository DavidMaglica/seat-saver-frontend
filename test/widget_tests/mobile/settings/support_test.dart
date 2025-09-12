import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seat_saver/api/account_api.dart';
import 'package:seat_saver/api/data/basic_response.dart';
import 'package:seat_saver/api/data/user.dart';
import 'package:seat_saver/api/support_api.dart';
import 'package:seat_saver/models/mobile/views/support_model.dart';
import 'package:seat_saver/pages/mobile/settings/support.dart';

import '../../../test_utils/shared_preferences_mock.dart';

void main() {
  late SupportModel model;

  const mockUserId = 1;
  const mockTicketTitle = 'Test Issue';
  const mockTicketDescription = 'This is a test issue.';

  setUp(() {
    setupSharedPrefsMock(initialValues: {'userId': mockUserId});

    model = SupportModel(
      userId: mockUserId,
      accountApi: FakeAccountApi(),
      supportApi: FakeSupportApi(),
    );
  });

  testWidgets('should display widget correctly', (tester) async {
    final customAppbar = find.byKey(const Key('customAppBar'));
    final descriptionText = find.byKey(const Key('descriptionText'));
    final openFAQsButton = find.byKey(const Key('openFAQsButton'));
    final ticketTitleField = find.byKey(const Key('ticketTitleField'));
    final ticketDescriptionField = find.byKey(
      const Key('ticketDescriptionField'),
    );
    final submitTicketButton = find.byKey(const Key('submitTicketButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Support(userId: mockUserId, modelOverride: model),
        ),
      ),
    );

    expect(customAppbar, findsOneWidget);
    expect(descriptionText, findsOneWidget);
    expect(openFAQsButton, findsOneWidget);
    expect(ticketTitleField, findsOneWidget);
    expect(ticketDescriptionField, findsOneWidget);
    expect(submitTicketButton, findsOneWidget);
  });

  testWidgets('should navigate to FAQs', (tester) async {
    final openFAQsButton = find.byKey(const Key('openFAQsButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Support(userId: mockUserId, modelOverride: model),
        ),
      ),
    );

    expect(openFAQsButton, findsOneWidget);

    await tester.tap(openFAQsButton);
    await tester.pumpAndSettle();

    // Since url_launcher opens an external app, we can't verify the navigation
    // directly in a widget test. However, we can ensure that the button is tappable.
    expect(openFAQsButton, findsOneWidget);
  });

  testWidgets('should submit ticket', (tester) async {
    final ticketTitleField = find.byKey(const Key('ticketTitleField'));
    final ticketDescriptionField = find.byKey(
      const Key('ticketDescriptionField'),
    );
    final submitTicketButton = find.byKey(const Key('submitTicketButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Support(userId: mockUserId, modelOverride: model),
        ),
      ),
    );

    expect(ticketTitleField, findsOneWidget);
    expect(ticketDescriptionField, findsOneWidget);
    expect(submitTicketButton, findsOneWidget);

    await tester.enterText(ticketTitleField, mockTicketTitle);
    await tester.enterText(ticketDescriptionField, mockTicketDescription);
    await tester.scrollUntilVisible(
      submitTicketButton,
      100.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(submitTicketButton);
    await tester.pumpAndSettle();

    expect(find.text('Support ticket submitted successfully.'), findsOneWidget);
  });
}

class FakeAccountApi extends Fake implements AccountApi {
  @override
  Future<BasicResponse<User?>> getUser(int userId) async {
    return BasicResponse(
      success: true,
      message: 'User found',
      data: User(id: userId, username: 'mockUser', email: 'test@mail.com'),
    );
  }
}

class FakeSupportApi extends Fake implements SupportApi {
  @override
  Future<BasicResponse> sendEmail(
    String userEmail,
    String subject,
    String message,
  ) async {
    return BasicResponse(success: true, message: 'Email sent');
  }
}
