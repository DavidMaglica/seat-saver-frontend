import 'data/basic_response.dart';
import 'data/notification_settings.dart';
import 'data/user.dart';

Map<String, User> userStore = {};

Future<UserResponse?> getUserByEmail(String email) async {
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

User? findUser(String email) {
  return userStore[email];
}

Future<BasicResponse> signup(
    String nameAndSurname, String email, String password) async {
  if (nameAndSurname.isEmpty || email.isEmpty || password.isEmpty) {
    return BasicResponse(success: false, message: 'Please fill in all fields');
  }

  if (userStore.containsKey(email)) {
    return BasicResponse(success: false, message: 'User already exists');
  }

  User newUser = User(
    nameAndSurname: nameAndSurname,
    email: email,
    password: password,
    notificationOptions: NotificationSettings(
      pushNotificationsTurnedOn: true,
      emailNotificationsTurnedOn: true,
      locationServicesTurnedOn: true,
    ),
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

Future<NotificationSettingsResponse> getNotificationSettingsByEmail(
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
    nameAndSurname: existingUser.nameAndSurname,
    email: existingUser.email,
    password: existingUser.password,
    notificationOptions: NotificationSettings(
      pushNotificationsTurnedOn: pushNotificationsTurnedOn,
      emailNotificationsTurnedOn: emailNotificationsTurnedOn,
      locationServicesTurnedOn: locationServicesTurnedOn,
    ),
  );

  userStore[email] = updatedUser;
  return BasicResponse(
      success: true, message: 'Notification settings updated successfully');
}

Future<BasicResponse> changePasswordByEmail(
    String email, String newPassword) async {
  User? user = findUser(email);

  if (user != null) {
    User updatedUser = User(
      nameAndSurname: user.nameAndSurname,
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

Future<BasicResponse> changeNameAndSurname(
    String email, String newNameAndSurname) async {
  User? user = findUser(email);

  if (user != null) {
    User updatedUser = User(
      nameAndSurname: newNameAndSurname,
      email: user.email,
      password: user.password,
      notificationOptions: user.notificationOptions,
    );
    userStore[email] = updatedUser;

    return BasicResponse(
        success: true, message: 'Name and surname successfully updated');
  } else {
    return BasicResponse(success: false, message: 'User not found');
  }
}
