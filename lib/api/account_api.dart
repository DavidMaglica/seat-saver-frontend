import 'package:TableReserver/api/api_routes.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

import 'data/api_user.dart';
import 'data/basic_response.dart';
import 'data/notification_settings.dart';
import 'data/user.dart';
import 'data/user_location.dart';
import 'data/user_response.dart';
import 'dio_setup.dart';

final dio = setupDio(ApiRoutes.USER);

class AccountApi {
  Future<UserResponse?> getUser(String email) async {
    try {
      Response response = await dio.get('${ApiRoutes.GET_USER}?email=$email');

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
      return UserResponse(
          success: false, message: 'User not found', user: null);
    }
  }

  Future<BasicResponse> signup(
    String username,
    String email,
    String password,
  ) async {
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      return BasicResponse(
          success: false, message: 'Please fill in all fields');
    }

    try {
      final response = await dio.post(
          '${ApiRoutes.SIGNUP}?email=$email&username=$username&password=$password');
      return BasicResponse.fromJson(response.data);
    } catch (e) {
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<BasicResponse> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return BasicResponse(
          success: false, message: 'Please fill in all fields');
    }

    try {
      final response =
          await dio.get('${ApiRoutes.LOGIN}?email=$email&password=$password');
      return BasicResponse.fromJson(response.data);
    } catch (e) {
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<NotificationOptions> getNotificationOptions(String email) async {
    final response = await dio
        .get('${ApiRoutes.GET_NOTIFICATION_OPTIONS}?email=$email');

    return NotificationOptions.fromMap(response.data);
  }

  Future<UserLocation> getLastKnownLocation(String email) async {
    final response =
        await dio.get('${ApiRoutes.GET_LOCATION}?email=$email');

    return UserLocation.fromMap(response.data);
  }

  Future<BasicResponse> updateUserNotificationOptions(
    String email,
    bool pushNotificationsTurnedOn,
    bool emailNotificationsTurnedOn,
    bool locationServicesTurnedOn,
  ) async {
    final response = await dio.patch(
        '${ApiRoutes.UPDATE_NOTIFICATION_OPTIONS}?email=$email&pushNotificationsTurnedOn=$pushNotificationsTurnedOn&emailNotificationsTurnedOn=$emailNotificationsTurnedOn&locationServicesTurnedOn=$locationServicesTurnedOn');

    return BasicResponse.fromJson(response.data);
  }

  Future<BasicResponse> updateUserLocation(
      String userEmail, Position? position) async {
    final response = await dio.patch(
        '${ApiRoutes.UPDATE_LOCATION}?email=$userEmail&latitude=${position!.latitude}&longitude=${position.longitude}');

    return BasicResponse.fromJson(response.data);
  }

  Future<BasicResponse> changePassword(String email, String newPassword) async {
    Response response = await dio.patch(
        '${ApiRoutes.UPDATE_PASSWORD}?email=$email&newPassword=$newPassword');
    BasicResponse basicResponse = BasicResponse.fromJson(response.data);
    return basicResponse;
  }

  Future<BasicResponse> changeUsername(String email, String newUsername) async {
    Response response = await dio.patch(
        '${ApiRoutes.UPDATE_USERNAME}?email=$email&newUsername=$newUsername');
    BasicResponse basicResponse = BasicResponse.fromJson(response.data);
    return basicResponse;
  }

  Future<BasicResponse> changeEmail(String email, String newEmail) async {
    Response response = await dio.patch(
        '${ApiRoutes.UPDATE_EMAIL}?email=$email&newEmail=$newEmail');
    BasicResponse basicResponse = BasicResponse.fromJson(response.data);
    return basicResponse;
  }
}
