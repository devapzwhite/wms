import 'package:wms/domain/entities/entities.dart';

abstract class VehiclesRepository {
  Future<List<Vehicle>> getVehicles();
  Future<Vehicle> addVehicle(Vehicle vehicle);
  Future<Vehicle> getVehicleById(int id);
  Future<void> updateVehicle(VehicleUpdate vehicle);
  Future<void> getVehicleByPlate(String plate);
}
