class VenueType {
  final int id;
  final String type;

  VenueType({required this.id, required this.type});

  factory VenueType.fromJson(Map<String, dynamic> json) {
    return VenueType(id: json['id'], type: json['type']);
  }
}
