import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/features/auth/presentation/providers/auth_provider.dart';
import 'package:wms/features/customers/presentation/providers/customer_repository_provider.dart';
import 'package:wms/features/home/domain/entities/home_stats_entity.dart';
import 'package:wms/features/vehicles/presentation/providers/vehicle_repository_provider.dart';
import 'package:wms/features/workorders/presentation/providers/work_order_repository_provider.dart';
import 'package:wms/features/workshops/presentation/providers/workshop_provider.dart';

final homeStatsProvider = NotifierProvider<HomeStatsNotifier, HomeStats>(
  () => HomeStatsNotifier(),
);

class HomeStatsNotifier extends Notifier<HomeStats> {
  @override
  HomeStats build() {
    return HomeStats();
  }

  Future<void> loadStats() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final customersRepo = ref.read(customersRepositoryProvider);
      final vehiclesRepo = ref.read(vehicleRepositoryProvider);
      final workOrdersRepo = ref.read(workOrderRepositoryProvider);

      final customers = await customersRepo.getCustomers();
      final vehicles = await vehiclesRepo.getVehicles();
      final workOrders = await workOrdersRepo.getWorkOrders();

      final openOrders = workOrders
          .where((wo) => wo.status.name == 'OPEN')
          .length;
      final completedOrders = workOrders
          .where((wo) => wo.status.name == 'COMPLETED')
          .length;
      state = HomeStats(
        totalCustomers: customers.length,
        totalVehicles: vehicles.length,
        totalWorkOrders: workOrders.length,
        openWorkOrders: openOrders,
        completedWorkOrders: completedOrders,
      );
    } catch (e) {
      state = HomeStats(
        totalCustomers: 0,
        totalVehicles: 0,
        totalWorkOrders: 0,
        openWorkOrders: 0,
        completedWorkOrders: 0,
      );
    }
  }

  Future<void> refreshStats() async {
    state = HomeStats();
    await loadStats();
  }
}

final userShopNameProvider = Provider<String>((ref) {
  // Usar el workshopProvider para obtener el nombre del taller
  final workshopAsync = ref.watch(workshopProvider);

  return workshopAsync.when(
    data: (workshop) => workshop.name.isNotEmpty ? workshop.name : 'Mi Taller',
    loading: () => 'Cargando...',
    error: (e, st) => 'Mi Taller',
  );
});

final userNameProvider = Provider<String>((ref) {
  final authState = ref.watch(authProvider);
  final name = authState.userSession?.user.name;
  return name ?? 'Usuario';
});
