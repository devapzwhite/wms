import 'package:wms/domain/entities/entities.dart';
import 'package:wms/features/customers/domain/entity/customer_details_entity.dart';

abstract class CustomersDatasource {
  Future<Customer> addCustomer(Customer customer);
  Future<List<Customer>> getCustomers();
  Future<Customer> getCustomer(int id);
  Future<Customer> getCustomerByDocumentId(int shopId, String documentId);
  Future<Customer> updateCustomer(Customer customer);
  Future<void> deleteUser(int id);
  Future<CustomerDetails> getDetailsCustomer(int id);
}
