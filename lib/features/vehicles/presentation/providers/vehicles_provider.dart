import 'package:wms/domain/entities/vehicle_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/features/vehicles/presentation/providers/vehicle_repository_provider.dart';

final vehiclesNotifierProvider =
    NotifierProvider<VehiclesNotifier, VehiclesState>(() => VehiclesNotifier());

class VehiclesNotifier extends Notifier<VehiclesState> {
  @override
  VehiclesState build() {
    return VehiclesState();
  }

  void loadVehicles() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    final vehicles = await ref.read(vehicleRepositoryProvider).getVehicles();
    state = state.copyWith(vehicles: vehicles, isLoading: false);
  }
}

class VehiclesState {
  final List<Vehicle> vehicles;
  final bool isLoading;
  VehiclesState({this.vehicles = const [], this.isLoading = false});

  VehiclesState copyWith({
    final List<Vehicle>? vehicles,
    final bool? isLoading,
  }) => VehiclesState(
    vehicles: vehicles ?? this.vehicles,
    isLoading: isLoading ?? this.isLoading,
  );
}
