import 'package:wms/config/enums/tipo_vehiculo_enum.dart';

class Vehicle {
  final int? id;
  final int? shopId;
  final int customerId;
  final TipoVehiculo vehicleType;
  final String plate;
  final String brand;
  final String model;
  final int? year;
  final String? photoUrl;
  final DateTime? createAt;
  Vehicle({
    this.id,
    this.shopId,
    required this.customerId,
    required this.vehicleType,
    required this.plate,
    required this.brand,
    required this.model,
    this.year,
    this.photoUrl,
    this.createAt,
  });
}
