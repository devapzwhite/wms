import 'package:flutter_test/flutter_test.dart';
import 'package:wms/config/enums/tipo_vehiculo_enum.dart';
import 'package:wms/domain/entities/vehicle_entity.dart';

void main() {
  group('Vehicle', () {
    test('creates vehicle with required fields', () {
      final vehicle = Vehicle(
        customerId: 1,
        vehicleType: TipoVehiculo.car,
        plate: 'ABC-123',
        brand: 'Toyota',
        model: 'Corolla',
      );

      expect(vehicle.customerId, 1);
      expect(vehicle.vehicleType, TipoVehiculo.car);
      expect(vehicle.plate, 'ABC-123');
      expect(vehicle.brand, 'Toyota');
      expect(vehicle.model, 'Corolla');
    });

    test('creates vehicle with all fields', () {
      final now = DateTime.now();
      final vehicle = Vehicle(
        id: 1,
        shopId: 10,
        customerId: 1,
        vehicleType: TipoVehiculo.suv,
        plate: 'ABC-123',
        brand: 'Toyota',
        model: 'Rav4',
        year: 2020,
        photoUrl: 'http://example.com/photo.jpg',
        createAt: now,
      );

      expect(vehicle.id, 1);
      expect(vehicle.shopId, 10);
      expect(vehicle.customerId, 1);
      expect(vehicle.vehicleType, TipoVehiculo.suv);
      expect(vehicle.plate, 'ABC-123');
      expect(vehicle.brand, 'Toyota');
      expect(vehicle.model, 'Rav4');
      expect(vehicle.year, 2020);
      expect(vehicle.photoUrl, 'http://example.com/photo.jpg');
      expect(vehicle.createAt, now);
    });

    test('has default empty orders list', () {
      final vehicle = Vehicle(
        customerId: 1,
        vehicleType: TipoVehiculo.car,
        plate: 'ABC-123',
        brand: 'Toyota',
        model: 'Corolla',
      );

      expect(vehicle.orders, isEmpty);
    });

    test('allows null optional fields', () {
      final vehicle = Vehicle(
        customerId: 1,
        vehicleType: TipoVehiculo.car,
        plate: 'ABC-123',
        brand: 'Toyota',
        model: 'Corolla',
        year: null,
        photoUrl: null,
        id: null,
        shopId: null,
      );

      expect(vehicle.year, isNull);
      expect(vehicle.photoUrl, isNull);
    });
  });

  group('VehicleUpdate', () {
    test('creates VehicleUpdate with all fields', () {
      final vehicle = VehicleUpdate(
        id: 1,
        vehicleType: 'CAR',
        plate: 'ABC-123',
        brand: 'Toyota',
        model: 'Corolla',
        year: '2020',
        photoUrl: 'http://example.com/photo.jpg',
      );

      expect(vehicle.id, 1);
      expect(vehicle.vehicleType, 'CAR');
      expect(vehicle.plate, 'ABC-123');
      expect(vehicle.brand, 'Toyota');
      expect(vehicle.model, 'Corolla');
      expect(vehicle.year, '2020');
      expect(vehicle.photoUrl, 'http://example.com/photo.jpg');
    });

    test('allows null optional fields', () {
      final vehicle = VehicleUpdate(
        id: 1,
        vehicleType: null,
        plate: null,
        brand: null,
        model: null,
        year: null,
        photoUrl: null,
      );

      expect(vehicle.vehicleType, isNull);
      expect(vehicle.plate, isNull);
      expect(vehicle.brand, isNull);
      expect(vehicle.model, isNull);
      expect(vehicle.year, isNull);
      expect(vehicle.photoUrl, isNull);
    });
  });
}
