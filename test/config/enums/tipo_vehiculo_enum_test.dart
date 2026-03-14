import 'package:flutter_test/flutter_test.dart';
import 'package:wms/config/enums/tipo_vehiculo_enum.dart';

void main() {
  group('TipoVehiculo', () {
    test('has correct labels', () {
      expect(TipoVehiculo.car.label, 'CAR');
      expect(TipoVehiculo.suv.label, 'SUV');
      expect(TipoVehiculo.van.label, 'VAN');
      expect(TipoVehiculo.pickup.label, 'PICKUP');
      expect(TipoVehiculo.minivan.label, 'MINIVAN');
      expect(TipoVehiculo.truck.label, 'TRUCK');
      expect(TipoVehiculo.bus.label, 'BUS');
      expect(TipoVehiculo.skidSteer.label, 'SKID_STEER');
      expect(TipoVehiculo.motorcycle.label, 'MOTORCYCLE');
    });

    test('has correct nombres', () {
      expect(TipoVehiculo.car.nombre, 'Auto');
      expect(TipoVehiculo.suv.nombre, 'Vagoneta');
      expect(TipoVehiculo.van.nombre, 'Furgón');
      expect(TipoVehiculo.pickup.nombre, 'Camioneta');
      expect(TipoVehiculo.minivan.nombre, 'Minivan');
      expect(TipoVehiculo.truck.nombre, 'Camión');
      expect(TipoVehiculo.bus.nombre, 'Bus / Minibús');
      expect(TipoVehiculo.skidSteer.nombre, 'Minicargador');
      expect(TipoVehiculo.motorcycle.nombre, 'Motocicleta');
    });

    test('has 9 vehicle type values', () {
      expect(TipoVehiculo.values.length, 9);
    });
  });
}
