import 'package:flutter_test/flutter_test.dart';
import 'package:wms/config/enums/tipo_vehiculo_enum.dart';
import 'package:wms/domain/entities/vehicle_entity.dart';
import 'package:wms/features/vehicles/infrastructure/mappers/vehicle_mapper.dart';

void main() {
  group('VehicleMapper - dataToVehicleEntity', () {
    test('photoUrl null usa "no photo" por defecto', () {
      final data = {
        'id': 1,
        'customer_id': 10,
        'vehicle_type': 'CAR',
        'shop_id': 1,
        'plate': 'ABC-123',
        'model': 'Corolla',
        'brand': 'Toyota',
        'year': 2020,
        'photo_url': null,
        'created_at': '2024-01-01',
      };

      final result = VehicleMapper.dataToVehicleEntity(data);

      expect(result.photoUrl, 'no photo');
    });

    test('parsea valores correctamente', () {
      final data = {
        'id': 1,
        'customer_id': 10,
        'vehicle_type': 'CAR',
        'shop_id': 1,
        'plate': 'ABC-123',
        'model': 'Corolla',
        'brand': 'Toyota',
        'year': 2020,
        'photo_url': 'http://example.com/photo.jpg',
        'created_at': '2024-01-01',
      };

      final result = VehicleMapper.dataToVehicleEntity(data);

      expect(result.id, 1);
      expect(result.customerId, 10);
      expect(result.vehicleType, TipoVehiculo.car);
      expect(result.plate, 'ABC-123');
      expect(result.model, 'Corolla');
      expect(result.brand, 'Toyota');
      expect(result.year, 2020);
      expect(result.photoUrl, 'http://example.com/photo.jpg');
    });

    test('parsea created_at correctamente', () {
      final data = {
        'id': 1,
        'customer_id': 10,
        'vehicle_type': 'CAR',
        'shop_id': 1,
        'plate': 'ABC-123',
        'model': 'Corolla',
        'brand': 'Toyota',
        'year': 2020,
        'photo_url': null,
        'created_at': '2024-06-15T10:30:00Z',
      };

      final result = VehicleMapper.dataToVehicleEntity(data);

      expect(result.createAt, isNotNull);
      expect(result.createAt?.year, 2024);
      expect(result.createAt?.month, 6);
    });
  });

  group('VehicleMapper - textToTipoVehiculo', () {
    test('CAR retorna TipoVehiculo.car', () {
      expect(VehicleMapper.textToTipoVehiculo('CAR'), TipoVehiculo.car);
    });

    test('SUV retorna TipoVehiculo.suv', () {
      expect(VehicleMapper.textToTipoVehiculo('SUV'), TipoVehiculo.suv);
    });

    test('VAN retorna TipoVehiculo.van', () {
      expect(VehicleMapper.textToTipoVehiculo('VAN'), TipoVehiculo.van);
    });

    test('PICKUP retorna TipoVehiculo.pickup', () {
      expect(VehicleMapper.textToTipoVehiculo('PICKUP'), TipoVehiculo.pickup);
    });

    test('TRUCK retorna TipoVehiculo.truck', () {
      expect(VehicleMapper.textToTipoVehiculo('TRUCK'), TipoVehiculo.truck);
    });

    test('SKID_STEER retorna TipoVehiculo.skidSteer', () {
      expect(VehicleMapper.textToTipoVehiculo('SKID_STEER'), TipoVehiculo.skidSteer);
    });

    test('MOTORCYCLE retorna TipoVehiculo.motorcycle', () {
      expect(VehicleMapper.textToTipoVehiculo('MOTORCYCLE'), TipoVehiculo.motorcycle);
    });

    test('string vacío retorna TipoVehiculo.car por defecto', () {
      expect(VehicleMapper.textToTipoVehiculo(''), TipoVehiculo.car);
    });

    test('valor desconocido retorna TipoVehiculo.car por defecto', () {
      expect(VehicleMapper.textToTipoVehiculo('UNKNOWN'), TipoVehiculo.car);
      expect(VehicleMapper.textToTipoVehiculo('invalid'), TipoVehiculo.car);
    });
  });

  group('VehicleMapper - tipoVehiculoToData', () {
    test('convierte TipoVehiculo.car a "CAR"', () {
      final vehicle = _createVehicle(vehicleType: TipoVehiculo.car);
      final result = VehicleMapper.tipoVehiculoToData(vehicle);

      expect(result['vehicle_type'], 'CAR');
    });

    test('convierte TipoVehiculo.suv a "SUV"', () {
      final vehicle = _createVehicle(vehicleType: TipoVehiculo.suv);
      final result = VehicleMapper.tipoVehiculoToData(vehicle);

      expect(result['vehicle_type'], 'SUV');
    });
  });

  group('VehicleMapper - vehiculoUpdateToData', () {
    test('solo incluye campos no nulos', () {
      final vehicle = VehicleUpdate(
        id: 1,
        plate: 'ABC-123',
        brand: 'Toyota',
      );

      final result = VehicleMapper.vehiculoUpdateToData(vehicle);

      expect(result.containsKey('plate'), isTrue);
      expect(result.containsKey('brand'), isTrue);
      expect(result.containsKey('vehicle_type'), isFalse);
      expect(result.containsKey('model'), isFalse);
      expect(result.containsKey('year'), isFalse);
      expect(result.containsKey('photo_url'), isFalse);
    });

    test('excluye todos los campos cuando son null', () {
      final vehicle = VehicleUpdate(id: 1);

      final result = VehicleMapper.vehiculoUpdateToData(vehicle);

      expect(result.isEmpty, isTrue);
    });

    test('incluye todos los campos cuando no son null', () {
      final vehicle = VehicleUpdate(
        id: 1,
        vehicleType: 'CAR',
        plate: 'ABC-123',
        brand: 'Toyota',
        model: 'Corolla',
        year: '2020',
        photoUrl: 'http://example.com/photo.jpg',
      );

      final result = VehicleMapper.vehiculoUpdateToData(vehicle);

      expect(result.length, 6);
      expect(result['plate'], 'ABC-123');
      expect(result['brand'], 'Toyota');
      expect(result['model'], 'Corolla');
      expect(result['year'], '2020');
      expect(result['photo_url'], 'http://example.com/photo.jpg');
    });
  });
}

Vehicle _createVehicle({
  int? id,
  TipoVehiculo? vehicleType,
}) {
  return Vehicle(
    id: id,
    customerId: 1,
    vehicleType: vehicleType ?? TipoVehiculo.car,
    plate: 'ABC-123',
    brand: 'Toyota',
    model: 'Corolla',
  );
}
