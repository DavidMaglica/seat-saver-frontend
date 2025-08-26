class Venue {
  final int id;
  final String name;
  final String location;
  final List<int> workingDays;
  final String workingHours;
  final int maximumCapacity;
  final int availableCapacity;
  double rating;
  final int typeId;
  String? description;

  Venue({
    required this.id,
    required this.name,
    required this.location,
    required this.workingDays,
    required this.workingHours,
    required this.maximumCapacity,
    required this.availableCapacity,
    required this.rating,
    required this.typeId,
    this.description,
  });

  factory Venue.fromJson(Map<String, dynamic> map) {
    return Venue(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      workingDays: List<int>.from(map['workingDays']),
      workingHours: map['workingHours'],
      maximumCapacity: map['maximumCapacity'],
      availableCapacity: map['availableCapacity'],
      rating: map['averageRating'],
      typeId: map['venueTypeId'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'workingHours': workingHours,
      'maximumCapacity': maximumCapacity,
      'availableCapacity': availableCapacity,
      'rating': rating,
      'type': typeId,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Venue(id: $id, name: $name, location: $location, workingDays: $workingDays, workingHours: $workingHours, rating: $rating, type: $typeId, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Venue &&
        other.id == id &&
        other.name == name &&
        other.location == location &&
        other.workingDays == workingDays &&
        other.workingHours == workingHours &&
        other.maximumCapacity == maximumCapacity &&
        other.availableCapacity == availableCapacity &&
        other.rating == rating &&
        other.typeId == typeId &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        location.hashCode ^
        workingDays.hashCode ^
        workingHours.hashCode ^
        maximumCapacity.hashCode ^
        availableCapacity.hashCode ^
        rating.hashCode ^
        typeId.hashCode ^
        description.hashCode;
  }
}
