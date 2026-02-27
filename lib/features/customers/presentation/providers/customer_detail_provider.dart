import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/domain/entities/entities.dart';
import 'package:wms/features/customers/domain/entity/customer_details_entity.dart';
import 'package:wms/features/customers/errors/customer_errors.dart';
import 'package:wms/features/customers/presentation/providers/customer_repository_provider.dart';

final customerDetailNotifierProvider =
    NotifierProvider<CustomerNotifier, CustomerDetailState>(() {
      return CustomerNotifier();
    });

class CustomerNotifier extends Notifier<CustomerDetailState> {
  @override
  CustomerDetailState build() {
    return CustomerDetailState(
      customer: Customer.empty(),
      workshop: Workshop.empty(),
      vehicles: [],
      isLoading: false,
    );
  }

  void loadDetailsCustomer(int id) async {
    state = state.copyWith(isLoading: true);
    final repository = ref.read(customersRepositoryProvider);
    try {
      final CustomerDetails response = await repository.getDetailsCustomer(id);
      state = state.copyWith(
        customer: response.customerData,
        workshop: response.workshopData,
        vehicles: response.vehicles,
        isLoading: false,
      );
    } on CustomerErrors catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

class CustomerDetailState {
  final Customer customer;
  final Workshop workshop;
  final List<Vehicle> vehicles;
  final bool isLoading;

  const CustomerDetailState({
    required this.customer,
    required this.workshop,
    required this.vehicles,
    required this.isLoading,
  });

  CustomerDetailState copyWith({
    final Customer? customer,
    final Workshop? workshop,
    final List<Vehicle>? vehicles,
    final bool? isLoading,
  }) => CustomerDetailState(
    customer: customer ?? this.customer,
    workshop: workshop ?? this.workshop,
    vehicles: vehicles ?? this.vehicles,
    isLoading: isLoading ?? this.isLoading,
  );
}
