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
    state = state.copyWith(isLoading: true);
    final repository = ref.read(customersRepositoryProvider);
    final customers = await repository.getCustomers();
    // state = [...state, ...customers];
    state = state.copyWith(customers: customers, isLoading: false);
  }

  void addCustomer(Customer customer) {
    state = state.copyWith(customers: [...state.customers, customer]);
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
