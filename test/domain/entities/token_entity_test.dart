import 'package:flutter_test/flutter_test.dart';
import 'package:wms/domain/entities/token_entity.dart';

void main() {
  group('Token', () {
    test('creates Token with required fields', () {
      final expiresAt = DateTime.now().add(const Duration(hours: 1));
      final token = Token(
        accessToken: 'jwt_token_here',
        tokenType: 'Bearer',
        expiresAt: expiresAt,
      );

      expect(token.accessToken, 'jwt_token_here');
      expect(token.tokenType, 'Bearer');
      expect(token.expiresAt, expiresAt);
    });

    group('jsonToToken', () {
      test('parses valid JSON correctly', () {
        final tokenData = {
          'access_token': 'jwt_token_here',
          'token_type': 'Bearer',
          'exp': '2024-12-31T23:59:59Z',
        };

        final token = Token.jsonToToken(tokenData);

        expect(token.accessToken, 'jwt_token_here');
        expect(token.tokenType, 'Bearer');
        expect(token.expiresAt.year, 2024);
        expect(token.expiresAt.month, 12);
        expect(token.expiresAt.day, 31);
      });

      test('throws on missing required field', () {
        final tokenData = <String, dynamic>{
          'access_token': 'jwt_token_here',
          // 'token_type' missing
          'exp': '2024-12-31T23:59:59Z',
        };

        expect(
          () => Token.jsonToToken(tokenData),
          throwsA(isA<TypeError>()),
        );
      });
    });
  });
}
