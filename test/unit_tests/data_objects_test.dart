import 'package:flutter_test/flutter_test.dart';
import 'package:seat_saver/api/data/basic_response.dart';
import 'package:seat_saver/api/data/notification_settings.dart';
import 'package:seat_saver/api/data/paged_response.dart';
import 'package:seat_saver/api/data/rating.dart';
import 'package:seat_saver/api/data/reservation_details.dart';
import 'package:seat_saver/api/data/user.dart';
import 'package:seat_saver/api/data/user_location.dart';
import 'package:seat_saver/api/data/venue.dart';
import 'package:seat_saver/api/data/venue_type.dart';

void main() {
  group('BasicResponse', () {
    test('fromJson parses correctly with data', () {
      final json = {
        'success': true,
        'message': 'ok',
        'data': {'id': 1},
      };
      final resp = BasicResponse.fromJson(json, (d) => d['id']);
      expect(resp.success, true);
      expect(resp.message, 'ok');
      expect(resp.data, 1);
    });

    test('fromJson parses correctly without data', () {
      final json = {'success': false, 'message': 'error', 'data': null};
      final resp = BasicResponse.fromJson(json, (d) => d['id']);
      expect(resp.success, false);
      expect(resp.message, 'error');
      expect(resp.data, null);
    });
  });

  group('NotificationOptions', () {
    test('fromJson parses correctly', () {
      final json = {
        'isPushNotificationsEnabled': true,
        'isEmailNotificationsEnabled': false,
        'isLocationServicesEnabled': true,
      };
      final options = NotificationOptions.fromJson(json);
      expect(options.isPushNotificationsEnabled, true);
      expect(options.isEmailNotificationsEnabled, false);
      expect(options.isLocationServicesEnabled, true);
    });
  });

  group('PagedResponse', () {
    test('fromJson parses correctly', () {
      final json = {
        'content': [
          {'id': 1},
          {'id': 2},
        ],
        'page': 0,
        'size': 2,
        'totalElements': 2,
        'totalPages': 1,
      };
      final resp = PagedResponse.fromJson(json, (d) => d['id']);
      expect(resp.items, [1, 2]);
      expect(resp.page, 0);
      expect(resp.size, 2);
      expect(resp.totalElements, 2);
      expect(resp.totalPages, 1);
    });
  });

  group('Rating', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 1,
        'rating': 4.5,
        'username': 'user',
        'comment': 'Great',
      };
      final rating = Rating.fromJson(json);
      expect(rating.id, 1);
      expect(rating.rating, 4.5);
      expect(rating.username, 'user');
      expect(rating.comment, 'Great');
    });
  });

  group('ReservationDetails', () {
    test('fromJson parses datetime correctly', () {
      final json = {
        'id': 1,
        'userId': 2,
        'venueId': 3,
        'numberOfGuests': 4,
        'datetime': '2025-08-31T15:00:00',
      };
      final res = ReservationDetails.fromJson(json);
      expect(res.id, 1);
      expect(res.userId, 2);
      expect(res.venueId, 3);
      expect(res.numberOfGuests, 4);
      expect(res.datetime, DateTime.parse('2025-08-31T15:00:00'));
    });
  });

  group('UserLocation', () {
    test('fromJson parses correctly', () {
      final json = {'latitude': 52.5, 'longitude': 13.4};
      final loc = UserLocation.fromJson(json);
      expect(loc.latitude, 52.5);
      expect(loc.longitude, 13.4);
    });
  });

  group('User', () {
    test('fromJson parses correctly with notificationOptions', () {
      final json = {
        'id': 1,
        'username': 'user',
        'email': 'a@b.com',
        'notificationOptions': {
          'isPushNotificationsEnabled': true,
          'isEmailNotificationsEnabled': false,
          'isLocationServicesEnabled': true,
        },
        'lastKnownLatitude': 52.5,
        'lastKnownLongitude': 13.4,
      };
      final user = User.fromJson(json);
      expect(user.id, 1);
      expect(user.username, 'user');
      expect(user.email, 'a@b.com');
      expect(user.notificationOptions?.isPushNotificationsEnabled, true);
      expect(user.lastKnownLatitude, 52.5);
      expect(user.lastKnownLongitude, 13.4);
    });

    test('fromJson parses correctly without notificationOptions', () {
      final json = {
        'id': 2,
        'username': 'user2',
        'email': 'b@c.com',
        'lastKnownLatitude': null,
        'lastKnownLongitude': null,
      };
      final user = User.fromJson(json);
      expect(user.notificationOptions, null);
      expect(user.lastKnownLatitude, null);
      expect(user.lastKnownLongitude, null);
    });
  });

  group('Venue', () {
    test('fromJson and toMap work correctly', () {
      final json = {
        'id': 1,
        'name': 'Venue',
        'location': 'Location',
        'workingDays': [1, 2],
        'workingHours': '10:00 - 18:00',
        'maximumCapacity': 100,
        'availableCapacity': 50,
        'averageRating': 4.2,
        'venueTypeId': 3,
        'description': 'Nice place',
      };
      final venue = Venue.fromJson(json);
      expect(venue.id, 1);
      expect(venue.name, 'Venue');
      expect(venue.location, 'Location');
      expect(venue.workingDays, [1, 2]);
      expect(venue.workingHours, '10:00 - 18:00');
      expect(venue.maximumCapacity, 100);
      expect(venue.availableCapacity, 50);
      expect(venue.rating, 4.2);
      expect(venue.typeId, 3);
      expect(venue.description, 'Nice place');

      final map = venue.toMap();
      expect(map['id'], 1);
      expect(map['name'], 'Venue');
      expect(map['description'], 'Nice place');
    });
  });

  group('VenueType', () {
    test('fromJson parses correctly', () {
      final json = {'id': 1, 'type': 'Restaurant'};
      final type = VenueType.fromJson(json);
      expect(type.id, 1);
      expect(type.type, 'Restaurant');
    });
  });
}
