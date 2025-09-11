import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seat_saver/api/account_api.dart';
import 'package:seat_saver/api/data/basic_response.dart';
import 'package:seat_saver/api/data/user.dart';
import 'package:seat_saver/api/data/user_response.dart';
import 'package:seat_saver/models/mobile/views/edit_profile_model.dart';
import 'package:seat_saver/pages/mobile/settings/edit_profile.dart';

import '../../../test_utils/shared_preferences_mock.dart';

void main() {
  late EditProfileModel model;

  const mockUserId = 1;
  const mockUsername = 'mockUser';
  const updatedMockUsername = 'newMockUser';
  const mockEmail = 'test@mail.com';
  const updatedMockEmail = 'newTest@mail.com';

  setUp(() {
    setupSharedPrefsMock(initialValues: {'userId': 1});
    model = EditProfileModel(userId: mockUserId, accountApi: FakeAccountApi());
  });

  testWidgets('should display widget correctly', (tester) async {
    final customAppBar = find.byKey(const Key('customAppBar'));
    final changeUsernameButton = find.byKey(const Key('changeUsernameButton'));
    final changeEmailButton = find.byKey(const Key('changeEmailButton'));
    final changePasswordButton = find.byKey(const Key('changePasswordButton'));
    final mockEmailText = find.text(mockEmail);
    final mockUsernameText = find.text(mockUsername);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditProfile(userId: mockUserId, modelOverride: model),
        ),
      ),
    );

    final context = tester.element(find.byType(EditProfile));
    await model.init(context);
    await tester.pumpAndSettle();

    expect(customAppBar, findsOneWidget);
    expect(changeUsernameButton, findsOneWidget);
    expect(mockUsernameText, findsOneWidget);
    expect(mockEmailText, findsOneWidget);
    expect(changeEmailButton, findsOneWidget);
    expect(changePasswordButton, findsOneWidget);
  });

  testWidgets('should open change username modal when button clicked', (
    tester,
  ) async {
    final changeUsernameButton = find.byKey(const Key('changeUsernameButton'));
    final changeUsernameModalTitle = find.byKey(
      const Key('changeUsernameModalTitle'),
    );
    final usernameField = find.byKey(const Key('newUsernameField'));
    final cancelModalButton = find.byKey(const Key('cancelModalButton'));
    final saveModalButton = find.byKey(const Key('saveModalButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditProfile(userId: mockUserId, modelOverride: model),
        ),
      ),
    );

    final context = tester.element(find.byType(EditProfile));
    await model.init(context);
    await tester.pumpAndSettle();

    expect(changeUsernameButton, findsOneWidget);

    await tester.tap(changeUsernameButton);
    await tester.pumpAndSettle();

    expect(changeUsernameModalTitle, findsOneWidget);
    expect(usernameField, findsOneWidget);
    expect(cancelModalButton, findsOneWidget);
    expect(saveModalButton, findsOneWidget);
  });

  testWidgets('should close change username modal when cancel button clicked', (
    tester,
  ) async {
    final changeUsernameButton = find.byKey(const Key('changeUsernameButton'));
    final changeUsernameModalTitle = find.byKey(
      const Key('changeUsernameModalTitle'),
    );
    final cancelModalButton = find.byKey(const Key('cancelModalButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditProfile(userId: mockUserId, modelOverride: model),
        ),
      ),
    );

    final context = tester.element(find.byType(EditProfile));
    await model.init(context);
    await tester.pumpAndSettle();

    expect(changeUsernameButton, findsOneWidget);

    await tester.tap(changeUsernameButton);
    await tester.pumpAndSettle();

    expect(changeUsernameModalTitle, findsOneWidget);
    expect(cancelModalButton, findsOneWidget);

    await tester.tap(cancelModalButton);
    await tester.pumpAndSettle();

    expect(changeUsernameModalTitle, findsNothing);
    expect(changeUsernameButton, findsOneWidget);
  });

  testWidgets('should update username when save button clicked', (
    tester,
  ) async {
    final changeUsernameButton = find.byKey(const Key('changeUsernameButton'));
    final changeUsernameModalTitle = find.byKey(
      const Key('changeUsernameModalTitle'),
    );
    final usernameField = find.byKey(const Key('newUsernameField'));
    final cancelModalButton = find.byKey(const Key('cancelModalButton'));
    final saveModalButton = find.byKey(const Key('saveModalButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditProfile(userId: mockUserId, modelOverride: model),
        ),
      ),
    );

    final context = tester.element(find.byType(EditProfile));
    await model.init(context);
    await tester.pumpAndSettle();

    expect(changeUsernameButton, findsOneWidget);

    await tester.tap(changeUsernameButton);
    await tester.pumpAndSettle();

    expect(find.text(mockUsername), findsOneWidget);
    expect(changeUsernameModalTitle, findsOneWidget);
    expect(usernameField, findsOneWidget);
    expect(cancelModalButton, findsOneWidget);
    expect(saveModalButton, findsOneWidget);

    await tester.enterText(usernameField, updatedMockUsername);
    await tester.pumpAndSettle();

    await tester.tap(saveModalButton);
    await tester.pumpAndSettle();

    expect(changeUsernameModalTitle, findsNothing);
    expect(changeUsernameButton, findsOneWidget);
    expect(find.text(updatedMockUsername), findsOneWidget);
  });

  testWidgets('should open change email modal when button clicked', (
    tester,
  ) async {
    final changeEmailButton = find.byKey(const Key('changeEmailButton'));
    final changeEmailModalTitle = find.byKey(
      const Key('changeEmailModalTitle'),
    );
    final emailField = find.byKey(const Key('newEmailField'));
    final cancelModalButton = find.byKey(const Key('cancelModalButton'));
    final saveModalButton = find.byKey(const Key('saveModalButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditProfile(userId: mockUserId, modelOverride: model),
        ),
      ),
    );

    final context = tester.element(find.byType(EditProfile));
    await model.init(context);
    await tester.pumpAndSettle();

    expect(changeEmailButton, findsOneWidget);

    await tester.tap(changeEmailButton);
    await tester.pumpAndSettle();

    expect(changeEmailModalTitle, findsOneWidget);
    expect(emailField, findsOneWidget);
    expect(cancelModalButton, findsOneWidget);
    expect(saveModalButton, findsOneWidget);
  });

  testWidgets('should close change email modal when cancel button clicked', (
    tester,
  ) async {
    final changeEmailButton = find.byKey(const Key('changeEmailButton'));
    final cancelModalButton = find.byKey(const Key('cancelModalButton'));
    final changeEmailModalTitle = find.byKey(
      const Key('changeEmailModalTitle'),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditProfile(userId: mockUserId, modelOverride: model),
        ),
      ),
    );

    final context = tester.element(find.byType(EditProfile));
    await model.init(context);
    await tester.pumpAndSettle();

    expect(changeEmailButton, findsOneWidget);

    await tester.tap(changeEmailButton);
    await tester.pumpAndSettle();

    expect(changeEmailModalTitle, findsOneWidget);
    expect(cancelModalButton, findsOneWidget);

    await tester.tap(cancelModalButton);
    await tester.pumpAndSettle();

    expect(changeEmailModalTitle, findsNothing);
    expect(changeEmailButton, findsOneWidget);
  });

  testWidgets('should update email when save button clicked', (tester) async {
    final changeEmailButton = find.byKey(const Key('changeEmailButton'));
    final changeEmailModalTitle = find.byKey(
      const Key('changeEmailModalTitle'),
    );
    final newEmailField = find.byKey(const Key('newEmailField'));
    final cancelModalButton = find.byKey(const Key('cancelModalButton'));
    final saveModalButton = find.byKey(const Key('saveModalButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditProfile(userId: mockUserId, modelOverride: model),
        ),
      ),
    );

    final context = tester.element(find.byType(EditProfile));
    await model.init(context);
    await tester.pumpAndSettle();

    expect(changeEmailButton, findsOneWidget);

    await tester.tap(changeEmailButton);
    await tester.pumpAndSettle();

    expect(find.text(mockUsername), findsOneWidget);
    expect(changeEmailModalTitle, findsOneWidget);
    expect(newEmailField, findsOneWidget);
    expect(cancelModalButton, findsOneWidget);
    expect(saveModalButton, findsOneWidget);

    await tester.enterText(newEmailField, updatedMockEmail);
    await tester.pumpAndSettle();

    await tester.tap(saveModalButton);
    await tester.pumpAndSettle();

    expect(changeEmailModalTitle, findsNothing);
    expect(changeEmailButton, findsOneWidget);
    expect(find.text(updatedMockEmail), findsOneWidget);
  });

  testWidgets('should open change password modal when button clicked', (
    tester,
  ) async {
    final changePasswordButton = find.byKey(const Key('changePasswordButton'));
    final changePasswordModalTitle = find.byKey(
      const Key('changePasswordModalTitle'),
    );
    final newPasswordField = find.byKey(const Key('newPasswordField'));
    final confirmNewPasswordField = find.byKey(
      const Key('confirmNewPasswordField'),
    );
    final cancelModalButton = find.byKey(const Key('cancelModalButton'));
    final saveModalButton = find.byKey(const Key('saveModalButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditProfile(userId: mockUserId, modelOverride: model),
        ),
      ),
    );

    final context = tester.element(find.byType(EditProfile));
    await model.init(context);
    await tester.pumpAndSettle();

    expect(changePasswordButton, findsOneWidget);

    await tester.tap(changePasswordButton);
    await tester.pumpAndSettle();

    expect(changePasswordModalTitle, findsOneWidget);
    expect(newPasswordField, findsOneWidget);
    expect(confirmNewPasswordField, findsOneWidget);
    expect(cancelModalButton, findsOneWidget);
    expect(saveModalButton, findsOneWidget);
  });

  testWidgets('should close change password modal when cancel button clicked', (
    tester,
  ) async {
    final changePasswordButton = find.byKey(const Key('changePasswordButton'));
    final cancelModalButton = find.byKey(const Key('cancelModalButton'));
    final changePasswordModalTitle = find.byKey(
      const Key('changePasswordModalTitle'),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditProfile(userId: mockUserId, modelOverride: model),
        ),
      ),
    );

    final context = tester.element(find.byType(EditProfile));
    await model.init(context);
    await tester.pumpAndSettle();

    expect(changePasswordButton, findsOneWidget);

    await tester.tap(changePasswordButton);
    await tester.pumpAndSettle();

    expect(changePasswordModalTitle, findsOneWidget);
    expect(cancelModalButton, findsOneWidget);

    await tester.tap(cancelModalButton);
    await tester.pumpAndSettle();

    expect(changePasswordModalTitle, findsNothing);
    expect(changePasswordButton, findsOneWidget);
  });
}

class FakeAccountApi extends Fake implements AccountApi {
  @override
  Future<UserResponse?> getUser(int userId) async {
    return UserResponse(
      success: true,
      message: 'User found',
      user: User(id: userId, username: 'mockUser', email: 'test@mail.com'),
    );
  }

  @override
  Future<BasicResponse> changeUsername(int userId, String newUsername) async {
    return BasicResponse(
      success: true,
      message: 'Username updated successfully',
    );
  }

  @override
  Future<BasicResponse> changeEmail(int userId, String newEmail) async {
    return BasicResponse(success: true, message: 'Email updated successfully');
  }
}
