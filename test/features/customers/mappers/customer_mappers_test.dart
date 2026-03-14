import 'package:flutter_test/flutter_test.dart';
import 'package:wms/domain/entities/customer_entity.dart';
import 'package:wms/features/customers/infrastructure/mappers/customer_mappers.dart';

void main() {
  group('CustomerMappers - customerEntityToData', () {
    test('convierte email vacío a null', () {
      final customer = Customer(
        id: 1,
        shopId: 1,
        documentId: '123',
        name: 'Juan',
        lastName: 'Perez',
        phone: '123456',
        email: '',
        address: 'Calle 1',
      );

      final result = CustomerMappers.customerEntityToData(customer);

      expect(result['email'], isNull);
    });

    test('convierte address vacío a null', () {
      final customer = Customer(
        id: 1,
        shopId: 1,
        documentId: '123',
        name: 'Juan',
        lastName: 'Perez',
        phone: '123456',
        email: 'juan@mail.com',
        address: '',
      );

      final result = CustomerMappers.customerEntityToData(customer);

      expect(result['address'], isNull);
    });

    test('preserva valores normales', () {
      final customer = Customer(
        id: 1,
        shopId: 1,
        documentId: '123',
        name: 'Juan',
        lastName: 'Perez',
        phone: '123456',
        email: 'juan@mail.com',
        address: 'Calle 1',
      );

      final result = CustomerMappers.customerEntityToData(customer);

      expect(result['email'], 'juan@mail.com');
      expect(result['address'], 'Calle 1');
      expect(result['name'], 'Juan');
      expect(result['last_name'], 'Perez');
      expect(result['phone'], '123456');
      expect(result['document_id'], '123');
    });

    test('preserva valores null de email y address', () {
      final customer = Customer(
        id: 1,
        shopId: 1,
        documentId: '123',
        name: 'Juan',
        lastName: 'Perez',
        phone: '123456',
        email: null,
        address: null,
      );

      final result = CustomerMappers.customerEntityToData(customer);

      expect(result['email'], isNull);
      expect(result['address'], isNull);
    });
  });

  group('CustomerMappers - customerUpdateEntityToData', () {
    test('elimina claves con valor vacío', () {
      final customer = Customer(
        id: 1,
        shopId: 1,
        documentId: '123',
        name: 'Juan',
        lastName: 'Perez',
        phone: '123456',
        email: '',
        address: '',
      );

      final result = CustomerMappers.customerUpdateEntityToData(customer);

      expect(result.containsKey('email'), isFalse);
      expect(result.containsKey('address'), isFalse);
      expect(result.containsKey('name'), isTrue);
      expect(result.containsKey('last_name'), isTrue);
    });

    test('elimina claves con valor null', () {
      final customer = Customer(
        id: 1,
        shopId: 1,
        documentId: '123',
        name: 'Juan',
        lastName: 'Perez',
        phone: '123456',
        email: null,
        address: null,
      );

      final result = CustomerMappers.customerUpdateEntityToData(customer);

      expect(result.containsKey('email'), isFalse);
      expect(result.containsKey('address'), isFalse);
    });

    test('preserva todos los valores cuando son normales', () {
      final customer = Customer(
        id: 1,
        shopId: 1,
        documentId: '123',
        name: 'Juan',
        lastName: 'Perez',
        phone: '123456',
        email: 'juan@mail.com',
        address: 'Calle 1',
      );

      final result = CustomerMappers.customerUpdateEntityToData(customer);

      expect(result['email'], 'juan@mail.com');
      expect(result['address'], 'Calle 1');
      expect(result['name'], 'Juan');
      expect(result['last_name'], 'Perez');
    });
  });

  group('CustomerMappers - dataToCustomerEntity', () {
    test('email null usa "no email" por defecto', () {
      final data = {
        'id': 1,
        'shop_id': 1,
        'document_id': '123',
        'name': 'Juan',
        'last_name': 'Perez',
        'phone': '123456',
        'email': null,
        'address': null,
        'created_at': '2024-01-01',
      };

      final result = CustomerMappers.dataToCustomerEntity(data);

      expect(result.email, 'no email');
      expect(result.address, 'no address');
    });

    test('preserva valores normales', () {
      final data = {
        'id': 1,
        'shop_id': 1,
        'document_id': '123',
        'name': 'Juan',
        'last_name': 'Perez',
        'phone': '123456',
        'email': 'juan@mail.com',
        'address': 'Calle 1',
        'created_at': '2024-01-01',
      };

      final result = CustomerMappers.dataToCustomerEntity(data);

      expect(result.email, 'juan@mail.com');
      expect(result.address, 'Calle 1');
      expect(result.name, 'Juan');
      expect(result.lastName, 'Perez');
    });

    test('parsea created_at correctamente', () {
      final data = {
        'id': 1,
        'shop_id': 1,
        'document_id': '123',
        'name': 'Juan',
        'last_name': 'Perez',
        'phone': '123456',
        'email': 'juan@mail.com',
        'address': 'Calle 1',
        'created_at': '2024-06-15T10:30:00Z',
      };

      final result = CustomerMappers.dataToCustomerEntity(data);

      expect(result.createAt, isNotNull);
      expect(result.createAt?.year, 2024);
      expect(result.createAt?.month, 6);
      expect(result.createAt?.day, 15);
    });
  });
}
