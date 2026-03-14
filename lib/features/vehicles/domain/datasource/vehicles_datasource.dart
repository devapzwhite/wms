import 'package:wms/domain/entities/entities.dart';

abstract class VehiclesDatasource {
  Future<List<Vehicle>> getVehicles();
  Future<Vehicle> addVehicle(Vehicle vehicle);
  Future<Vehicle> getVehicleById(int id);
  Future<void> updateVehicle(VehicleUpdate vehicle);
  Future<Vehicle> getVehicleByPlate(String plate);
  Future<Vehicle> getVehicleDetailById(int id);
}
