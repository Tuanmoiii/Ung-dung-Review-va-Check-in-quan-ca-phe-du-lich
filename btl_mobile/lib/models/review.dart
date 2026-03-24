class Review {
  int id;
  int userId;
  int venueId;
  double rating;
  String comment;
  DateTime createdAt;
  int likes;

  Review({
    required this.id,
    required this.userId,
    required this.venueId,
    required this.rating,
    this.comment = '',
    DateTime? createdAt,
    this.likes = 0,
  }) : createdAt = createdAt ?? DateTime.now();
}
