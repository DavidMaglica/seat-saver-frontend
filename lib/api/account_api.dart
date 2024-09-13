import 'package:geolocator/geolocator.dart';

import 'data/basic_response.dart';
import 'data/notification_settings.dart';
import 'data/user.dart';

Map<String, User> userStore = {};

User? findUser(String email) => userStore[email];

Future<UserResponse?> getUser(String email) async {
  if (!userStore.containsKey(email)) {
    return null;
  }

  User user = userStore[email]!;
  return UserResponse(
    success: true,
    message: 'User retrieved successfully',
    user: user,
  );
}

Future<BasicResponse> signup(
    String username, String email, String password) async {
  if (username.isEmpty || email.isEmpty || password.isEmpty) {
    return BasicResponse(success: false, message: 'Please fill in all fields');
  }

  if (userStore.containsKey(email)) {
    return BasicResponse(success: false, message: 'User already exists');
  }

  User newUser = User(
    username: username,
    email: email,
    password: password,
    notificationOptions: NotificationSettings(
      pushNotificationsTurnedOn: false,
      emailNotificationsTurnedOn: false,
      locationServicesTurnedOn: false,
    ),
    lastKnownLocation: null,
  );

  userStore[email] = newUser;
  return BasicResponse(success: true, message: 'Signup successful');
}

Future<BasicResponse> login(String email, String password) async {
  if (email.isEmpty || password.isEmpty) {
    return BasicResponse(success: false, message: 'Please fill in all fields');
  }

  if (!userStore.containsKey(email)) {
    return BasicResponse(success: false, message: 'User not found');
  }

  User user = userStore[email]!;
  if (user.password == password) {
    return BasicResponse(success: true, message: 'Login successful');
  } else {
    return BasicResponse(success: false, message: 'Invalid password');
  }
}

Future<NotificationSettingsResponse> getNotificationSettings(
    String email) async {
  if (!userStore.containsKey(email)) {
    return NotificationSettingsResponse(
      success: false,
      message: 'User not found',
      notificationSettings: null,
    );
  }

  User user = userStore[email]!;
  return NotificationSettingsResponse(
    success: true,
    message: 'Notification settings retrieved successfully',
    notificationSettings: user.notificationOptions,
  );
}

Future<UserResponse> getLastKnownLocation(String email) async {
  if (!userStore.containsKey(email)) {
    return UserResponse(success: false, message: 'User not found', user: null);
  }

  User user = userStore[email]!;
  return UserResponse(
    success: true,
    message: 'Last known location retrieved successfully',
    user: user,
  );
}

Future<BasicResponse> updateUserNotificationOptions(
  String email,
  bool pushNotificationsTurnedOn,
  bool emailNotificationsTurnedOn,
  bool locationServicesTurnedOn,
) async {
  if (!userStore.containsKey(email)) {
    return BasicResponse(success: false, message: 'User not found');
  }

  User existingUser = userStore[email]!;

  User updatedUser = User(
    username: existingUser.username,
    email: existingUser.email,
    password: existingUser.password,
    notificationOptions: NotificationSettings(
      pushNotificationsTurnedOn: pushNotificationsTurnedOn,
      emailNotificationsTurnedOn: emailNotificationsTurnedOn,
      locationServicesTurnedOn: locationServicesTurnedOn,
    ),
    lastKnownLocation: existingUser.lastKnownLocation,
  );

  userStore[email] = updatedUser;
  return BasicResponse(
      success: true, message: 'Notification settings updated successfully');
}

Future<BasicResponse> updateUserLocation(
    String userEmail, Position? position) async {
  if (!userStore.containsKey(userEmail)) {
    return BasicResponse(success: false, message: 'User not found');
  }

  User existingUser = userStore[userEmail]!;

  User updatedUser = User(
    username: existingUser.username,
    email: existingUser.email,
    password: existingUser.password,
    notificationOptions: existingUser.notificationOptions,
    lastKnownLocation: position,
  );

  userStore[userEmail] = updatedUser;
  return BasicResponse(success: true, message: 'Location updated successfully');
}

Future<BasicResponse> updateLocationServices(
    String email, bool locationServicesTurnedOn) async {
  if (!userStore.containsKey(email)) {
    return BasicResponse(success: false, message: 'User not found');
  }

  User existingUser = userStore[email]!;

  User updatedUser = User(
    username: existingUser.username,
    email: existingUser.email,
    password: existingUser.password,
    notificationOptions: NotificationSettings(
      pushNotificationsTurnedOn:
          existingUser.notificationOptions.pushNotificationsTurnedOn,
      emailNotificationsTurnedOn:
          existingUser.notificationOptions.emailNotificationsTurnedOn,
      locationServicesTurnedOn: locationServicesTurnedOn,
    ),
    lastKnownLocation: existingUser.lastKnownLocation,
  );

  userStore[email] = updatedUser;
  return BasicResponse(
      success: true, message: 'Location services updated successfully');
}

Future<BasicResponse> changePassword(
    String email, String newPassword) async {
  User? user = findUser(email);

  if (user != null) {
    User updatedUser = User(
      username: user.username,
      email: user.email,
      password: newPassword,
      notificationOptions: user.notificationOptions,
    );

    userStore[email] = updatedUser;

    return BasicResponse(
        success: true, message: 'Password updated successfully');
  } else {
    return BasicResponse(success: false, message: 'User not found');
  }
}

Future<BasicResponse> changeUsername(String email, String newUsername) async {
  User? user = findUser(email);

  if (user != null) {
    User updatedUser = User(
      username: newUsername,
      email: user.email,
      password: user.password,
      notificationOptions: user.notificationOptions,
      lastKnownLocation: user.lastKnownLocation,
    );
    userStore[email] = updatedUser;

    return BasicResponse(
        success: true, message: 'Name and surname successfully updated');
  } else {
    return BasicResponse(success: false, message: 'User not found');
  }
}

Future<BasicResponse> changeEmail(String email, String newEmail) async {
  User? user = findUser(email);

  if (user != null) {
    User updatedUser = User(
      username: user.username,
      email: newEmail,
      password: user.password,
      notificationOptions: user.notificationOptions,
      lastKnownLocation: user.lastKnownLocation,
    );
    userStore.remove(email);
    userStore[newEmail] = updatedUser;

    return BasicResponse(success: true, message: 'Email successfully updated');
  } else {
    return BasicResponse(success: false, message: 'User not found');
  }
}
