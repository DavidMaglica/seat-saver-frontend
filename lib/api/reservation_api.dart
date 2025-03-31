import 'data/basic_response.dart';
import 'data/reservation_details.dart';

class ReservationApi {
  Map<String, List<ReservationDetails>> reservationsStore = {};

  List<ReservationDetails>? findReservation(String email) =>
      reservationsStore[email];

  Future<ReservationResponse?> getReservation(String email) async {
    if (!reservationsStore.containsKey(email)) {
      return null;
    }

    List<ReservationDetails> reservation = reservationsStore[email]!;
    return ReservationResponse(
      success: true,
      message: 'Reservation retrieved successfully',
      reservations: reservation,
    );
  }

  Future<BasicResponse> addReservation(String userEmail, String venueName,
      int numberOfPeople, DateTime reservationDate) async {
    ReservationDetails newReservation = ReservationDetails(
      venueName: venueName,
      numberOfGuests: numberOfPeople,
      reservationDateTime: reservationDate,
    );

    if (!reservationsStore.containsKey(userEmail)) {
      reservationsStore[userEmail] = [newReservation];
      return BasicResponse(
          success: true, message: 'Reservation added successfully');
    }

    reservationsStore[userEmail]!.add(newReservation);
    return BasicResponse(
        success: true, message: 'Reservation added successfully');
  }

  Future<ReservationResponse> getReservations(String email) async {
    if (!reservationsStore.containsKey(email)) {
      return ReservationResponse(
        success: false,
        message: 'User not found',
        reservations: null,
      );
    }

    List<ReservationDetails> reservations = reservationsStore[email]!;
    return ReservationResponse(
      success: true,
      message: 'Reservation retrieved successfully',
      reservations: reservations,
    );
  }
}
