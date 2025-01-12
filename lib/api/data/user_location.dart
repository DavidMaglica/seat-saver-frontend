class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({required this.latitude, required this.longitude});

  factory UserLocation.fromMap(Map<String, dynamic> json) {
    return UserLocation(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
