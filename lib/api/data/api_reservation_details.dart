class APIReservationDetails {
  int id;
  int userId;
  int venueId;
  String dateTime;
  int numberOfGuests;

  APIReservationDetails({
    required this.id,
    required this.userId,
    required this.venueId,
    required this.dateTime,
    required this.numberOfGuests,
  });

  factory APIReservationDetails.fromJson(Map<String, dynamic> json) {
    return APIReservationDetails(
      id: json['reservationId'],
      userId: json['userId'],
      venueId: json['venueId'],
      dateTime: json['datetime'],
      numberOfGuests: json['numberOfGuests'],
    );
  }
}
