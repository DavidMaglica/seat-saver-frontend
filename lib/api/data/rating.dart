class Rating {
  final int id;
  final double rating;
  final String username;
  final String comment;

  Rating({
    required this.id,
    required this.rating,
    required this.username,
    required this.comment,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'] as int,
      rating: (json['rating'] as num).toDouble(),
      username: json['username'] as String,
      comment: json['comment'] as String,
    );
  }
}
