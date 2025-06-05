class ReservationDetails {
  final int id;
  final int userId;
  final int venueId;
  final int numberOfGuests;
  final DateTime datetime;

  ReservationDetails({
    required this.id,
    required this.userId,
    required this.venueId,
    required this.numberOfGuests,
    required this.datetime,
  });

  factory ReservationDetails.fromJson(Map<String, dynamic> json) {
    return ReservationDetails(
      id: json['id'],
      userId: json['userId'],
      venueId: json['venueId'],
      numberOfGuests: json['numberOfGuests'],
      datetime: DateTime.parse(json['datetime']),
    );
  }
}
