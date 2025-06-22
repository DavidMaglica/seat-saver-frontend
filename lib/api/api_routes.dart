class ApiRoutes {
  ApiRoutes._();

  static const user = '/user';
  static const signUp = '/signup';
  static const logIn = '/login';
  static const getUser = '/get';
  static const getNotificationOptions = '/get-notification-options';
  static const getLocation = '/get-location';
  static const updateEmail = '/update-email';
  static const updateUsername = '/update-username';
  static const updatePassword = '/update-password';
  static const updateLocation = '/update-location';
  static const updateNotificationOptions = '/update-notification-options';
  static const deleteUser = '/delete';

  static const venue = '/venue';
  static const createVenue = '/create';
  static const uploadVenueImage = '/upload-image';
  static const getVenue = '/get-venue';
  static const getAllVenues = '/get-all';
  static const getVenuesByCategory = '/get-by-category';
  static const getVenueType = '/get-type';
  static const getVenueRating = '/get-rating';
  static const getAllVenueRatings = '/get-all-ratings';
  static const getAllVenueTypes = '/get-all-types';
  static const getVenueImages = '/get-images';
  static const getVenueMenuImages = '/get-menu';
  static const uploadMenuImage = '/upload-menu-image';
  static const updateVenue = '/update';
  static const rateVenue = '/rate';
  static const deleteVenue = '/delete';

  static const reservation = '/reservation';
  static const createReservation = '/create';
  static const getReservations = '/get-all';
  static const updateReservation = '/update';
  static const deleteReservation = '/delete';

  static const geolocation = '/geolocation';
  static const fetchGeolocation = '/fetch-geolocation';
  static const getGeolocation = '/get-geolocation';
  static const getNearbyCities = '/get-nearby-cities';

  static const support = '/support';
  static const sendEmail = '/send-email';
}
