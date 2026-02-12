class User {
  final int id;
  final String username;
  final String email;
  final String name;
  final int shopId;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.shopId,
  });

  static User jsonToUser(Map<String, dynamic> userData) => User(
    id: userData["id"]!,
    username: userData["username"]!,
    email: userData["email"]!,
    name: userData["name"]!,
    shopId: userData["shop_id"]!,
  );
}
