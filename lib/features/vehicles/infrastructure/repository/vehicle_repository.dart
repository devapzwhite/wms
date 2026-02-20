import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/domain/entities/vehicle_entity.dart';
import 'package:wms/features/vehicles/domain/datasource/vehicles_datasource.dart';
import 'package:wms/features/vehicles/domain/repository/vehicles_repository.dart';
import 'package:wms/features/vehicles/infrastructure/datasource/vehicle_datasource_impl.dart';

class VehicleRepositoryImpl extends VehiclesRepository {
  final VehiclesDatasource vehiclesDatasource;
  final Ref ref;

  VehicleRepositoryImpl({VehiclesDatasource? datasource, required this.ref})
    : vehiclesDatasource = datasource ?? VehicleDatasourceImpl(ref: ref);

  @override
  Future<List<Vehicle>> getVehicles() {
    return vehiclesDatasource.getVehicles();
  }

  @override
  Future<Vehicle> addVehicle(Vehicle vehicle) {
    return vehiclesDatasource.addVehicle(vehicle);
  }

  @override
  Future<Vehicle> getVehicleById(int id) {
    return vehiclesDatasource.getVehicleById(id);
  }

  @override
  Future<void> getVehicleByPlate(String plate) {
    return vehiclesDatasource.getVehicleByPlate(plate);
  }

  @override
  Future<void> updateVehicle(int id, Vehicle vehicle) {
    return vehiclesDatasource.updateVehicle(id, vehicle);
  }
}
