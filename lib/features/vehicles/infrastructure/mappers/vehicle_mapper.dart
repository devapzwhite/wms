import 'package:wms/config/enums/tipo_vehiculo_enum.dart';
import 'package:wms/config/helpers/mappers.dart';
import 'package:wms/domain/entities/entities.dart';

class VehicleMapper {
  static Vehicle dataToVehicleEntity(Map<String, dynamic> data) => Vehicle(
    id: data["id"],
    customerId: data["customer_id"],
    vehicleType: textToTipoVehiculo(data["vehicle_type"]),
    shopId: data["shop_id"],
    plate: data["plate"],
    model: data["model"],
    brand: data['brand'],
    year: data['year'],
    photoUrl: data['photo_url'] ?? 'no photo',
    createAt: DateTime.tryParse(data["created_at"]),
  );

  static Map<String, dynamic> tipoVehiculoToData(Vehicle vehicle) =>
      Map<String, dynamic>.from({
        "customer_id": vehicle.customerId,
        "vehicle_type": vehicle.vehicleType.label,
        "plate": vehicle.plate,
        "brand": vehicle.brand,
        "model": vehicle.model,
        "year": vehicle.year,
      });

  static Map<String, dynamic> vehiculoUpdateToData(VehicleUpdate vehicle) {
    final Map<String, dynamic> map = {};
    if (vehicle.plate != null) map['plate'] = vehicle.plate;
    if (vehicle.vehicleType != null) map['vehicle_type'] = vehicle.vehicleType;
    if (vehicle.brand != null) map['brand'] = vehicle.brand;
    if (vehicle.model != null) map['model'] = vehicle.model;
    if (vehicle.year != null) map['year'] = vehicle.year;
    if (vehicle.photoUrl != null) map['photo_url'] = vehicle.photoUrl;
    return map;
  }

  static TipoVehiculo textToTipoVehiculo(String type) {
    switch (type) {
      case "CAR":
        return TipoVehiculo.car;
      case "":
        return TipoVehiculo.car;
      case 'SUV':
        return TipoVehiculo.suv;
      case 'VAN':
        return TipoVehiculo.van;
      case 'PICKUP':
        return TipoVehiculo.pickup;
      case 'TRUCK':
        return TipoVehiculo.truck;
      case 'SKID_STEER':
        return TipoVehiculo.skidSteer;
      case 'MOTORCYCLE':
        return TipoVehiculo.motorcycle;
      default:
        return TipoVehiculo.car;
    }
  }

  static Vehicle dataToVehicleDetailEntity(Map<String, dynamic> data) {
    final customerData = data['customer'] as Map<String, dynamic>;
    final workOrdersData = data['work_orders'] as List<dynamic>;
    final List<WorkOrder> workOrders = <WorkOrder>[];
    final Customer customer = Customer(
      id: customerData['id'],
      shopId: customerData['shop_id'],
      documentId: customerData['document_id'],
      name: customerData['name'],
      lastName: customerData['last_name'],
      phone: customerData['phone'],
      email: customerData['email'],
      address: customerData['address'],
      createAt: DateTime.parse(customerData['created_at']),
    );

    for (final order in workOrdersData) {
      workOrders.add(
        WorkOrder(
          id: order['id'],
          status: Mappers.textToWorkOrderStatus(order['status']),
          initialDiagnosis: order['initial_diagnosis'],
          vehicleId: order['vehicle_id'],
          notes: order['notes'],
          shopId: order['shop_id'],
          createdBy: order['created_by_user_id'],
          checkIn: order['check_in_at'] != null
              ? DateTime.parse(order['check_in_at'])
              : null,
          checkOut: order['check_out_at'] != null
              ? DateTime.parse(order['check_out_at'])
              : null,
          createdAt: order['created_at'] != null
              ? DateTime.parse(order['created_at'])
              : null,
        ),
      );
    }
    final result = Vehicle(
      customerId: data['customer_id'],
      vehicleType: textToTipoVehiculo(data["vehicle_type"]),
      plate: data['plate'],
      brand: data['brand'],
      model: data['model'],
      year: data['year'],
      photoUrl: data['photo_url'] ?? 'no photo',
      createAt: DateTime.parse(data["created_at"]),
      id: data['id'],
      shopId: data['shop_id'],
      customer: customer,
      orders: workOrders,
    );

    return result;
  }
}
