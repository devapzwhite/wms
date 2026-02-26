import 'package:wms/domain/entities/entities.dart';
import 'package:wms/features/customers/domain/entity/customer_details_entity.dart';
import 'package:wms/features/vehicles/infrastructure/mappers/vehicle_mapper.dart';

class CustomerMappers {
  static Map<String, dynamic> customerEntityToData(Customer customer) =>
      Map<String, dynamic>.from({
        'document_id': customer.documentId,
        'name': customer.name,
        'last_name': customer.lastName,
        'phone': customer.phone,
        'email': customer.email == '' ? null : customer.email,
        'address': customer.address == '' ? null : customer.address,
      });

  static Map<String, dynamic> customerUpdateEntityToData(Customer customer) {
    final result = Map<String, dynamic>.from({
      'document_id': customer.documentId,
      'name': customer.name,
      'last_name': customer.lastName,
      'phone': customer.phone,
      'email': customer.email == '' || customer.email == null
          ? ''
          : customer.email,
      'address': customer.address == '' || customer.address == null
          ? ''
          : customer.address,
    });
    result.removeWhere((key, value) => value == '');
    return result;
  }

  static Customer dataToCustomerEntity(Map<String, dynamic> data) => Customer(
    id: data["id"],
    shopId: data["shop_id"],
    documentId: data["document_id"],
    name: data["name"],
    lastName: data["last_name"],
    phone: data["phone"] ?? 'no phone',
    email: data["email"] ?? 'no email',
    address: data["address"] ?? 'no address',
    createAt: DateTime.tryParse(data["created_at"]),
  );

  static CustomerDetails dataToCustomerDetailsEntity(
    Map<String, dynamic> data,
  ) {
    final Map<String, dynamic> workshopDetails = data['workshop'];
    final List<dynamic> vehicles = data['vehicles'];
    final Customer customer = Customer(
      documentId: data['document_id'],
      name: data['name'],
      lastName: data['last_name'],
      phone: data['phone'],
      email: data['email'] ?? 'No se registro Email',
      address: data['address'] ?? 'no address',
    );
    final Workshop workshop = Workshop(
      name: workshopDetails['name'] ?? 'No Name',
      ownerName: workshopDetails['ownerName'] ?? 'No Owner Name',
      phone: workshopDetails['phone'] ?? 'No phone',
      address: workshopDetails['address'] ?? 'No address',
    );
    final CustomerDetails response = CustomerDetails(
      customerData: customer,
      workshopData: workshop,
      vehicles: List<Vehicle>.from(
        vehicles.map(
          (vehicleData) => VehicleMapper.dataToVehicleEntity(vehicleData),
        ),
      ),
    );
    return response;
  }
}
