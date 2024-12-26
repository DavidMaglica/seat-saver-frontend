import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

import 'data/api_user.dart';
import 'data/basic_response.dart';
import 'data/notification_settings.dart';
import 'data/user.dart';
import 'dio_setup.dart';

Map<String, User> userStore = {};

final dio = setupDio('/user');

Future<UserResponse?> getUser(String email) async {
  try {
    Response response = await dio.get('/get-user?email=$email');
    APIUser apiUser = APIUser.fromMap(response.data);
    if (apiUser.lastKnownLatitude != null &&
        apiUser.lastKnownLongitude != null) {
      Position position = Position(
        latitude: apiUser.lastKnownLatitude!,
        longitude: apiUser.lastKnownLongitude!,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
      User user = User(
          username: apiUser.username,
          email: apiUser.email,
          password: apiUser.password,
          notificationOptions: apiUser.notificationOptions,
          lastKnownLocation: position);
      return UserResponse(success: true, message: 'User found', user: user);
    } else {
      return UserResponse(
          success: true,
          message: 'User found',
          user: User(
              username: apiUser.username,
              email: apiUser.email,
              password: apiUser.password,
              notificationOptions: apiUser.notificationOptions,
              lastKnownLocation: null));
    }
  } catch (e) {
    return UserResponse(success: false, message: 'User not found', user: null);
  }
}

Future<BasicResponse> signup(
  String username,
  String email,
  String password,
) async {
  if (username.isEmpty || email.isEmpty || password.isEmpty) {
    return BasicResponse(success: false, message: 'Please fill in all fields');
  }

  try {
    final response = await dio
        .post('/signup?email=$email&username=$username&password=$password');
    return BasicResponse.fromJson(response.data);
  } catch (e) {
    return BasicResponse(success: false, message: e.toString());
  }
}

Future<BasicResponse> login(String email, String password) async {
  if (email.isEmpty || password.isEmpty) {
    return BasicResponse(success: false, message: 'Please fill in all fields');
  }

  try {
    final response = await dio.get('/login?email=$email&password=$password');
    return BasicResponse.fromJson(response.data);
  } catch (e) {
    return BasicResponse(success: false, message: e.toString());
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
    notificationOptions: NotificationOptions(
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
    notificationOptions: NotificationOptions(
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

Future<BasicResponse> changePassword(String email, String newPassword) async {
  Response response = await dio
      .patch('/update-user-password?email=$email&newPassword=$newPassword');
  BasicResponse basicResponse = BasicResponse.fromJson(response.data);
  return basicResponse;
}

Future<BasicResponse> changeUsername(String email, String newUsername) async {
  Response response = await dio
      .patch('/update-user-username?email=$email&newUsername=$newUsername');
  BasicResponse basicResponse = BasicResponse.fromJson(response.data);
  return basicResponse;
}

Future<BasicResponse> changeEmail(String email, String newEmail) async {
  Response response =
      await dio.patch('/update-user-email?email=$email&newEmail=$newEmail');
  BasicResponse basicResponse = BasicResponse.fromJson(response.data);
  return basicResponse;
}
