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
    );
  }

  void loadDetailsCustomer(int id) async {
    final repository = ref.read(customersRepositoryProvider);
    try {
      final CustomerDetails response = await repository.getDetailsCustomer(id);
      state = state.copyWith(
        customer: response.customerData,
        workshop: response.workshopData,
        vehicles: response.vehicles,
      );
    } on CustomerErrors catch (e) {
      print(e.message);
    }
  }
}

class CustomerDetailState {
  final Customer customer;
  final Workshop workshop;
  final List<Vehicle> vehicles;

  const CustomerDetailState({
    required this.customer,
    required this.workshop,
    required this.vehicles,
  });

  CustomerDetailState copyWith({
    final Customer? customer,
    final Workshop? workshop,
    final List<Vehicle>? vehicles,
  }) => CustomerDetailState(
    customer: customer ?? this.customer,
    workshop: workshop ?? this.workshop,
    vehicles: vehicles ?? this.vehicles,
  );
}
