import 'package:wms/domain/entities/customer_entity.dart';

abstract class CustomersRepository {
  Future<Customer> addCustomer(Customer customer);
  Future<List<Customer>> getCustomers();
  Future<Customer> getCustomer(int id);
  Future<Customer> getCustomerByDocumentId(int shopId, String documentId);
  Future<Customer> updateCustomer(int id);
  Future<void> deleteUser(int id);
}
