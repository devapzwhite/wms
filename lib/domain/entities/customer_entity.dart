class Customer {
  final int? id;
  final int? shopId;
  final String documentId;
  final String name;
  final String lastName;
  final String? phone;
  final String? email;
  final String? address;
  final DateTime? createAt;
  Customer({
    this.id,
    this.shopId,
    required this.documentId,
    required this.name,
    required this.lastName,
    this.phone,
    this.email,
    this.address,
    this.createAt,
  });
}
