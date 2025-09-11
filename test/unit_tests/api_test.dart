import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seat_saver/api/account_api.dart';
import 'package:seat_saver/api/common/api_routes.dart';
import 'package:seat_saver/api/data/basic_response.dart';
import 'package:seat_saver/api/data/notification_settings.dart';
import 'package:seat_saver/api/data/paged_response.dart';
import 'package:seat_saver/api/data/rating.dart';
import 'package:seat_saver/api/data/reservation_details.dart';
import 'package:seat_saver/api/data/user.dart';
import 'package:seat_saver/api/data/user_location.dart';
import 'package:seat_saver/api/data/user_response.dart';
import 'package:seat_saver/api/data/venue.dart';
import 'package:seat_saver/api/data/venue_type.dart';
import 'package:seat_saver/api/geolocation_api.dart';
import 'package:seat_saver/api/reservation_api.dart';
import 'package:seat_saver/api/support_api.dart';
import 'package:seat_saver/api/venue_api.dart';

class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response {}

void main() {
  late MockDio mockDio;

  late AccountApi accountApi;
  late GeolocationApi geolocationApi;
  late ReservationsApi reservationsApi;
  late SupportApi supportApi;
  late VenuesApi venuesApi;

  setUp(() {
    mockDio = MockDio();
    accountApi = AccountApi(dio: mockDio);
    geolocationApi = GeolocationApi(dio: mockDio);
    reservationsApi = ReservationsApi(dio: mockDio);
    supportApi = SupportApi(dio: mockDio);
    venuesApi = VenuesApi(dio: mockDio);
  });

  const testUserId = 1;
  const testUsername = 'testuser';
  const newUsername = 'newuser';
  const testPassword = 'password123';
  const newPassword = 'newpassword123';
  const testUserEmail = 'user@mail.com';
  const newEmail = 'newtest@mail.com';
  const testSecondUserId = 2;
  const testSecondUsername = 'seconduser';
  const testSecondEmail = 'seconduser@mail.com';

  const latitude = 45.23;
  const longitude = 13.61;

  const testVenueId = 1;

  const testOwnerId = 2;
  final testDate = DateTime(2025, 8, 31, 12, 0);

  group('Account Api', () {
    group('getUser', () {
      test('should return UserResponse when success', () async {
        final mockData = {
          'id': testUserId,
          'username': testUsername,
          'email': testUserEmail,
        };

        final mockResponse = Response(
          data: mockData,
          requestOptions: RequestOptions(path: ApiRoutes.userById(testUserId)),
        );

        when(
          () => mockDio.get(ApiRoutes.userById(testUserId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await accountApi.getUser(testUserId);

        expect(result, isA<UserResponse>());
        expect(result!.success, true);
        expect(result.message, 'User found');
        expect(result.user!.id, testUserId);
        expect(result.user!.username, testUsername);
        expect(result.user!.email, testUserEmail);
      });

      test('should return UserResponse with false when Dio throws', () async {
        when(() => mockDio.get(ApiRoutes.userById(testUserId))).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.userById(testUserId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await accountApi.getUser(testUserId);

        expect(result, isA<UserResponse>());
        expect(result!.success, false);
        expect(result.message, 'User not found');
        expect(result.user, isNull);
      });
    });

    group('getUsersByIds', () {
      const testUserIds = [testUserId, testSecondUserId];

      test('should return list of Users on success', () async {
        final mockData = [
          {'id': testUserId, 'username': testUsername, 'email': testUserEmail},
          {
            'id': testSecondUserId,
            'username': testSecondUsername,
            'email': testSecondEmail,
          },
        ];

        final mockResponse = Response(
          data: mockData,
          requestOptions: RequestOptions(path: ApiRoutes.usersByIds),
        );

        when(
          () => mockDio.get(
            ApiRoutes.usersByIds,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await accountApi.getUsersByIds(testUserIds);

        expect(result, isA<List<User>>());
        expect(result.length, 2);
        expect(result[0].id, testUserId);
        expect(result[0].username, testUsername);
        expect(result[0].email, testUserEmail);

        expect(result[1].id, testSecondUserId);
        expect(result[1].username, testSecondUsername);
        expect(result[1].email, testSecondEmail);
      });

      test('should return empty list when Dio throws', () async {
        when(
          () => mockDio.get(
            ApiRoutes.usersByIds,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiRoutes.usersByIds),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await accountApi.getUsersByIds(testUserIds);

        expect(result, isEmpty);
      });

      test('should send correct query parameters', () async {
        late Map<String, dynamic> capturedParams;

        final mockResponse = Response(
          data: [
            {
              'id': testUserId,
              'username': testUsername,
              'email': testUserEmail,
            },
          ],
          requestOptions: RequestOptions(path: ApiRoutes.usersByIds),
        );

        when(
          () => mockDio.get(
            ApiRoutes.usersByIds,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          capturedParams =
              invocation.namedArguments[const Symbol('queryParameters')]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        await accountApi.getUsersByIds(testUserIds);

        expect(capturedParams['userIds'], testUserIds);
      });
    });

    group('signUp', () {
      test('should return BasicResponse with userId on success', () async {
        final mockResponse = Response(
          data: {
            'success': true,
            'message': 'User signed up',
            'data': testUserId,
          },
          requestOptions: RequestOptions(path: ApiRoutes.signUp),
        );

        when(
          () => mockDio.post(
            ApiRoutes.signUp,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await accountApi.signUp(
          testUserEmail,
          testUsername,
          testPassword,
          false,
        );

        expect(result.success, true);
        expect(result.data, testUserId);
        expect(result.message, 'User signed up');
      });

      test(
        'should return BasicResponse with false on validation error',
        () async {
          final result = await accountApi.signUp(
            '',
            testUsername,
            testPassword,
            false,
          );

          expect(result.success, false);
          expect(result.message, 'Please fill in all fields');
          expect(result.data, isNull);
        },
      );

      test('should return BasicResponse with false when Dio throws', () async {
        when(
          () => mockDio.post(
            ApiRoutes.signUp,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiRoutes.signUp),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await accountApi.signUp(
          testUserEmail,
          testUsername,
          testPassword,
          true,
        );

        expect(result.success, false);
        expect(result.message, contains('Network error'));
        expect(result.data, isNull);
      });

      test('should send correct data', () async {
        late Map<String, dynamic> capturedParams;

        final mockResponse = Response(
          data: {'success': true, 'message': 'User signed up', 'data': 1},
          requestOptions: RequestOptions(path: ApiRoutes.signUp),
        );

        when(
          () => mockDio.post(
            ApiRoutes.signUp,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          capturedParams =
              invocation.namedArguments[#queryParameters]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        await accountApi.signUp(
          testUserEmail,
          testUsername,
          testPassword,
          true,
        );

        expect(capturedParams['email'], testUserEmail);
        expect(capturedParams['username'], testUsername);
        expect(capturedParams['password'], testPassword);
        expect(capturedParams['isOwner'], true);
      });
    });

    group('logIn', () {
      test('should return BasicResponse on success', () async {
        final mockResponse = Response(
          data: {
            'success': true,
            'message': 'Login successful',
            'data': testUserId,
          },
          requestOptions: RequestOptions(path: ApiRoutes.logIn),
        );

        when(
          () => mockDio.get(
            ApiRoutes.logIn,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await accountApi.logIn(testUserEmail, testPassword);

        expect(result.success, true);
        expect(result.data, testUserId);
        expect(result.message, 'Login successful');
      });

      test(
        'should return BasicResponse with false on validation error',
        () async {
          final result = await accountApi.logIn('', testPassword);

          expect(result.success, false);
          expect(result.message, 'Please fill in all fields');
          expect(result.data, isNull);
        },
      );

      test('should return BasicResponse with false when Dio throws', () async {
        when(
          () => mockDio.get(
            ApiRoutes.logIn,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiRoutes.logIn),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await accountApi.logIn(testUserEmail, testPassword);

        expect(result.success, false);
        expect(result.message, contains('Network error'));
        expect(result.data, isNull);
      });

      test('should send correct query parameters', () async {
        late Map<String, dynamic> capturedParams;

        final mockResponse = Response(
          data: {'success': true, 'message': 'OK', 'data': 1},
          requestOptions: RequestOptions(path: ApiRoutes.logIn),
        );

        when(
          () => mockDio.get(
            ApiRoutes.logIn,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          capturedParams =
              invocation.namedArguments[#queryParameters]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        await accountApi.logIn(testUserEmail, testPassword);

        expect(capturedParams['email'], testUserEmail);
        expect(capturedParams['password'], testPassword);
      });
    });

    group('changePassword', () {
      test('should return BasicResponse on success', () async {
        final mockResponse = Response(
          data: {'success': true, 'message': 'Password updated', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.updatePassword(testUserId),
          ),
        );

        when(
          () => mockDio.patch(
            ApiRoutes.updatePassword(testUserId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await accountApi.changePassword(testUserId, newPassword);

        expect(result, isA<BasicResponse>());
        expect(result.success, true);
        expect(result.message, 'Password updated');
      });

      test('should return BasicResponse with false when Dio throws', () async {
        when(
          () => mockDio.patch(
            ApiRoutes.updatePassword(testUserId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.updatePassword(testUserId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await accountApi.changePassword(testUserId, newPassword);

        expect(result, isA<BasicResponse>());
        expect(result.success, false);
        expect(result.message, contains('Network error'));
      });

      test('should send correct data', () async {
        late Map<String, dynamic> capturedParams;

        final mockResponse = Response(
          data: {'success': true, 'message': 'Password updated', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.updatePassword(testUserId),
          ),
        );

        when(
          () => mockDio.patch(
            ApiRoutes.updatePassword(testUserId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          capturedParams =
              invocation.namedArguments[#queryParameters]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        await accountApi.changePassword(testUserId, newPassword);

        expect(capturedParams['newPassword'], newPassword);
      });
    });

    group('changeUsername', () {
      test('should return BasicResponse on success', () async {
        final mockResponse = Response(
          data: {'success': true, 'message': 'Username updated', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.updateUsername(testUserId),
          ),
        );

        when(
          () => mockDio.patch(
            ApiRoutes.updateUsername(testUserId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await accountApi.changeUsername(testUserId, newUsername);

        expect(result, isA<BasicResponse>());
        expect(result.success, true);
        expect(result.message, 'Username updated');
      });

      test('should return BasicResponse with false when Dio throws', () async {
        when(
          () => mockDio.patch(
            ApiRoutes.updateUsername(testUserId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.updateUsername(testUserId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await accountApi.changeUsername(testUserId, newUsername);

        expect(result, isA<BasicResponse>());
        expect(result.success, false);
        expect(result.message, contains('Network error'));
      });

      test('should send correct data', () async {
        late Map<String, dynamic> capturedParams;

        final mockResponse = Response(
          data: {'success': true, 'message': 'Username updated', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.updateUsername(testUserId),
          ),
        );

        when(
          () => mockDio.patch(
            ApiRoutes.updateUsername(testUserId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          capturedParams =
              invocation.namedArguments[#queryParameters]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        await accountApi.changeUsername(testUserId, newUsername);

        expect(capturedParams['newUsername'], newUsername);
      });
    });

    group('changeEmail', () {
      test('should return BasicResponse on success', () async {
        final mockResponse = Response(
          data: {'success': true, 'message': 'Email updated', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.updateEmail(testUserId),
          ),
        );

        when(
          () => mockDio.patch(
            ApiRoutes.updateEmail(testUserId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await accountApi.changeEmail(testUserId, newEmail);

        expect(result, isA<BasicResponse>());
        expect(result.success, true);
        expect(result.message, 'Email updated');
      });

      test('should return BasicResponse with false when Dio throws', () async {
        when(
          () => mockDio.patch(
            ApiRoutes.updateEmail(testUserId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.updateEmail(testUserId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await accountApi.changeEmail(testUserId, newEmail);

        expect(result, isA<BasicResponse>());
        expect(result.success, false);
        expect(result.message, contains('Network error'));
      });

      test('should send correct data', () async {
        late Map<String, dynamic> capturedParams;

        final mockResponse = Response(
          data: {'success': true, 'message': 'Email updated', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.updateEmail(testUserId),
          ),
        );

        when(
          () => mockDio.patch(
            ApiRoutes.updateEmail(testUserId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          capturedParams =
              invocation.namedArguments[#queryParameters]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        await accountApi.changeEmail(testUserId, newEmail);

        expect(capturedParams['newEmail'], newEmail);
      });
    });

    group('getNotificationOptions', () {
      test('should return NotificationOptions on success', () async {
        final mockResponse = Response(
          data: {
            'isPushNotificationsEnabled': true,
            'isEmailNotificationsEnabled': false,
            'isLocationServicesEnabled': true,
          },
          requestOptions: RequestOptions(
            path: ApiRoutes.userNotifications(testUserId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.userNotifications(testUserId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await accountApi.getNotificationOptions(testUserId);

        expect(result, isA<NotificationOptions>());
        expect(result!.isPushNotificationsEnabled, true);
        expect(result.isEmailNotificationsEnabled, false);
        expect(result.isLocationServicesEnabled, true);
      });

      test('should return null when Dio throws', () async {
        when(
          () => mockDio.get(ApiRoutes.userNotifications(testUserId)),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.userNotifications(testUserId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await accountApi.getNotificationOptions(testUserId);

        expect(result, isNull);
      });
    });

    group('getLastKnownLocation', () {
      test('should return UserLocation on success', () async {
        final mockResponse = Response(
          data: {'latitude': latitude, 'longitude': longitude},
          requestOptions: RequestOptions(
            path: ApiRoutes.userLocation(testUserId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.userLocation(testUserId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await accountApi.getLastKnownLocation(testUserId);

        expect(result, isA<UserLocation>());
        expect(result!.latitude, latitude);
        expect(result.longitude, longitude);
      });

      test('should return null when Dio throws', () async {
        when(() => mockDio.get(ApiRoutes.userLocation(testUserId))).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.userLocation(testUserId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await accountApi.getLastKnownLocation(testUserId);

        expect(result, isNull);
      });
    });

    group('updateUserNotificationOptions', () {
      test('should return BasicResponse on success', () async {
        final mockResponse = Response(
          data: {'success': true, 'message': 'Updated', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.updateNotifications(testUserId),
          ),
        );

        when(
          () => mockDio.patch(
            ApiRoutes.updateNotifications(testUserId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await accountApi.updateUserNotificationOptions(
          testUserId,
          true,
          false,
          true,
        );

        expect(result, isA<BasicResponse>());
        expect(result.success, true);
        expect(result.message, 'Updated');
      });

      test('should return BasicResponse with false when Dio throws', () async {
        when(
          () => mockDio.patch(
            ApiRoutes.updateNotifications(testUserId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.updateNotifications(testUserId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await accountApi.updateUserNotificationOptions(
          testUserId,
          true,
          false,
          true,
        );

        expect(result, isA<BasicResponse>());
        expect(result.success, false);
        expect(result.message, contains('Network error'));
      });

      test('should send correct data', () async {
        late Map<String, dynamic> capturedData;

        final mockResponse = Response(
          data: {'success': true, 'message': 'Updated', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.updateNotifications(testUserId),
          ),
        );

        when(
          () => mockDio.patch(
            ApiRoutes.updateNotifications(testUserId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          capturedData =
              invocation.namedArguments[#queryParameters]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        await accountApi.updateUserNotificationOptions(
          testUserId,
          true,
          false,
          true,
        );

        expect(capturedData['isPushNotificationsEnabled'], true);
        expect(capturedData['isEmailNotificationsEnabled'], false);
        expect(capturedData['isLocationServicesEnabled'], true);
      });
    });

    group('updateUserLocation', () {
      final testPosition = Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime.now(),
        accuracy: 1,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );

      test('should return BasicResponse on success', () async {
        final mockResponse = Response(
          data: {'success': true, 'message': 'Location updated', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.updateLocation(testUserId),
          ),
        );

        when(
          () => mockDio.patch(
            ApiRoutes.updateLocation(testUserId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await accountApi.updateUserLocation(
          testUserId,
          testPosition,
        );

        expect(result, isA<BasicResponse>());
        expect(result.success, true);
        expect(result.message, 'Location updated');
      });

      test('should return BasicResponse with false when Dio throws', () async {
        when(
          () => mockDio.patch(
            ApiRoutes.updateLocation(testUserId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.updateLocation(testUserId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await accountApi.updateUserLocation(
          testUserId,
          testPosition,
        );

        expect(result, isA<BasicResponse>());
        expect(result.success, false);
        expect(result.message, contains('Network error'));
      });

      test('should send correct data', () async {
        late Map<String, dynamic> capturedData;

        final mockResponse = Response(
          data: {'success': true, 'message': 'Location updated', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.updateLocation(testUserId),
          ),
        );

        when(
          () => mockDio.patch(
            ApiRoutes.updateLocation(testUserId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          capturedData =
              invocation.namedArguments[#queryParameters]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        await accountApi.updateUserLocation(testUserId, testPosition);

        expect(capturedData['latitude'], testPosition.latitude);
        expect(capturedData['longitude'], testPosition.longitude);
      });
    });
  });

  group('Geolocation Api', () {
    final testLocation = UserLocation(latitude: latitude, longitude: longitude);

    test('getNearbyCities returns list of cities on success', () async {
      final mockResponse = Response(
        data: ['Poreč', 'Rovinj', 'Pula'],
        statusCode: 200,
        requestOptions: RequestOptions(path: ApiRoutes.getNearbyCities),
      );

      when(
        () => mockDio.get(
          ApiRoutes.getNearbyCities,
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => mockResponse);

      final result = await geolocationApi.getNearbyCities(testLocation);

      expect(result, isA<List<String>>());
      expect(result, containsAll(['Poreč', 'Rovinj', 'Pula']));
    });

    test('getNearbyCities returns empty list for non-200 response', () async {
      final mockResponse = Response(
        data: 'Server error',
        statusCode: 500,
        requestOptions: RequestOptions(path: ApiRoutes.getNearbyCities),
      );

      when(
        () => mockDio.get(
          ApiRoutes.getNearbyCities,
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => mockResponse);

      final result = await geolocationApi.getNearbyCities(testLocation);

      expect(result, isEmpty);
    });

    test('getNearbyCities returns empty list when Dio throws', () async {
      when(
        () => mockDio.get(
          ApiRoutes.getNearbyCities,
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiRoutes.getNearbyCities),
          type: DioExceptionType.connectionError,
          error: 'Network error',
        ),
      );

      final result = await geolocationApi.getNearbyCities(testLocation);

      expect(result, isEmpty);
    });

    test('getNearbyCities sends correct query parameters', () async {
      late Map<String, dynamic> capturedParams;

      final mockResponse = Response(
        data: ['Poreč'],
        statusCode: 200,
        requestOptions: RequestOptions(path: ApiRoutes.getNearbyCities),
      );

      when(
        () => mockDio.get(
          ApiRoutes.getNearbyCities,
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((invocation) async {
        capturedParams =
            invocation.namedArguments[const Symbol('queryParameters')]
                as Map<String, dynamic>;
        return mockResponse;
      });

      await geolocationApi.getNearbyCities(testLocation);

      expect(capturedParams['latitude'], testLocation.latitude);
      expect(capturedParams['longitude'], testLocation.longitude);
    });
  });

  group('Reservations Api', () {
    const testReservationId = 1;
    const testNumberOfGuests = 4;
    const testReservationsCount = 2;

    group('getUserReservations', () {
      test('should return list of ReservationDetails on success', () async {
        final mockResponse = Response(
          data: [
            {
              'id': 1,
              'userId': testUserId,
              'venueId': testVenueId,
              'numberOfGuests': testNumberOfGuests,
              'datetime': testDate.toIso8601String(),
            },
          ],
          requestOptions: RequestOptions(
            path: ApiRoutes.userReservations(testUserId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.userReservations(testUserId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await reservationsApi.getUserReservations(testUserId);

        expect(result, isA<List<ReservationDetails>>());
        expect(result.length, 1);
        expect(result.first.userId, testUserId);
        expect(result.first.venueId, testVenueId);
        expect(result.first.numberOfGuests, testNumberOfGuests);
        expect(result.first.datetime, testDate);
      });

      test('should return empty list when API returns empty array', () async {
        final mockResponse = Response(
          data: [],
          requestOptions: RequestOptions(
            path: ApiRoutes.userReservations(testUserId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.userReservations(testUserId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await reservationsApi.getUserReservations(testUserId);

        expect(result, isEmpty);
      });

      test('should return empty list when Dio throws', () async {
        when(
          () => mockDio.get(ApiRoutes.userReservations(testUserId)),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.userReservations(testUserId),
            ),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await reservationsApi.getUserReservations(testUserId);

        expect(result, isEmpty);
      });
    });

    group('getOwnerReservations', () {
      test('should return list of ReservationDetails on success', () async {
        final mockResponse = Response(
          data: [
            {
              'id': 1,
              'userId': testUserId,
              'venueId': testVenueId,
              'numberOfGuests': testNumberOfGuests,
              'datetime': testDate.toIso8601String(),
            },
            {
              'id': 2,
              'userId': testUserId,
              'venueId': testVenueId + 1,
              'numberOfGuests': testNumberOfGuests,
              'datetime': testDate
                  .add(const Duration(days: 1))
                  .toIso8601String(),
            },
          ],
          requestOptions: RequestOptions(
            path: ApiRoutes.ownerReservations(testOwnerId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.ownerReservations(testOwnerId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await reservationsApi.getOwnerReservations(testOwnerId);

        expect(result, isA<List<ReservationDetails>>());
        expect(result.length, 2);
        expect(result[0].userId, testUserId);
        expect(result[0].venueId, testVenueId);
        expect(result[0].numberOfGuests, testNumberOfGuests);
        expect(result[0].datetime, testDate);

        expect(result[1].userId, testUserId);
        expect(result[1].venueId, testVenueId + 1);
        expect(result[1].numberOfGuests, testNumberOfGuests);
        expect(result[1].datetime, testDate.add(const Duration(days: 1)));
      });

      test('should return empty list when API returns empty array', () async {
        final mockResponse = Response(
          data: [],
          requestOptions: RequestOptions(
            path: ApiRoutes.ownerReservations(testOwnerId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.ownerReservations(testOwnerId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await reservationsApi.getOwnerReservations(testOwnerId);

        expect(result, isA<List<ReservationDetails>>());
        expect(result, isEmpty);
      });

      test('should return empty list when Dio throws', () async {
        when(
          () => mockDio.get(ApiRoutes.ownerReservations(testOwnerId)),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.ownerReservations(testOwnerId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await reservationsApi.getOwnerReservations(testOwnerId);

        expect(result, isA<List<ReservationDetails>>());
        expect(result, isEmpty);
      });
    });

    group('getReservationById', () {
      test('should return ReservationDetails on success', () async {
        final mockResponse = Response(
          data: {
            'id': testReservationId,
            'userId': testUserId,
            'venueId': testVenueId,
            'numberOfGuests': testNumberOfGuests,
            'datetime': testDate.toIso8601String(),
          },
          requestOptions: RequestOptions(
            path: ApiRoutes.reservationById(testReservationId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.reservationById(testReservationId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await reservationsApi.getReservationById(
          testReservationId,
        );

        expect(result, isA<ReservationDetails>());
        expect(result?.id, testReservationId);
        expect(result?.userId, testUserId);
        expect(result?.venueId, testVenueId);
        expect(result?.numberOfGuests, testNumberOfGuests);
        expect(result?.datetime, testDate);
      });

      test('should return null when reservation not found', () async {
        final mockResponse = Response(
          data: 'Not Found',
          statusCode: 404,
          requestOptions: RequestOptions(
            path: ApiRoutes.reservationById(testReservationId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.reservationById(testReservationId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await reservationsApi.getReservationById(
          testReservationId,
        );
        expect(result, isNull);
      });

      test('should return null when Dio throws', () async {
        when(
          () => mockDio.get(ApiRoutes.reservationById(testReservationId)),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.reservationById(testReservationId),
            ),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await reservationsApi.getReservationById(
          testReservationId,
        );

        expect(result, isNull);
      });
    });

    group('getVenueReservations', () {
      test('should return list of ReservationDetails on success', () async {
        final mockResponse = Response(
          data: [
            {
              'id': 1,
              'userId': testUserId,
              'venueId': testVenueId,
              'numberOfGuests': testNumberOfGuests,
              'datetime': testDate.toIso8601String(),
            },
            {
              'id': 2,
              'userId': testUserId,
              'venueId': testVenueId,
              'numberOfGuests': testNumberOfGuests,
              'datetime': testDate
                  .add(const Duration(days: 1))
                  .toIso8601String(),
            },
          ],
          requestOptions: RequestOptions(
            path: ApiRoutes.venueReservations(testVenueId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.venueReservations(testVenueId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await reservationsApi.getVenueReservations(testVenueId);

        expect(result, isA<List<ReservationDetails>>());
        expect(result.length, 2);
        expect(result[0].venueId, testVenueId);
        expect(result[0].userId, testUserId);
        expect(result[0].numberOfGuests, testNumberOfGuests);
        expect(result[0].datetime, testDate);

        expect(result[1].venueId, testVenueId);
        expect(result[1].userId, testUserId);
        expect(result[1].numberOfGuests, testNumberOfGuests);
        expect(result[1].datetime, testDate.add(const Duration(days: 1)));
      });

      test('should return empty list when API returns empty array', () async {
        final mockResponse = Response(
          data: [],
          requestOptions: RequestOptions(
            path: ApiRoutes.venueReservations(testVenueId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.venueReservations(testVenueId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await reservationsApi.getVenueReservations(testVenueId);

        expect(result, isA<List<ReservationDetails>>());
        expect(result, isEmpty);
      });

      test('should return empty list when Dio throws', () async {
        when(
          () => mockDio.get(ApiRoutes.venueReservations(testVenueId)),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.venueReservations(testVenueId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await reservationsApi.getVenueReservations(testVenueId);

        expect(result, isA<List<ReservationDetails>>());
        expect(result, isEmpty);
      });
    });

    group('getReservationCount', () {
      test('should return correct int', () async {
        final mockResponse = Response(
          data: testReservationsCount,
          requestOptions: RequestOptions(
            path: ApiRoutes.reservationCount(testOwnerId),
          ),
        );

        when(
          () => mockDio.get(
            ApiRoutes.reservationCount(testOwnerId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await reservationsApi.getReservationCount(testOwnerId);

        expect(result, testReservationsCount);
      });

      test('should send correct data', () async {
        late Map<String, dynamic> capturedParams;

        final mockResponse = Response(
          data: testReservationsCount,
          requestOptions: RequestOptions(
            path: ApiRoutes.reservationCount(testOwnerId),
          ),
        );
        when(
          () => mockDio.get(
            ApiRoutes.reservationCount(testOwnerId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          capturedParams =
              invocation.namedArguments[const Symbol('queryParameters')]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        await reservationsApi.getReservationCount(
          testOwnerId,
          venueId: testVenueId,
          startDate: testDate,
          endDate: testDate.add(const Duration(days: 1)),
        );

        expect(capturedParams['venueId'], testVenueId);
        expect(capturedParams['startDate'], testDate.toIso8601String());
        expect(
          capturedParams['endDate'],
          testDate.add(const Duration(days: 1)).toIso8601String(),
        );
      });

      test('should return 0 when Dio throws', () async {
        when(
          () => mockDio.get(
            ApiRoutes.reservationCount(testOwnerId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.reservationCount(testOwnerId),
            ),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await reservationsApi.getReservationCount(testOwnerId);

        expect(result, 0);
      });
    });

    group('createReservation', () {
      test(
        'should send correct data and return BasicResponse on success',
        () async {
          final mockResponse = Response(
            data: {'success': true, 'message': 'Created', 'data': null},
            requestOptions: RequestOptions(path: ApiRoutes.reservations),
          );

          late Map<String, dynamic> capturedData;

          when(
            () =>
                mockDio.post(ApiRoutes.reservations, data: any(named: 'data')),
          ).thenAnswer((invocation) async {
            capturedData =
                invocation.namedArguments[const Symbol('data')]
                    as Map<String, dynamic>;
            return mockResponse;
          });

          final result = await reservationsApi.createReservation(
            venueId: testVenueId,
            numberOfGuests: testNumberOfGuests,
            reservationDate: testDate,
            userId: testUserId,
            userEmail: 'test@example.com',
          );

          expect(result.success, true);
          expect(result.message, 'Created');

          expect(capturedData['userId'], testUserId);
          expect(capturedData['userEmail'], 'test@example.com');
          expect(capturedData['venueId'], testVenueId);
          expect(capturedData['numberOfGuests'], testNumberOfGuests);
          expect(DateTime.parse(capturedData['reservationDate']), testDate);
        },
      );

      test('should return BasicResponse on failure', () async {
        final mockResponse = Response(
          data: {
            'success': false,
            'message': 'Error during reservation creation',
            'data': null,
          },
          requestOptions: RequestOptions(path: ApiRoutes.reservations),
        );

        when(
          () => mockDio.post(ApiRoutes.reservations, data: any(named: 'data')),
        ).thenAnswer((invocation) async {
          return mockResponse;
        });

        final result = await reservationsApi.createReservation(
          venueId: testVenueId,
          numberOfGuests: testNumberOfGuests,
          reservationDate: testDate,
          userId: testUserId,
          userEmail: 'test@example.com',
        );

        expect(result.success, false);
        expect(result.message, 'Error during reservation creation');
      });

      test('should return BasicResponse with false when Dio throws', () async {
        when(
          () => mockDio.post(ApiRoutes.reservations, data: any(named: 'data')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiRoutes.reservations),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await reservationsApi.createReservation(
          venueId: testVenueId,
          numberOfGuests: testNumberOfGuests,
          reservationDate: testDate,
          userId: testUserId,
          userEmail: 'test@example.com',
        );

        expect(result.success, false);
        expect(result.message, 'Failed to create reservation');
      });
    });

    group('updateReservation', () {
      test(
        'should send correct data and return BasicResponse on success',
        () async {
          const updatedNumberOfGuests = 2;
          final mockResponse = Response(
            data: {'success': true, 'message': 'Updated', 'data': null},
            requestOptions: RequestOptions(
              path: ApiRoutes.reservationById(testReservationId),
            ),
          );

          late Map<String, dynamic> capturedData;

          when(
            () => mockDio.patch(
              ApiRoutes.reservationById(testReservationId),
              data: any(named: 'data'),
            ),
          ).thenAnswer((invocation) async {
            capturedData =
                invocation.namedArguments[const Symbol('data')]
                    as Map<String, dynamic>;
            return mockResponse;
          });

          final result = await reservationsApi.updateReservation(
            reservationId: testReservationId,
            numberOfGuests: updatedNumberOfGuests,
            reservationDate: testDate,
          );

          expect(result.success, true);
          expect(result.message, 'Updated');

          expect(capturedData['numberOfGuests'], updatedNumberOfGuests);
          expect(DateTime.parse(capturedData['reservationDate']), testDate);
        },
      );

      test('Should return BasicResponse on failure', () async {
        const updatedNumberOfGuests = 2;
        final mockResponse = Response(
          data: {
            'success': false,
            'message': 'Error during update',
            'data': null,
          },
          requestOptions: RequestOptions(
            path: ApiRoutes.reservationById(testReservationId),
          ),
        );

        when(
          () => mockDio.patch(
            ApiRoutes.reservationById(testReservationId),
            data: any(named: 'data'),
          ),
        ).thenAnswer((invocation) async {
          return mockResponse;
        });

        final result = await reservationsApi.updateReservation(
          reservationId: testReservationId,
          numberOfGuests: updatedNumberOfGuests,
          reservationDate: testDate,
        );

        expect(result.success, false);
        expect(result.message, 'Error during update');
      });

      test('should return BasicResponse with false when Dio throws', () async {
        when(
          () => mockDio.patch(
            ApiRoutes.reservationById(testReservationId),
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.reservationById(testReservationId),
            ),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await reservationsApi.updateReservation(
          reservationId: testReservationId,
          numberOfGuests: 2,
          reservationDate: testDate,
        );

        expect(result.success, false);
        expect(result.message, 'Failed to update reservation');
      });
    });

    group('deleteReservation', () {
      test('should return BasicResponse on success', () async {
        final mockResponse = Response(
          data: {'success': true, 'message': 'Deleted', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.reservationById(testReservationId),
          ),
        );

        when(
          () => mockDio.delete(ApiRoutes.reservationById(testReservationId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await reservationsApi.deleteReservation(
          testReservationId,
        );

        expect(result.success, true);
        expect(result.message, 'Deleted');
      });

      test('Should return BasicResponse on failure', () async {
        final mockResponse = Response(
          data: {
            'success': false,
            'message': 'Error during deletion',
            'data': null,
          },
          requestOptions: RequestOptions(
            path: ApiRoutes.reservationById(testReservationId),
          ),
        );

        when(
          () => mockDio.delete(ApiRoutes.reservationById(testReservationId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await reservationsApi.deleteReservation(
          testReservationId,
        );

        expect(result.success, false);
        expect(result.message, 'Error during deletion');
      });

      test('should return BasicResponse with false when Dio throws', () async {
        when(
          () => mockDio.delete(ApiRoutes.reservationById(testReservationId)),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.reservationById(testReservationId),
            ),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await reservationsApi.deleteReservation(
          testReservationId,
        );

        expect(result.success, false);
        expect(result.message, contains('Failed to delete reservation'));
      });
    });
  });

  group('Support Api', () {
    const testSubject = 'Hello';
    const testMessage = 'This is a test';

    test('should return BasicResponse on success', () async {
      final mockResponse = Response(
        data: {'success': true, 'message': 'Email sent', 'data': null},
        requestOptions: RequestOptions(path: ApiRoutes.sendEmail),
      );

      when(
        () => mockDio.post(
          ApiRoutes.sendEmail,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      final result = await supportApi.sendEmail(
        testUserEmail,
        testSubject,
        testMessage,
      );

      expect(result, isA<BasicResponse>());
      expect(result.success, true);
      expect(result.message, 'Email sent');
    });

    test('should return BasicResponse with false when Dio throws', () async {
      when(
        () => mockDio.post(
          ApiRoutes.sendEmail,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiRoutes.sendEmail),
          type: DioExceptionType.connectionError,
          error: 'Network error',
        ),
      );

      final result = await supportApi.sendEmail(
        testUserEmail,
        testSubject,
        testMessage,
      );

      expect(result, isA<BasicResponse>());
      expect(result.success, false);
      expect(result.message, contains('Error sending email'));
    });

    test('should send correct query parameters', () async {
      late Map<String, dynamic> capturedParams;

      final mockResponse = Response(
        data: {'success': true, 'message': 'Email sent', 'data': null},
        requestOptions: RequestOptions(path: ApiRoutes.sendEmail),
      );

      when(
        () => mockDio.post(
          ApiRoutes.sendEmail,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((invocation) async {
        capturedParams =
            invocation.namedArguments[const Symbol('queryParameters')]
                as Map<String, dynamic>;
        return mockResponse;
      });

      await supportApi.sendEmail(testUserEmail, testSubject, testMessage);

      expect(capturedParams['userEmail'], testUserEmail);
      expect(capturedParams['subject'], testSubject);
      expect(capturedParams['body'], testMessage);
    });
  });

  group('Venue Api', () {
    const testVenueName = 'Test Venue';
    const testVenueLocation = 'Poreč';
    const testVenueMaximumCapacity = 20;
    const testVenueAvailableCapacity = 15;
    const testVenueTypeId = 1;
    const testVenueRating = 4.5;
    const testVenueWorkingDays = [0, 1, 2, 3, 4];
    const testVenueWorkingHours = '09:00 - 17:00';
    const testVenueDescription = 'A nice place to be';

    group('getVenue', () {
      test('should return venue when success', () async {
        final mockResponse = Response(
          data: {
            'id': testVenueId,
            'name': testVenueName,
            'location': testVenueLocation,
            'workingDays': testVenueWorkingDays,
            'workingHours': testVenueWorkingHours,
            'maximumCapacity': testVenueMaximumCapacity,
            'availableCapacity': testVenueAvailableCapacity,
            'averageRating': testVenueRating,
            'venueTypeId': testVenueTypeId,
            'description': testVenueDescription,
          },
          requestOptions: RequestOptions(
            path: ApiRoutes.venueById(testVenueId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.venueById(testVenueId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getVenue(testVenueId);

        expect(result, isA<Venue>());
        expect(result!.id, testVenueId);
        expect(result.name, testVenueName);
        expect(result.location, testVenueLocation);
        expect(result.workingDays, testVenueWorkingDays);
        expect(result.workingHours, testVenueWorkingHours);
        expect(result.maximumCapacity, testVenueMaximumCapacity);
        expect(result.availableCapacity, testVenueAvailableCapacity);
        expect(result.rating, testVenueRating);
        expect(result.typeId, testVenueTypeId);
        expect(result.description, testVenueDescription);
      });

      test('should return null when Dio throws', () async {
        when(() => mockDio.get(ApiRoutes.venueById(testVenueId))).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.venueById(testVenueId),
            ),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await venuesApi.getVenue(testVenueId);

        expect(result, isNull);
      });
    });

    group('getAllVenues', () {
      const testPage = 0;
      const testSize = 10;
      const testSearchQuery = 'Test';
      const testTypeIds = [1, 2];

      test('should return PagedResponse when success', () async {
        final mockResponse = Response(
          data: {
            'content': [
              {
                'id': testVenueId,
                'name': testVenueName,
                'location': testVenueLocation,
                'workingDays': testVenueWorkingDays,
                'workingHours': testVenueWorkingHours,
                'maximumCapacity': testVenueMaximumCapacity,
                'availableCapacity': testVenueAvailableCapacity,
                'averageRating': testVenueRating,
                'venueTypeId': testVenueTypeId,
                'description': testVenueDescription,
              },
            ],
            'page': testPage,
            'size': testSize,
            'totalElements': 1,
            'totalPages': 1,
          },
          requestOptions: RequestOptions(path: ApiRoutes.venues),
        );

        when(
          () => mockDio.get(
            ApiRoutes.venues,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getAllVenues(
          testPage,
          testSize,
          testSearchQuery,
          testTypeIds,
        );

        expect(result, isA<PagedResponse<Venue>>());
        expect(result.content.first.name, testVenueName);
        expect(result.page, testPage);
        expect(result.size, testSize);
        expect(result.totalElements, 1);
        expect(result.totalPages, 1);
      });

      test('should return empty PagedResponse when Dio throws', () async {
        when(
          () => mockDio.get(
            ApiRoutes.venues,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiRoutes.venues),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await venuesApi.getAllVenues(
          testPage,
          testSize,
          testSearchQuery,
          testTypeIds,
        );

        expect(result.content, isEmpty);
        expect(result.page, 0);
        expect(result.size, 0);
        expect(result.totalElements, 0);
        expect(result.totalPages, 0);
      });

      test('should send correct query parameters', () async {
        late Map<String, dynamic> capturedParams;

        final mockResponse = Response(
          data: {
            'content': [],
            'page': testPage,
            'size': testSize,
            'totalElements': 0,
            'totalPages': 0,
          },
          requestOptions: RequestOptions(path: ApiRoutes.venues),
        );

        when(
          () => mockDio.get(
            ApiRoutes.venues,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          capturedParams =
              invocation.namedArguments[#queryParameters]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        await venuesApi.getAllVenues(
          testPage,
          testSize,
          testSearchQuery,
          testTypeIds,
        );

        expect(capturedParams['page'], testPage);
        expect(capturedParams['size'], testSize);
        expect(capturedParams['searchQuery'], testSearchQuery);
        expect(capturedParams['typeIds'], testTypeIds);
      });
    });

    group('getVenuesByOwner', () {
      const testPage = 0;
      const testSize = 20;

      test('should return PagedResponse when success', () async {
        final mockResponse = Response(
          data: {
            'content': [
              {
                'id': testVenueId,
                'name': testVenueName,
                'location': testVenueLocation,
                'workingDays': testVenueWorkingDays,
                'workingHours': testVenueWorkingHours,
                'maximumCapacity': testVenueMaximumCapacity,
                'availableCapacity': testVenueAvailableCapacity,
                'averageRating': testVenueRating,
                'venueTypeId': testVenueTypeId,
                'description': testVenueDescription,
              },
            ],
            'page': testPage,
            'size': testSize,
            'totalElements': 1,
            'totalPages': 1,
          },
          requestOptions: RequestOptions(
            path: ApiRoutes.venuesByOwnerId(testOwnerId),
          ),
        );

        when(
          () => mockDio.get(
            ApiRoutes.venuesByOwnerId(testOwnerId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getVenuesByOwner(
          testOwnerId,
          page: testPage,
          size: testSize,
        );

        expect(result, isA<PagedResponse<Venue>>());
        expect(result.content.first.id, testVenueId);
        expect(result.content.first.name, testVenueName);
        expect(result.content.first.location, testVenueLocation);
        expect(result.content.first.maximumCapacity, testVenueMaximumCapacity);
        expect(
          result.content.first.availableCapacity,
          testVenueAvailableCapacity,
        );
        expect(result.content.first.rating, testVenueRating);
        expect(result.page, testPage);
        expect(result.size, testSize);
        expect(result.totalElements, 1);
        expect(result.totalPages, 1);
      });

      test('should return empty PagedResponse when Dio throws', () async {
        when(
          () => mockDio.get(
            ApiRoutes.venuesByOwnerId(testOwnerId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.venuesByOwnerId(testOwnerId),
            ),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await venuesApi.getVenuesByOwner(
          testOwnerId,
          page: testPage,
          size: testSize,
        );

        expect(result.content, isEmpty);
        expect(result.page, 0);
        expect(result.size, 0);
        expect(result.totalElements, 0);
        expect(result.totalPages, 0);
      });

      test('should send correct query parameters', () async {
        late Map<String, dynamic> capturedParams;

        final mockResponse = Response(
          data: {
            'content': [],
            'page': testPage,
            'size': testSize,
            'totalElements': 0,
            'totalPages': 0,
          },
          requestOptions: RequestOptions(
            path: ApiRoutes.venuesByOwnerId(testOwnerId),
          ),
        );

        when(
          () => mockDio.get(
            ApiRoutes.venuesByOwnerId(testOwnerId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          capturedParams =
              invocation.namedArguments[#queryParameters]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        await venuesApi.getVenuesByOwner(
          testOwnerId,
          page: testPage,
          size: testSize,
        );

        expect(capturedParams['page'], testPage);
        expect(capturedParams['size'], testSize);
      });
    });

    group('getVenueCountByOwner', () {
      test('should return correct int when success', () async {
        const venueCount = 2;

        final mockResponse = Response(
          data: venueCount,
          requestOptions: RequestOptions(
            path: ApiRoutes.venuesCountByOwnerId(testOwnerId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.venuesCountByOwnerId(testOwnerId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getVenueCountByOwner(testOwnerId);

        expect(result, venueCount);
      });

      test('should return 0 when Dio throws', () async {
        when(
          () => mockDio.get(ApiRoutes.venuesCountByOwnerId(testOwnerId)),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.venuesCountByOwnerId(testOwnerId),
            ),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await venuesApi.getVenueCountByOwner(testOwnerId);

        expect(result, 0);
      });
    });

    group('getNearbyVenues', () {
      const testPage = 0;
      const testSize = 10;

      test('should return PagedResponse when success', () async {
        final mockResponse = Response(
          data: {
            'content': [
              {
                'id': testVenueId,
                'name': testVenueName,
                'location': testVenueLocation,
                'workingDays': testVenueWorkingDays,
                'workingHours': testVenueWorkingHours,
                'maximumCapacity': testVenueMaximumCapacity,
                'availableCapacity': testVenueAvailableCapacity,
                'averageRating': testVenueRating,
                'venueTypeId': testVenueTypeId,
                'description': testVenueDescription,
              },
            ],
            'page': 0,
            'size': 10,
            'totalElements': 1,
            'totalPages': 1,
          },
          requestOptions: RequestOptions(path: ApiRoutes.venues),
        );

        when(
          () => mockDio.get(
            ApiRoutes.venues,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getNearbyVenues(latitude, longitude);

        expect(result, isA<PagedResponse<Venue>>());
        expect(result.content.first.name, testVenueName);
        expect(result.content.first.location, testVenueLocation);
        expect(result.content.first.maximumCapacity, testVenueMaximumCapacity);
        expect(
          result.content.first.availableCapacity,
          testVenueAvailableCapacity,
        );
        expect(result.content.first.typeId, testVenueTypeId);
        expect(result.content.first.rating, testVenueRating);
        expect(result.content.first.workingDays, testVenueWorkingDays);
        expect(result.content.first.workingHours, testVenueWorkingHours);
        expect(result.content.first.description, testVenueDescription);
        expect(result.page, 0);
        expect(result.size, 10);
        expect(result.totalPages, 1);
        expect(result.totalElements, 1);
      });

      test('should return empty PagedResponse when Dio throws', () async {
        when(
          () => mockDio.get(
            ApiRoutes.venues,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiRoutes.venues),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await venuesApi.getNearbyVenues(
          latitude,
          longitude,
          page: testPage,
          size: testSize,
        );

        expect(result.content, isEmpty);
        expect(result.totalElements, 0);
        expect(result.totalPages, 0);
        expect(result.page, 0);
        expect(result.size, 0);
      });

      test('should send correct query parameters', () async {
        late Map<String, dynamic> capturedParams;

        final mockResponse = Response(
          data: {
            'content': [],
            'page': testPage,
            'size': testSize,
            'totalElements': 0,
            'totalPages': 0,
          },
          requestOptions: RequestOptions(path: ApiRoutes.venues),
        );

        when(
          () => mockDio.get(
            ApiRoutes.venues,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          capturedParams =
              invocation.namedArguments[#queryParameters]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        await venuesApi.getNearbyVenues(
          latitude,
          longitude,
          page: testPage,
          size: testSize,
        );

        expect(capturedParams['category'], 'nearby');
        expect(capturedParams['latitude'], latitude);
        expect(capturedParams['longitude'], longitude);
        expect(capturedParams['page'], testPage);
        expect(capturedParams['size'], testSize);
      });
    });

    group('getTrendingVenues', () {
      const testPage = 0;
      const testSize = 10;

      test('should return PagedResponse when success', () async {
        final mockResponse = Response(
          data: {
            'content': [
              {
                'id': testVenueId,
                'name': testVenueName,
                'location': testVenueLocation,
                'workingDays': testVenueWorkingDays,
                'workingHours': testVenueWorkingHours,
                'maximumCapacity': testVenueMaximumCapacity,
                'availableCapacity': testVenueAvailableCapacity,
                'averageRating': testVenueRating,
                'venueTypeId': testVenueTypeId,
                'description': testVenueDescription,
              },
            ],
            'page': 0,
            'size': 10,
            'totalElements': 1,
            'totalPages': 1,
          },
          requestOptions: RequestOptions(path: ApiRoutes.venues),
        );

        when(
          () => mockDio.get(
            ApiRoutes.venues,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getTrendingVenues();

        expect(result, isA<PagedResponse<Venue>>());
        expect(result.content.first.name, testVenueName);
        expect(result.content.first.location, testVenueLocation);
        expect(result.content.first.maximumCapacity, testVenueMaximumCapacity);
        expect(
          result.content.first.availableCapacity,
          testVenueAvailableCapacity,
        );
        expect(result.content.first.typeId, testVenueTypeId);
        expect(result.content.first.rating, testVenueRating);
        expect(result.content.first.workingDays, testVenueWorkingDays);
        expect(result.content.first.workingHours, testVenueWorkingHours);
        expect(result.content.first.description, testVenueDescription);
        expect(result.page, 0);
        expect(result.size, 10);
        expect(result.totalPages, 1);
        expect(result.totalElements, 1);
      });

      test('should return empty PagedResponse when Dio throws', () async {
        when(
          () => mockDio.get(
            ApiRoutes.venues,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiRoutes.venues),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await venuesApi.getTrendingVenues();

        expect(result.content, isEmpty);
        expect(result.totalElements, 0);
        expect(result.totalPages, 0);
        expect(result.page, 0);
        expect(result.size, 0);
      });

      test('should send correct query parameters', () async {
        late Map<String, dynamic> capturedParams;

        final mockResponse = Response(
          data: {
            'content': [],
            'page': testPage,
            'size': testSize,
            'totalElements': 0,
            'totalPages': 0,
          },
          requestOptions: RequestOptions(path: ApiRoutes.venues),
        );

        when(
          () => mockDio.get(
            ApiRoutes.venues,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          capturedParams =
              invocation.namedArguments[#queryParameters]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        await venuesApi.getTrendingVenues(page: testPage, size: testSize);

        expect(capturedParams['category'], 'trending');
        expect(capturedParams['page'], testPage);
        expect(capturedParams['size'], testSize);
      });
    });

    group('getNewVenues', () {
      const testPage = 0;
      const testSize = 10;

      test('should return PagedResponse when success', () async {
        final mockResponse = Response(
          data: {
            'content': [
              {
                'id': testVenueId,
                'name': testVenueName,
                'location': testVenueLocation,
                'workingDays': testVenueWorkingDays,
                'workingHours': testVenueWorkingHours,
                'maximumCapacity': testVenueMaximumCapacity,
                'availableCapacity': testVenueAvailableCapacity,
                'averageRating': testVenueRating,
                'venueTypeId': testVenueTypeId,
                'description': testVenueDescription,
              },
            ],
            'page': 0,
            'size': 10,
            'totalElements': 1,
            'totalPages': 1,
          },
          requestOptions: RequestOptions(path: ApiRoutes.venues),
        );

        when(
          () => mockDio.get(
            ApiRoutes.venues,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getNewVenues();

        expect(result, isA<PagedResponse<Venue>>());
        expect(result.content.first.name, testVenueName);
        expect(result.content.first.location, testVenueLocation);
        expect(result.content.first.maximumCapacity, testVenueMaximumCapacity);
        expect(
          result.content.first.availableCapacity,
          testVenueAvailableCapacity,
        );
        expect(result.content.first.typeId, testVenueTypeId);
        expect(result.content.first.rating, testVenueRating);
        expect(result.content.first.workingDays, testVenueWorkingDays);
        expect(result.content.first.workingHours, testVenueWorkingHours);
        expect(result.content.first.description, testVenueDescription);
        expect(result.page, 0);
        expect(result.size, 10);
        expect(result.totalPages, 1);
        expect(result.totalElements, 1);
      });

      test('should return empty PagedResponse when Dio throws', () async {
        when(
          () => mockDio.get(
            ApiRoutes.venues,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiRoutes.venues),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await venuesApi.getNewVenues();

        expect(result.content, isEmpty);
        expect(result.totalElements, 0);
        expect(result.totalPages, 0);
        expect(result.page, 0);
        expect(result.size, 0);
      });

      test('should send correct query parameters', () async {
        late Map<String, dynamic> capturedParams;

        final mockResponse = Response(
          data: {
            'content': [],
            'page': testPage,
            'size': testSize,
            'totalElements': 0,
            'totalPages': 0,
          },
          requestOptions: RequestOptions(path: ApiRoutes.venues),
        );

        when(
          () => mockDio.get(
            ApiRoutes.venues,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          capturedParams =
              invocation.namedArguments[#queryParameters]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        await venuesApi.getNewVenues(page: testPage, size: testSize);

        expect(capturedParams['category'], 'new');
        expect(capturedParams['page'], testPage);
        expect(capturedParams['size'], testSize);
      });
    });

    group('getSuggestedVenues', () {
      const testPage = 0;
      const testSize = 10;

      test('should return PagedResponse when success', () async {
        final mockResponse = Response(
          data: {
            'content': [
              {
                'id': testVenueId,
                'name': testVenueName,
                'location': testVenueLocation,
                'workingDays': testVenueWorkingDays,
                'workingHours': testVenueWorkingHours,
                'maximumCapacity': testVenueMaximumCapacity,
                'availableCapacity': testVenueAvailableCapacity,
                'averageRating': testVenueRating,
                'venueTypeId': testVenueTypeId,
                'description': testVenueDescription,
              },
            ],
            'page': 0,
            'size': 10,
            'totalElements': 1,
            'totalPages': 1,
          },
          requestOptions: RequestOptions(path: ApiRoutes.venues),
        );

        when(
          () => mockDio.get(
            ApiRoutes.venues,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getSuggestedVenues();

        expect(result, isA<PagedResponse<Venue>>());
        expect(result.content.first.name, testVenueName);
        expect(result.content.first.location, testVenueLocation);
        expect(result.content.first.maximumCapacity, testVenueMaximumCapacity);
        expect(
          result.content.first.availableCapacity,
          testVenueAvailableCapacity,
        );
        expect(result.content.first.typeId, testVenueTypeId);
        expect(result.content.first.rating, testVenueRating);
        expect(result.content.first.workingDays, testVenueWorkingDays);
        expect(result.content.first.workingHours, testVenueWorkingHours);
        expect(result.content.first.description, testVenueDescription);
        expect(result.page, 0);
        expect(result.size, 10);
        expect(result.totalPages, 1);
        expect(result.totalElements, 1);
      });

      test('should return empty PagedResponse when Dio throws', () async {
        when(
          () => mockDio.get(
            ApiRoutes.venues,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiRoutes.venues),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await venuesApi.getSuggestedVenues();

        expect(result.content, isEmpty);
        expect(result.totalElements, 0);
        expect(result.totalPages, 0);
        expect(result.page, 0);
        expect(result.size, 0);
      });

      test('should send correct query parameters', () async {
        late Map<String, dynamic> capturedParams;

        final mockResponse = Response(
          data: {
            'content': [],
            'page': testPage,
            'size': testSize,
            'totalElements': 0,
            'totalPages': 0,
          },
          requestOptions: RequestOptions(path: ApiRoutes.venues),
        );

        when(
          () => mockDio.get(
            ApiRoutes.venues,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          capturedParams =
              invocation.namedArguments[#queryParameters]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        await venuesApi.getSuggestedVenues(page: testPage, size: testSize);

        expect(capturedParams['category'], 'suggested');
        expect(capturedParams['page'], testPage);
        expect(capturedParams['size'], testSize);
      });
    });

    group('getVenueType', () {
      test('should return venue type when success', () async {
        const venueType = 'Restaurant';

        final mockResponse = Response(
          data: venueType,
          requestOptions: RequestOptions(path: ApiRoutes.venueType(1)),
        );

        when(
          () => mockDio.get(ApiRoutes.venueType(1)),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getVenueType(1);

        expect(result, venueType);
      });

      test('should return null when Dio throws', () async {
        when(() => mockDio.get(ApiRoutes.venueType(1))).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiRoutes.venueType(1)),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await venuesApi.getVenueType(1);

        expect(result, isNull);
      });
    });

    group('getAllVenueTypes', () {
      test('should return list of venue types when success', () async {
        final mockResponse = Response(
          data: [
            {'id': 1, 'type': 'Restaurant'},
            {'id': 2, 'type': 'Cafe'},
          ],
          requestOptions: RequestOptions(path: ApiRoutes.allVenueTypes),
        );

        when(
          () => mockDio.get(ApiRoutes.allVenueTypes),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getAllVenueTypes();

        expect(result, isA<List<VenueType>>());
        expect(result.length, 2);
        expect(result[0].type, 'Restaurant');
        expect(result[1].type, 'Cafe');
      });

      test('should return empty list when Dio throws', () async {
        when(() => mockDio.get(ApiRoutes.allVenueTypes)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiRoutes.allVenueTypes),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await venuesApi.getAllVenueTypes();

        expect(result, isEmpty);
      });
    });

    group('getVenueRating', () {
      test('should return venue rating as double when success', () async {
        const venueRating = 4.5;

        final mockResponse = Response(
          data: venueRating,
          requestOptions: RequestOptions(
            path: ApiRoutes.venueAverageRating(testVenueId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.venueAverageRating(testVenueId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getVenueRating(testVenueId);

        expect(result, venueRating);
      });

      test('should return null when Dio throws', () async {
        when(
          () => mockDio.get(ApiRoutes.venueAverageRating(testVenueId)),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.venueAverageRating(testVenueId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await venuesApi.getVenueRating(testVenueId);

        expect(result, isNull);
      });
    });

    group('getAllVenueRatings', () {
      const userRating = 4.5;
      const secondUserRating = 3.8;

      test('should return list of Rating when success', () async {
        final mockResponse = Response(
          data: [
            {
              'id': 1,
              'rating': userRating,
              'username': testUsername,
              'comment': 'Great!',
            },
            {
              'id': 2,
              'rating': secondUserRating,
              'username': testSecondUsername,
              'comment': 'Good service',
            },
          ],
          requestOptions: RequestOptions(
            path: ApiRoutes.allVenueRatings(testVenueId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.allVenueRatings(testVenueId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getAllVenueRatings(testVenueId);

        expect(result, isA<List<Rating>>());
        expect(result.length, 2);
        expect(result[0].username, testUsername);
        expect(result[0].rating, userRating);
        expect(result[0].comment, 'Great!');

        expect(result[1].username, testSecondUsername);
        expect(result[1].rating, secondUserRating);
        expect(result[1].comment, 'Good service');
      });

      test('should return empty list when Dio throws', () async {
        when(
          () => mockDio.get(ApiRoutes.allVenueRatings(testVenueId)),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.allVenueRatings(testVenueId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await venuesApi.getAllVenueRatings(testVenueId);

        expect(result, isEmpty);
      });
    });

    group('getVenueRatingsCount', () {
      test('should return correct int when success', () async {
        const ratingsCount = 2;

        final mockResponse = Response(
          data: ratingsCount,
          requestOptions: RequestOptions(
            path: ApiRoutes.venueRatingsCount(testOwnerId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.venueRatingsCount(testOwnerId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getVenueRatingsCount(testOwnerId);

        expect(result, ratingsCount);
      });

      test('should return 0 when Dio throws', () async {
        when(
          () => mockDio.get(ApiRoutes.venueRatingsCount(testOwnerId)),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.venueRatingsCount(testOwnerId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await venuesApi.getVenueRatingsCount(testOwnerId);

        expect(result, 0);
      });
    });

    group('getOverallRating', () {
      test('should return correct double when success', () async {
        const overallRating = 4.7;

        final mockResponse = Response(
          data: overallRating,
          requestOptions: RequestOptions(
            path: ApiRoutes.overallRating(testOwnerId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.overallRating(testOwnerId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getOverallRating(testOwnerId);

        expect(result, overallRating);
      });

      test('should return 0.0 when Dio throws', () async {
        when(() => mockDio.get(ApiRoutes.overallRating(testOwnerId))).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.overallRating(testOwnerId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await venuesApi.getOverallRating(testOwnerId);

        expect(result, 0.0);
      });
    });

    group('getVenueUtilisationRate', () {
      test('should return correct double when success', () async {
        const utilisationRate = 0.75;

        final mockResponse = Response(
          data: utilisationRate,
          requestOptions: RequestOptions(
            path: ApiRoutes.venueUtilisationRate(testOwnerId),
          ),
        );

        when(
          () => mockDio.get(
            ApiRoutes.venueUtilisationRate(testOwnerId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getVenueUtilisationRate(testOwnerId);

        expect(result, utilisationRate);
      });

      test('should return 0.0 when Dio throws', () async {
        when(
          () => mockDio.get(
            ApiRoutes.venueUtilisationRate(testOwnerId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.venueUtilisationRate(testOwnerId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await venuesApi.getVenueUtilisationRate(testOwnerId);

        expect(result, 0.0);
      });
    });

    group('rateVenue', () {
      const testRating = 4.0;
      test('should return BasicResponse on success', () async {
        final mockResponse = Response(
          data: {'success': true, 'message': 'Rated', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.rateVenue(testVenueId),
          ),
        );
        when(
          () => mockDio.post(
            ApiRoutes.rateVenue(testVenueId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.rateVenue(
          testVenueId,
          testRating,
          testUserId,
          'Great place!',
        );

        expect(result, isA<BasicResponse>());
        expect(result.success, true);
        expect(result.message, 'Rated');
      });

      test('should return BasicResponse with false when Dio throws', () async {
        when(
          () => mockDio.post(
            ApiRoutes.rateVenue(testVenueId),
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.rateVenue(testVenueId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await venuesApi.rateVenue(
          testVenueId,
          testRating,
          testUserId,
          'Great place!',
        );

        expect(result.success, false);
        expect(result.message, contains('Error rating venue'));
      });

      test('should send correct query parameters', () async {
        final mockResponse = Response(
          data: {'success': true, 'message': 'Rated', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.rateVenue(testVenueId),
          ),
        );

        late Map<String, dynamic> capturedParams;

        when(
          () => mockDio.post(
            ApiRoutes.rateVenue(testVenueId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          capturedParams =
              invocation.namedArguments[#queryParameters]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        await venuesApi.rateVenue(
          testVenueId,
          testRating,
          testUserId,
          'Great place!',
        );

        expect(capturedParams['userId'], testUserId);
        expect(capturedParams['rating'], testRating);
        expect(capturedParams['comment'], 'Great place!');
      });
    });

    group('uploadVenueImage', () {
      const filename = 'test.png';
      final imageBytes = utf8.encode('fake_image_bytes');

      test('should return BasicResponse on success', () async {
        final mockResponse = Response(
          data: {'success': true, 'message': 'Uploaded', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.venueImages(testVenueId),
          ),
        );

        when(
          () => mockDio.post(
            ApiRoutes.venueImages(testVenueId),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.uploadVenueImage(
          testVenueId,
          imageBytes,
          filename,
        );

        expect(result, isA<BasicResponse>());
        expect(result.success, true);
        expect(result.message, 'Uploaded');
      });

      test('should return BasicResponse with false when Dio throws', () async {
        when(
          () => mockDio.post(
            ApiRoutes.venueImages(testVenueId),
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.venueImages(testVenueId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await venuesApi.uploadVenueImage(
          testVenueId,
          imageBytes,
          filename,
        );

        expect(result.success, false);
        expect(result.message, 'Error uploading venue image');
      });

      test('should send correct form data', () async {
        final mockResponse = Response(
          data: {'success': true, 'message': 'Uploaded', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.venueImages(testVenueId),
          ),
        );

        late FormData capturedFormData;

        when(
          () => mockDio.post(
            ApiRoutes.venueImages(testVenueId),
            data: any(named: 'data'),
          ),
        ).thenAnswer((invocation) async {
          capturedFormData = invocation.namedArguments[#data] as FormData;
          return mockResponse;
        });

        await venuesApi.uploadVenueImage(testVenueId, imageBytes, filename);

        final file = capturedFormData.files.first.value;
        expect(capturedFormData.files.first.key, 'image');
        expect(file.filename, filename);
        expect(file.contentType?.mimeType, 'image/png');
      });
    });

    group('uploadMenuImage', () {
      const filename = 'test.png';
      final imageBytes = utf8.encode('fake_image_bytes');

      test('should return BasicResponse on success', () async {
        final mockResponse = Response(
          data: {'success': true, 'message': 'Uploaded', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.menuImages(testVenueId),
          ),
        );

        when(
          () => mockDio.post(
            ApiRoutes.menuImages(testVenueId),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.uploadMenuImage(
          testVenueId,
          imageBytes,
          filename,
        );

        expect(result, isA<BasicResponse>());
        expect(result.success, true);
        expect(result.message, 'Uploaded');
      });

      test('should return BasicResponse with false when Dio throws', () async {
        when(
          () => mockDio.post(
            ApiRoutes.menuImages(testVenueId),
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.menuImages(testVenueId),
            ),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        final result = await venuesApi.uploadMenuImage(
          testVenueId,
          imageBytes,
          filename,
        );

        expect(result.success, false);
        expect(result.message, 'Error uploading menu image');
      });

      test('should send correct form data', () async {
        final mockResponse = Response(
          data: {'success': true, 'message': 'Uploaded', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.menuImages(testVenueId),
          ),
        );

        late FormData capturedFormData;

        when(
          () => mockDio.post(
            ApiRoutes.menuImages(testVenueId),
            data: any(named: 'data'),
          ),
        ).thenAnswer((invocation) async {
          capturedFormData = invocation.namedArguments[#data] as FormData;
          return mockResponse;
        });

        await venuesApi.uploadMenuImage(testVenueId, imageBytes, filename);

        final file = capturedFormData.files.first.value;
        expect(capturedFormData.files.first.key, 'image');
        expect(file.filename, filename);
        expect(file.contentType?.mimeType, 'image/png');
      });
    });

    group('getVenueHeaderImage', () {
      test('should return Uint8List when success', () async {
        final mockResponse = Response(
          data: {'data': base64Encode(utf8.encode('HeaderImage'))},
          requestOptions: RequestOptions(
            path: ApiRoutes.venueHeaderImage(testVenueId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.venueHeaderImage(testVenueId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getVenueHeaderImage(testVenueId);

        expect(result, isA<Uint8List>());
        expect(utf8.decode(result!), 'HeaderImage');
      });

      test('should return null when Dio throws', () async {
        when(
          () => mockDio.get(ApiRoutes.venueHeaderImage(testVenueId)),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.venueHeaderImage(testVenueId),
            ),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await venuesApi.getVenueHeaderImage(testVenueId);

        expect(result, isNull);
      });
    });

    group('getVenueImages', () {
      test('should return list of Uint8List when success', () async {
        final mockResponse = Response(
          data: [
            base64Encode(utf8.encode('Image1')),
            base64Encode(utf8.encode('Image2')),
          ],
          requestOptions: RequestOptions(
            path: ApiRoutes.venueImages(testVenueId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.venueImages(testVenueId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getVenueImages(testVenueId);

        expect(result.length, 2);
        expect(utf8.decode(result[0]), 'Image1');
        expect(result[0], isA<Uint8List>());
        expect(utf8.decode(result[1]), 'Image2');
        expect(result[1], isA<Uint8List>());
      });

      test('should return empty list when Dio throws', () async {
        when(() => mockDio.get(ApiRoutes.venueImages(testVenueId))).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.venueImages(testVenueId),
            ),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await venuesApi.getVenueImages(testVenueId);

        expect(result, isEmpty);
      });
    });

    group('getMenuImages', () {
      test('should return list of Uint8List when success', () async {
        final mockResponse = Response(
          data: [
            base64Encode(utf8.encode('Image1')),
            base64Encode(utf8.encode('Image2')),
          ],
          requestOptions: RequestOptions(
            path: ApiRoutes.menuImages(testVenueId),
          ),
        );

        when(
          () => mockDio.get(ApiRoutes.menuImages(testVenueId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.getMenuImages(testVenueId);

        expect(result.length, 2);
        expect(utf8.decode(result[0]), 'Image1');
        expect(result[0], isA<Uint8List>());
        expect(utf8.decode(result[1]), 'Image2');
        expect(result[1], isA<Uint8List>());
      });

      test('should return empty list when Dio throws', () async {
        when(() => mockDio.get(ApiRoutes.menuImages(testVenueId))).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.menuImages(testVenueId),
            ),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await venuesApi.getMenuImages(testVenueId);

        expect(result, isEmpty);
      });
    });

    group('createVenue', () {
      test('should return BasicResponse<int> on success', () async {
        final mockResponse = Response(
          data: {'success': true, 'message': 'Created', 'data': testVenueId},
          requestOptions: RequestOptions(path: ApiRoutes.venues),
        );

        when(
          () => mockDio.post(ApiRoutes.venues, data: any(named: 'data')),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.createVenue(
          ownerId: testOwnerId,
          name: testVenueName,
          location: testVenueLocation,
          maximumCapacity: testVenueMaximumCapacity,
          typeId: testVenueTypeId,
          workingDays: testVenueWorkingDays,
          workingHours: testVenueWorkingHours,
          description: testVenueDescription,
        );

        expect(result.success, true);
        expect(result.message, 'Venue created successfully.');
        expect(result.data, testVenueId);
      });

      test(
        'should return BasicResponse with false when response data is null',
        () async {
          final mockResponse = Response(
            data: {
              'success': true,
              'message': 'Error during creation',
              'data': null,
            },
            requestOptions: RequestOptions(path: ApiRoutes.venues),
          );

          when(
            () => mockDio.post(ApiRoutes.venues, data: any(named: 'data')),
          ).thenAnswer((_) async => mockResponse);

          final result = await venuesApi.createVenue(
            ownerId: testOwnerId,
            name: testVenueName,
            location: testVenueLocation,
            maximumCapacity: testVenueMaximumCapacity,
            typeId: testVenueTypeId,
            workingDays: testVenueWorkingDays,
            workingHours: testVenueWorkingHours,
            description: testVenueDescription,
          );
          expect(result.success, false);
          expect(result.message, 'Failed to create venue. Please try again.');
          expect(result.data, isNull);
        },
      );

      test('should return BasicResponse with false when Dio throws', () async {
        when(
          () => mockDio.post(ApiRoutes.venues, data: any(named: 'data')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiRoutes.venues),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await venuesApi.createVenue(
          ownerId: testOwnerId,
          name: testVenueName,
          location: testVenueLocation,
          maximumCapacity: testVenueMaximumCapacity,
          typeId: testVenueTypeId,
          workingDays: testVenueWorkingDays,
          workingHours: testVenueWorkingHours,
          description: testVenueDescription,
        );
        expect(result.success, false);
        expect(result.message, 'Error creating venue');
        expect(result.data, isNull);
      });

      test('should send correct data', () async {
        final mockResponse = Response(
          data: {'success': true, 'message': 'Created', 'data': testVenueId},
          requestOptions: RequestOptions(path: ApiRoutes.venues),
        );

        late Map<String, dynamic> capturedData;

        when(
          () => mockDio.post(ApiRoutes.venues, data: any(named: 'data')),
        ).thenAnswer((invocation) async {
          capturedData =
              invocation.namedArguments[const Symbol('data')]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        await venuesApi.createVenue(
          ownerId: testOwnerId,
          name: testVenueName,
          location: testVenueLocation,
          maximumCapacity: testVenueMaximumCapacity,
          typeId: testVenueTypeId,
          workingDays: testVenueWorkingDays,
          workingHours: testVenueWorkingHours,
          description: testVenueDescription,
        );

        expect(capturedData['ownerId'], testOwnerId);
        expect(capturedData['name'], testVenueName);
        expect(capturedData['location'], testVenueLocation);
        expect(capturedData['maximumCapacity'], testVenueMaximumCapacity);
        expect(capturedData['typeId'], testVenueTypeId);
        expect(capturedData['workingDays'], testVenueWorkingDays);
        expect(capturedData['workingHours'], testVenueWorkingHours);
        expect(capturedData['description'], testVenueDescription);
      });
    });

    group('editVenue', () {
      test('should return BasicResponse on success', () async {
        final mockResponse = Response(
          data: {'success': true, 'message': 'Edited', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.venueById(testVenueId),
          ),
        );

        when(
          () => mockDio.patch(
            ApiRoutes.venueById(testVenueId),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.editVenue(
          venueId: testVenueId,
          name: testVenueName,
          location: testVenueLocation,
          maximumCapacity: testVenueMaximumCapacity,
          typeId: testVenueTypeId,
          workingDays: testVenueWorkingDays,
          workingHours: testVenueWorkingHours,
          description: testVenueDescription,
        );

        expect(result.success, true);
        expect(result.message, 'Edited');
      });

      test('should return BasicResponse with false when Dio throws', () async {
        when(() => mockDio.patch(ApiRoutes.venueById(testVenueId))).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.venueById(testVenueId),
            ),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await venuesApi.editVenue(
          venueId: testVenueId,
          name: null,
          location: null,
          maximumCapacity: null,
          typeId: null,
          workingDays: null,
          workingHours: null,
          description: null,
        );

        expect(result.success, false);
        expect(result.message, 'Error editing venue');
      });

      test('should send correct data', () {
        final mockResponse = Response(
          data: {'success': true, 'message': 'Edited', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.venueById(testVenueId),
          ),
        );

        late Map<String, dynamic> capturedData;

        when(
          () => mockDio.patch(
            ApiRoutes.venueById(testVenueId),
            data: any(named: 'data'),
          ),
        ).thenAnswer((invocation) async {
          capturedData =
              invocation.namedArguments[const Symbol('data')]
                  as Map<String, dynamic>;
          return mockResponse;
        });

        venuesApi.editVenue(
          venueId: testVenueId,
          name: testVenueName,
          location: testVenueLocation,
          maximumCapacity: testVenueMaximumCapacity,
          typeId: testVenueTypeId,
          workingDays: testVenueWorkingDays,
          workingHours: testVenueWorkingHours,
          description: testVenueDescription,
        );

        expect(capturedData['name'], testVenueName);
        expect(capturedData['location'], testVenueLocation);
        expect(capturedData['maximumCapacity'], testVenueMaximumCapacity);
        expect(capturedData['typeId'], testVenueTypeId);
        expect(capturedData['workingDays'], testVenueWorkingDays);
        expect(capturedData['workingHours'], testVenueWorkingHours);
        expect(capturedData['description'], testVenueDescription);
      });
    });

    group('deleteVenue', () {
      test('should return BasicResponse on success', () async {
        final mockResponse = Response(
          data: {'success': true, 'message': 'Deleted', 'data': null},
          requestOptions: RequestOptions(
            path: ApiRoutes.venueById(testVenueId),
          ),
        );

        when(
          () => mockDio.delete(ApiRoutes.venueById(testVenueId)),
        ).thenAnswer((_) async => mockResponse);

        final result = await venuesApi.deleteVenue(testVenueId);

        expect(result.success, true);
        expect(result.message, 'Deleted');
      });

      test('should return BasicResponse with false when Dio throws', () async {
        when(() => mockDio.delete(ApiRoutes.venueById(testVenueId))).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiRoutes.venueById(testVenueId),
            ),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await venuesApi.deleteVenue(testVenueId);

        expect(result.success, false);
        expect(result.message, 'Error deleting venue. Please try again later.');
      });
    });
  });
}
