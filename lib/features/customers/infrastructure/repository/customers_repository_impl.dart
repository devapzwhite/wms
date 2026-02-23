import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/domain/entities/customer_entity.dart';
import 'package:wms/features/customers/domain/datasource/customers_datasource.dart';
import 'package:wms/features/customers/domain/entity/customer_details_entity.dart';
import 'package:wms/features/customers/domain/repository/customers_repository.dart';
import 'package:wms/features/customers/infrastructure/datasource/customers_datasource_impl.dart';

class CustomersRepositoryImpl extends CustomersRepository {
  final CustomersDatasource customersDatasource;

  CustomersRepositoryImpl({
    CustomersDatasource? customersDatasource,
    required Ref ref,
  }) : customersDatasource =
           customersDatasource ?? CustomersDatasourceImpl(ref);

  @override
  Future<void> deleteUser(int id) async {
    customersDatasource.deleteUser(id);
  }

  @override
  Future<Customer> getCustomer(int id) async {
    return customersDatasource.getCustomer(id);
  }

  @override
  Future<Customer> getCustomerByDocumentId(int shopId, String documentId) {
    return customersDatasource.getCustomerByDocumentId(shopId, documentId);
  }

  @override
  Future<List<Customer>> getCustomers() async {
    return customersDatasource.getCustomers();
  }

  @override
  Future<Customer> updateCustomer(int id) async {
    return customersDatasource.updateCustomer(id);
  }

  @override
  Future<Customer> addCustomer(Customer customer) async {
    return customersDatasource.addCustomer(customer);
  }

  @override
  Future<CustomerDetails> getDetailsCustomer(int id) {
    return customersDatasource.getDetailsCustomer(id);
  }
}
