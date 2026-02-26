import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/domain/entities/customer_entity.dart';
import 'package:wms/features/customers/presentation/providers/customer_repository_provider.dart';

final customerNotifierProvider =
    NotifierProvider<CustomerNotifier, CustomerState>(() {
      return CustomerNotifier();
    });

typedef CustomerCallback = Future<List<Customer>> Function();

class CustomerNotifier extends Notifier<CustomerState> {
  @override
  build() {
    return CustomerState();
  }

  Future<void> loadCustomers() async {
    if (state.isLoading) return;
    try {
      state = state.copyWith(isLoading: true);
      final repository = ref.read(customersRepositoryProvider);
      final customers = await repository.getCustomers();
      // state = [...state, ...customers];
      state = state.copyWith(customers: customers, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void addCustomer(Customer customer) {
    state = state.copyWith(customers: [...state.customers, customer]);
  }

  Future<Customer?> getCustomerToUpdate(int id) async {
    print('rebuild!!');
    final customer = state.customers.cast<Customer?>().firstWhere(
      (customer) => customer?.id == id,
      orElse: () => null,
    );
    if (customer != null) return customer;
    try {
      final repository = ref.read(customersRepositoryProvider);
      final Customer customerdb = await repository.getCustomer(id);
      return customerdb;
    } catch (e) {
      print('getCustomerToUpdate error: $e');
      return null;
    }
  }
}

class CustomerState {
  final bool isLoading;
  final List<Customer> customers;

  CustomerState({this.isLoading = false, this.customers = const []});

  CustomerState copyWith({bool? isLoading, List<Customer>? customers}) =>
      CustomerState(
        isLoading: isLoading ?? this.isLoading,
        customers: customers ?? this.customers,
      );
}
