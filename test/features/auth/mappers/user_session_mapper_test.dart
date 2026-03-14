import 'package:flutter_test/flutter_test.dart';
import 'package:wms/features/auth/infrastructure/mappers/user_session_mapper.dart';

void main() {
  group('UserSessionMapper - userSessionToEntity', () {
    test('convierte Map a UserSessionEntity correctamente', () {
      final data = {
        'user': {
          'id': 1,
          'username': 'juan',
          'email': 'juan@email.com',
          'name': 'Juan Perez',
          'shop_id': 10,
        },
        'access_token': 'token123',
        'token_type': 'Bearer',
        'exp': '2024-12-31T23:59:59Z',
      };

      final result = UserSessionMapper.userSessionToEntity(data);

      expect(result.user.id, 1);
      expect(result.user.username, 'juan');
      expect(result.user.email, 'juan@email.com');
      expect(result.user.name, 'Juan Perez');
      expect(result.user.shopId, 10);
      expect(result.token.accessToken, 'token123');
      expect(result.token.tokenType, 'Bearer');
      expect(result.token.expiresAt.year, 2024);
      expect(result.token.expiresAt.month, 12);
      expect(result.token.expiresAt.day, 31);
    });

    test('parsea token con formato iso8601 correctamente', () {
      final data = {
        'user': {
          'id': 1,
          'username': 'juan',
          'email': 'juan@email.com',
          'name': 'Juan Perez',
          'shop_id': 10,
        },
        'access_token': 'token123',
        'token_type': 'Bearer',
        'exp': '2025-06-15T10:30:00Z',
      };

      final result = UserSessionMapper.userSessionToEntity(data);

      expect(result.token.expiresAt.year, 2025);
      expect(result.token.expiresAt.month, 6);
      expect(result.token.expiresAt.day, 15);
    });
  });
}
