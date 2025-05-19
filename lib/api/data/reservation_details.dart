class ReservationDetails {
  final int id;
  final int venueId;
  final int numberOfGuests;
  final DateTime reservationDateTime;

  ReservationDetails({
    required this.id,
    required this.venueId,
    required this.numberOfGuests,
    required this.reservationDateTime,
  });

  factory ReservationDetails.fromMap(Map<String, dynamic> json) {
    return ReservationDetails(
      id: json['id'],
      venueId: json['venueId'],
      numberOfGuests: json['numberOfGuests'],
      reservationDateTime: DateTime.parse(json['reservationDate']),
    );
  }
}
