class User {
  int id;
  String username;
  String email;
  String? fullName;
  String? avatarUrl;
  String bio;
  String level;
  int totalPoints;
  int totalVisits;
  int totalReviews;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.bio = '',
    this.level = 'Bronze',
    this.totalPoints = 0,
    this.totalVisits = 0,
    this.totalReviews = 0,
  });

  factory User.empty() => User(id: 0, username: '', email: '');
}
