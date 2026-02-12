class Token {
  final String accessToken;
  final String tokenType;
  final DateTime expiresAt;

  Token({
    required this.accessToken,
    required this.tokenType,
    required this.expiresAt,
  });

  static Token jsonToToken(Map<String, dynamic> tokenData) => Token(
    accessToken: tokenData["access_token"]!,
    tokenType: tokenData["token_type"]!,
    expiresAt: DateTime.parse(tokenData["exp"]!),
  );
}
