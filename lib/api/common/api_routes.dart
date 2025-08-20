class ApiRoutes {
  ApiRoutes._();

  static const String apiBase = '/api/v1';

  static const String users = '$apiBase/users';
  static const String signUp = '$users/signup';
  static const String logIn = '$users/login';

  static String userById(int userId) => '$users/$userId';
  static String usersByIds = '$users/by-ids';

  static String userNotifications(int userId) =>
      '${userById(userId)}/notifications';

  static String userLocation(int userId) => '${userById(userId)}/location';

  static String updateEmail(int userId) => '${userById(userId)}/email';

  static String updateUsername(int userId) => '${userById(userId)}/username';

  static String updatePassword(int userId) => '${userById(userId)}/password';

  static String updateLocation(int userId) => '${userById(userId)}/location';

  static String updateNotifications(int userId) =>
      '${userById(userId)}/notifications';

  static const String venues = '$apiBase/venues';

  static String venueById(int venueId) => '$venues/$venueId';

  static String venuesByOwnerId(int ownerId) => '$venues/owner/$ownerId';

  static String venueHeaderImage(int venueId) =>
      '${venueById(venueId)}/header-image';

  static String venueImages(int venueId) =>
      '${venueById(venueId)}/venue-images';

  static String menuImages(int venueId) => '${venueById(venueId)}/menu-images';

  static String venueAverageRating(int venueId) =>
      '${venueById(venueId)}/average-rating';

  static String allVenueRatings(int venueId) => '${venueById(venueId)}/ratings';

  static String venueRatingsCount(int ownerId) => '$venues/ratings/count/$ownerId';

  static String overallRating(int ownerId) =>
      '$venues/overall-rating/$ownerId';

  static String venueUtilisationRate(int ownerId) =>
      '$venues/utilisation-rate/$ownerId';

  static String rateVenue(int venueId) => '${venueById(venueId)}/rate';

  static String venueType(int typeId) => '$venues/type/$typeId';
  static const String allVenueTypes = '$venues/types';

  static const String reservations = '$apiBase/reservations';

  static const String reservationWithEmail = '$reservations/create-with-email';

  static String reservationById(int reservationId) =>
      '$reservations/$reservationId';

  static String userReservations(int userId) => '$reservations/user/$userId';

  static String ownerReservations(int ownerId) =>
      '$reservations/owner/$ownerId';

  static String venueReservations(int venueId) =>
      '$reservations/venue/$venueId';

  static String reservationCount(int ownerId) => '$reservations/count/$ownerId';

  static const String geolocation = '$apiBase/geolocation';
  static const String getNearbyCities = '$geolocation/nearby-cities';

  static const String support = '$apiBase/support';
  static const String sendEmail = '$support/send-email';
}
