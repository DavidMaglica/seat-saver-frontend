import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:table_reserver/api/common/api_routes.dart';
import 'package:table_reserver/api/common/dio_setup.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/notification_settings.dart';
import 'package:table_reserver/api/data/user.dart';
import 'package:table_reserver/api/data/user_location.dart';
import 'package:table_reserver/api/data/user_response.dart';
import 'package:table_reserver/utils/logger.dart';

class AccountApi {
  final Dio dio;

  AccountApi({Dio? dio}) : dio = dio ?? setupDio();

  Future<UserResponse?> getUser(int userId) async {
    try {
      Response response = await dio.get(ApiRoutes.userById(userId));

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

  Future<List<User>> getUsersByIds(List<int> userIds) async {
    try {
      Response response = await dio.get(
        ApiRoutes.usersByIds,
        queryParameters: <String, List<int>>{'userIds': userIds},
      );

      List<User> users = (response.data as List)
          .map((userJson) => User.fromJson(userJson))
          .toList();

      return users;
    } catch (e) {
      logger.e('Error fetching users: $e');
      return [];
    }
  }

  Future<BasicResponse<int>> signUp(
    String email,
    String username,
    String password,
    bool isOwner,
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
        queryParameters: <String, dynamic>{
          'email': email,
          'username': username,
          'password': password,
          'isOwner': isOwner,
        },
      );

      final int? userId = response.data['data'] as int?;

      if (userId == null) {
        return BasicResponse(
          success: false,
          message: 'Sign up failed. Please try again.',
        );
      }

      return BasicResponse<int>(
        success: true,
        message: 'User signed up',
        data: userId,
      );
    } catch (e) {
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<BasicResponse<int?>> logIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return BasicResponse(
        success: false,
        message: 'Please fill in all fields',
      );
    }

    try {
      final response = await dio.get(
        ApiRoutes.logIn,
        queryParameters: <String, String>{'email': email, 'password': password},
      );

      final int? userId = response.data['data'] as int?;
      final String message = response.data['message'] as String;

      return BasicResponse<int?>(success: true, message: message, data: userId);
    } catch (e) {
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<BasicResponse> changePassword(int userId, String newPassword) async {
    try {
      Response response = await dio.patch(
        ApiRoutes.updatePassword(userId),
        queryParameters: <String, dynamic>{'newPassword': newPassword},
      );
      BasicResponse basicResponse = BasicResponse.fromJson(
        response.data,
        (json) => json,
      );
      return basicResponse;
    } catch (e) {
      logger.e('Error changing password: $e');
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<BasicResponse> changeUsername(int userId, String newUsername) async {
    try {
      Response response = await dio.patch(
        ApiRoutes.updateUsername(userId),
        queryParameters: <String, dynamic>{'newUsername': newUsername},
      );
      BasicResponse basicResponse = BasicResponse.fromJson(
        response.data,
        (json) => json,
      );
      return basicResponse;
    } catch (e) {
      logger.e('Error changing username: $e');
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<BasicResponse> changeEmail(int userId, String newEmail) async {
    try {
      Response response = await dio.patch(
        ApiRoutes.updateEmail(userId),
        queryParameters: <String, dynamic>{'newEmail': newEmail},
      );
      BasicResponse basicResponse = BasicResponse.fromJson(
        response.data,
        (json) => json,
      );
      return basicResponse;
    } catch (e) {
      logger.e('Error changing email: $e');
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<NotificationOptions?> getNotificationOptions(int userId) async {
    try {
      final response = await dio.get(ApiRoutes.userNotifications(userId));

      return NotificationOptions.fromJson(response.data);
    } catch (e) {
      logger.e('Error fetching notification options: $e');
      return null;
    }
  }

  Future<UserLocation?> getLastKnownLocation(int userId) async {
    try {
      final response = await dio.get(ApiRoutes.userLocation(userId));

      return UserLocation.fromJson(response.data);
    } catch (e) {
      logger.e('Error fetching last known location: $e');
      return null;
    }
  }

  Future<BasicResponse> updateUserNotificationOptions(
    int userId,
    bool isPushNotificationsEnabled,
    bool isEmailNotificationsEnabled,
    bool isLocationServicesEnabled,
  ) async {
    try {
      final response = await dio.patch(
        ApiRoutes.updateNotifications(userId),
        queryParameters: <String, dynamic>{
          'isPushNotificationsEnabled': isPushNotificationsEnabled,
          'isEmailNotificationsEnabled': isEmailNotificationsEnabled,
          'isLocationServicesEnabled': isLocationServicesEnabled,
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
    Position position,
  ) async {
    try {
      final response = await dio.patch(
        ApiRoutes.updateLocation(userId),
        queryParameters: <String, dynamic>{
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
      );

      return BasicResponse.fromJson(response.data, (json) => json);
    } catch (e) {
      logger.e('Error updating user location: $e');
      return BasicResponse(success: false, message: e.toString());
    }
  }
}
