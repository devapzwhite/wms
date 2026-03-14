import 'package:flutter_test/flutter_test.dart';
import 'package:wms/domain/entities/customer_entity.dart';

void main() {
  group('Customer', () {
    test('empty factory creates customer with empty values', () {
      final customer = Customer.empty();

      expect(customer.documentId, '');
      expect(customer.name, '');
      expect(customer.lastName, '');
      expect(customer.phone, '');
      expect(customer.id, isNull);
      expect(customer.shopId, isNull);
      expect(customer.email, isNull);
      expect(customer.address, isNull);
      expect(customer.createAt, isNull);
    });

    test('creates customer with required fields', () {
      final customer = Customer(
        documentId: '12345678',
        name: 'Juan',
        lastName: 'Perez',
        phone: '+56 9 1234 5678',
      );

      expect(customer.documentId, '12345678');
      expect(customer.name, 'Juan');
      expect(customer.lastName, 'Perez');
      expect(customer.phone, '+56 9 1234 5678');
    });

    test('creates customer with all fields', () {
      final now = DateTime.now();
      final customer = Customer(
        id: 1,
        shopId: 10,
        documentId: '12345678',
        name: 'Juan',
        lastName: 'Perez',
        phone: '+56 9 1234 5678',
        email: 'juan@email.com',
        address: 'Calle 123',
        createAt: now,
      );

      expect(customer.id, 1);
      expect(customer.shopId, 10);
      expect(customer.documentId, '12345678');
      expect(customer.name, 'Juan');
      expect(customer.lastName, 'Perez');
      expect(customer.phone, '+56 9 1234 5678');
      expect(customer.email, 'juan@email.com');
      expect(customer.address, 'Calle 123');
      expect(customer.createAt, now);
    });

    test('allows null optional fields', () {
      final customer = Customer(
        documentId: '12345678',
        name: 'Juan',
        lastName: 'Perez',
        phone: '+56 9 1234 5678',
        email: null,
        address: null,
      );

      expect(customer.email, isNull);
      expect(customer.address, isNull);
    });
  });
}
