import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/domain/entities/customer_entity.dart';
import 'package:wms/features/auth/presentation/providers/auth_provider.dart';
import 'package:wms/features/customers/domain/datasource/customers_datasource.dart';
import 'package:wms/features/customers/domain/entity/customer_details_entity.dart';
import 'package:wms/features/customers/errors/customer_errors.dart';
import 'package:wms/features/customers/infrastructure/mappers/customer_mappers.dart';

class CustomersDatasourceImpl extends CustomersDatasource {
  final Ref ref;
  CustomersDatasourceImpl(this.ref);
  final dio = Dio(
    BaseOptions(
      baseUrl: '${dotenv.get('API_URL')}/customers',
      headers: {'Authorization': 'bearer '},
    ),
  );
  String _getToken() {
    final bool expired = ref.read(authProvider.notifier).isTokenExpired();
    if (expired) {
      throw CustomerErrors(message: 'Token expirado');
    }
    return ref.read(authProvider).userSession!.token.accessToken;
  }

  @override
  Future<void> deleteUser(int id) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<Customer> getCustomer(int id) {
    // TODO: implement getCustomer
    throw UnimplementedError();
  }

  @override
  Future<Customer> getCustomerByDocumentId(int shopId, String documentId) {
    // TODO: implement getCustomerByDocumentId
    throw UnimplementedError();
  }

  @override
  Future<List<Customer>> getCustomers() async {
    try {
      final response = await dio.get(
        '',
        options: Options(headers: {'Authorization': 'Bearer ${_getToken()}'}),
      );
      final List<Customer> customers = List<Customer>.from(
        response.data.map(
          (customer) => CustomerMappers.dataToCustomerEntity(customer),
        ),
      );
      return customers;
    } on DioException catch (e) {
      throw CustomerErrors(
        message:
            ' ${e.response?.statusCode ?? 'no code'} - ${e.message.toString()}',
      );
    } catch (e) {
      throw CustomerErrors(message: 'error no controlado ${e.toString()}');
    }
  }

  @override
  Future<Customer> updateCustomer(Customer customer) async {
    final data = CustomerMappers.customerUpdateEntityToData(customer);
    try {
      if (data.isEmpty) {
        throw CustomerErrors(message: 'no hay datos a modificar!');
      }
      final result = await dio.put(
        '/${customer.id}',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer ${_getToken()}'}),
      );
      final Customer customerResult = CustomerMappers.dataToCustomerEntity(
        result.data,
      );
      return customerResult;
    } on DioException catch (e) {
      throw CustomerErrors(message: e.message!);
    } on CustomerErrors catch (e) {
      throw CustomerErrors(message: e.message);
    } catch (e) {
      throw CustomerErrors(message: 'error no controlado ${e.toString()}');
    }
  }

  @override
  Future<Customer> addCustomer(Customer customer) async {
    final Map<String, dynamic> dataCustomer =
        CustomerMappers.customerEntityToData(customer);
    try {
      final response = await dio.post(
        '',
        data: dataCustomer,
        options: Options(headers: {'Authorization': 'Bearer ${_getToken()}'}),
      );
      return CustomerMappers.dataToCustomerEntity(response.data);
    } on DioException catch (e) {
      print('${customer.documentId} - ${customer.name} - ${customer.lastName}');
      if (e.response?.statusCode == 401) {
        throw CustomerErrors(message: 'token expirado: ${e.message}');
      }
      if (e.response?.statusCode == 400) {
        throw CustomerErrors(
          message: 'Este Cliente ya se encuentra registrado',
        );
      }
      throw CustomerErrors(
        message:
            "error de conexion: ${e.response?.statusCode ?? 'sin respuesta'}",
      );
    } catch (e) {
      throw CustomerErrors(message: 'Error no controlado ${e.toString()}');
    }
  }

  @override
  Future<CustomerDetails> getDetailsCustomer(int id) async {
    try {
      final response = await dio.get(
        '/$id/details',
        options: Options(headers: {'Authorization': 'Bearer ${_getToken()}'}),
      );
      final CustomerDetails customerDetails =
          CustomerMappers.dataToCustomerDetailsEntity(response.data);
      return customerDetails;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomerErrors(message: 'token expirado: ${e.message}');
      }
      throw CustomerErrors(
        message:
            "error de conexion: ${e.response?.statusCode ?? 'sin respuesta'}",
      );
    } catch (e) {
      throw CustomerErrors(message: "error sin respuesta ${e.toString()}");
    }
  }
}
