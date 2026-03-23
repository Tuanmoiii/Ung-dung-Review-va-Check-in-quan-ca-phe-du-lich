class Venue {
  int id;
  String name;
  String description;
  String address;
  String city;
  double? latitude;
  double? longitude;
  double rating;
  int totalReviews;
  bool isOpen;
  bool isRecommended;
  List<String> categories;

  Venue({
    required this.id,
    required this.name,
    this.description = '',
    this.address = '',
    this.city = '',
    this.latitude,
    this.longitude,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.isOpen = false,
    this.isRecommended = false,
    this.categories = const [],
  });
}
