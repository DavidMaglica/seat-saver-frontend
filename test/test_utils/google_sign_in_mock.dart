import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:mocktail/mocktail.dart';

class FakeAuthenticateParameters extends Fake
    implements AuthenticateParameters {}

class FakeSignOutParams extends Fake implements SignOutParams {}

class FakeAttemptLightweightAuthenticationParameters extends Fake
    implements AttemptLightweightAuthenticationParameters {}

class MockGoogleSignInPlatform extends GoogleSignInPlatform with Mock {}

late MockGoogleSignInPlatform mockPlatform;

void setupGoogleSignInMock({
  AuthenticationResults? authResult,
  GoogleSignInAccount? currentUser,
}) {
  registerFallbackValue(FakeAuthenticateParameters());
  registerFallbackValue(FakeSignOutParams());
  registerFallbackValue(FakeAttemptLightweightAuthenticationParameters());

  mockPlatform = MockGoogleSignInPlatform();

  final fakeAuthResult = AuthenticationResults(
    user: GoogleSignInUserData(
      id: '123',
      email: 'test@example.com',
      displayName: 'Test User',
      photoUrl: null,
    ),
    authenticationTokens: AuthenticationTokenData(idToken: 'fake-id-token'),
  );

  GoogleSignInPlatform.instance = mockPlatform;

  when(
    () => mockPlatform.authenticate(any()),
  ).thenAnswer((_) async => fakeAuthResult);

  when(() => mockPlatform.signOut(any())).thenAnswer((_) async {});

  when(
    () => mockPlatform.attemptLightweightAuthentication(any()),
  ).thenAnswer((_) async => fakeAuthResult);
}
