class Workshop {
  final String name;
  final String ownerName;
  final String phone;
  final String address;

  Workshop({
    required this.name,
    required this.ownerName,
    required this.phone,
    required this.address,
  });

  factory Workshop.empty() =>
      Workshop(name: '', ownerName: '', phone: '', address: '');
}
