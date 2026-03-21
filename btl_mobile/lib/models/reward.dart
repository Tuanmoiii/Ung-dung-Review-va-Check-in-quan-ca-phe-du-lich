class Reward {
  int id;
  String name;
  String description;
  int pointsRequired;
  String type;
  String? discountValue;
  int validDays;

  Reward({
    required this.id,
    required this.name,
    this.description = '',
    this.pointsRequired = 0,
    this.type = 'VOUCHER',
    this.discountValue,
    this.validDays = 30,
  });
}
