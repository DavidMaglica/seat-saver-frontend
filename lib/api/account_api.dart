import 'package:TableReserver/api/api_routes.dart';
import 'package:TableReserver/api/data/basic_response.dart';
import 'package:TableReserver/api/data/notification_settings.dart';
import 'package:TableReserver/api/data/user.dart';
import 'package:TableReserver/api/data/user_location.dart';
import 'package:TableReserver/api/data/user_response.dart';
import 'package:TableReserver/api/dio_setup.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

final dio = setupDio(ApiRoutes.user);
final logger = Logger();

class AccountApi {
  Future<UserResponse?> getUser(int userId) async {
    try {
      Response response = await dio.get(
        ApiRoutes.getUser,
        queryParameters: <String, int>{
          'userId': userId,
        },
      );

      return UserResponse(
        success: true,
        message: 'User found',
        user: User.fromJson(response.data),
      );
    } catch (e) {
      return UserResponse(
        success: false,
        message: 'User not found',
        user: null,
      );
    }
  }

  Future<BasicResponse<User>> signUp(
    String email,
    String username,
    String password,
  ) async {
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      return BasicResponse(
        success: false,
        message: 'Please fill in all fields',
      );
    }

    try {
      final response = await dio.post(
        ApiRoutes.signUp,
        queryParameters: <String, String>{
          'email': email,
          'username': username,
          'password': password,
        },
      );

      final basicResponse = BasicResponse<APIUser>.fromJson(
        response.data,
        (json) => APIUser.fromJson(json),
      );

      final user = basicResponse.data?.toUser();

      return BasicResponse<User>(
        success: true,
        message: 'User signed up',
        data: user,
      );
    } catch (e) {
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<BasicResponse<User>> logIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return BasicResponse(
        success: false,
        message: 'Please fill in all fields',
      );
    }

    try {
      final response = await dio.get(
        ApiRoutes.logIn,
        queryParameters: <String, String>{
          'email': email,
          'password': password,
        },
      );

      final basicResponse = BasicResponse<APIUser>.fromJson(
        response.data,
        (json) => APIUser.fromJson(json),
      );

      return BasicResponse<User>(
        success: basicResponse.success,
        message: basicResponse.message,
        data: basicResponse.data?.toUser(),
      );
    } catch (e) {
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<NotificationOptions?> getNotificationOptions(int userId) async {
    try {
      final response = await dio.get(
        ApiRoutes.getNotificationOptions,
        queryParameters: <String, int>{
          'userId': userId,
        },
      );

      return NotificationOptions.fromJson(response.data);
    } catch (e) {
      logger.e('Error fetching notification options: $e');
      return null;
    }
  }

  Future<UserLocation?> getLastKnownLocation(int userId) async {
    try {
      final response = await dio.get(
        ApiRoutes.getLocation,
        queryParameters: <String, int>{
          'userId': userId,
        },
      );

      return UserLocation.fromJson(response.data);
    } catch (e) {
      logger.e('Error fetching last known location: $e');
      return null;
    }
  }

  Future<BasicResponse> updateUserNotificationOptions(
    int userId,
    bool pushNotificationsTurnedOn,
    bool emailNotificationsTurnedOn,
    bool locationServicesTurnedOn,
  ) async {
    try {
      final response = await dio.patch(
        ApiRoutes.updateNotificationOptions,
        queryParameters: <String, dynamic>{
          'userId': userId,
          'pushNotificationsTurnedOn': pushNotificationsTurnedOn,
          'emailNotificationsTurnedOn': emailNotificationsTurnedOn,
          'locationServicesTurnedOn': locationServicesTurnedOn,
        },
      );

      return BasicResponse.fromJson(response.data, (json) => json);
    } catch (e) {
      logger.e('Error updating notification options: $e');
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<BasicResponse> updateUserLocation(
    int userId,
    Position? position,
  ) async {
    try {
      final response = await dio.patch(
        ApiRoutes.updateLocation,
        queryParameters: <String, dynamic>{
          'userId': userId,
          'latitude': position!.latitude,
          'longitude': position.longitude,
        },
      );

      return BasicResponse.fromJson(response.data, (json) => json);
    } catch (e) {
      logger.e('Error updating user location: $e');
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<BasicResponse> changePassword(int userId, String newPassword) async {
    try {
      Response response = await dio.patch(
        ApiRoutes.updatePassword,
        queryParameters: <String, dynamic>{
          'userId': userId,
          'newPassword': newPassword,
        },
      );
      BasicResponse basicResponse =
          BasicResponse.fromJson(response.data, (json) => json);
      return basicResponse;
    } catch (e) {
      logger.e('Error changing password: $e');
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<BasicResponse> changeUsername(int userId, String newUsername) async {
    try {
      Response response = await dio.patch(
        ApiRoutes.updateUsername,
        queryParameters: <String, dynamic>{
          'userId': userId,
          'newUsername': newUsername,
        },
      );
      BasicResponse basicResponse =
          BasicResponse.fromJson(response.data, (json) => json);
      return basicResponse;
    } catch (e) {
      logger.e('Error changing username: $e');
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<BasicResponse> changeEmail(int userId, String newEmail) async {
    try {
      Response response = await dio.patch(
        ApiRoutes.updateEmail,
        queryParameters: <String, dynamic>{
          'userId': userId,
          'newEmail': newEmail,
        },
      );
      BasicResponse basicResponse =
          BasicResponse.fromJson(response.data, (json) => json);
      return basicResponse;
    } catch (e) {
      logger.e('Error changing email: $e');
      return BasicResponse(success: false, message: e.toString());
    }
  }
}
