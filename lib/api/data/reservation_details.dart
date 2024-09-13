class ReservationDetails {
  final String venueName;
  final int numberOfGuests;
  final DateTime reservationDateTime;

  ReservationDetails({
    required this.venueName,
    required this.numberOfGuests,
    required this.reservationDateTime,
  });

  factory ReservationDetails.fromMap(Map<String, dynamic> json) {
    return ReservationDetails(
      venueName: json['venueName'],
      numberOfGuests: json['numberOfGuests'],
      reservationDateTime: DateTime.parse(json['reservationDate']),
    );
  }
}

class ReservationResponse {
  bool success;
  String message;
  List<ReservationDetails>? reservations;

  ReservationResponse({
    required this.success,
    required this.message,
    this.reservations,
  });

  factory ReservationResponse.fromJson(Map<String, dynamic> json) {
    return ReservationResponse(
      success: json['success'],
      message: json['message'],
      reservations: json['reservation']
          .map<ReservationDetails>((reservation) =>
              ReservationDetails.fromMap(reservation))
          .toList(),
    );
  }
}
