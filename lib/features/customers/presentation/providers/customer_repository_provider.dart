import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/features/customers/infrastructure/datasource/customers_datasource_impl.dart';
import 'package:wms/features/customers/infrastructure/repository/customers_repository_impl.dart';

final customersRepositoryProvider = Provider.autoDispose((ref) {
  return CustomersRepositoryImpl(
    ref: ref,
    customersDatasource: CustomersDatasourceImpl(ref),
  );
});
