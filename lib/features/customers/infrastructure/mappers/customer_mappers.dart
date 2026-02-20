import 'package:wms/domain/entities/entities.dart';

class CustomerMappers {
  static Map<String, dynamic> customerEntityToData(Customer customer) =>
      Map<String, dynamic>.from({
        'document_id': customer.documentId,
        'name': customer.name,
        'last_name': customer.lastName,
        'phone': customer.phone,
        'email': customer.email,
        'address': customer.address,
      });

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
}
