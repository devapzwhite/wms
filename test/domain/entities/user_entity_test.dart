import 'package:flutter_test/flutter_test.dart';
import 'package:wms/domain/entities/user_entity.dart';

void main() {
  group('User', () {
    test('creates User with required fields', () {
      final user = User(
        id: 1,
        username: 'juan',
        email: 'juan@email.com',
        name: 'Juan Perez',
        shopId: 10,
      );

      expect(user.id, 1);
      expect(user.username, 'juan');
      expect(user.email, 'juan@email.com');
      expect(user.name, 'Juan Perez');
      expect(user.shopId, 10);
    });

    group('jsonToUser', () {
      test('parses valid JSON correctly', () {
        final userData = {
          'id': 1,
          'username': 'juan',
          'email': 'juan@email.com',
          'name': 'Juan Perez',
          'shop_id': 10,
        };

        final user = User.jsonToUser(userData);

        expect(user.id, 1);
        expect(user.username, 'juan');
        expect(user.email, 'juan@email.com');
        expect(user.name, 'Juan Perez');
        expect(user.shopId, 10);
      });

      test('throws on missing required field', () {
        final userData = <String, dynamic>{
          'id': 1,
          'username': 'juan',
          // 'email' missing
          'name': 'Juan Perez',
          'shop_id': 10,
        };

        expect(
          () => User.jsonToUser(userData),
          throwsA(isA<TypeError>()),
        );
      });
    });
  });
}
