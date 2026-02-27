import 'package:wms/domain/entities/vehicle_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/features/vehicles/errors/vehicle_errors.dart';
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

  Future<Vehicle?> getVehicle(int id) async {
    final repository = ref.read(vehicleRepositoryProvider);
    Vehicle? vehicle = state.vehicles.cast<Vehicle?>().firstWhere(
      (vehicle) => vehicle!.id == id,
      orElse: () => null,
    );
    if (vehicle != null) {
      return vehicle;
    }
    try {
      vehicle = await repository.getVehicleById(id);
      if (!ref.mounted) return null;
      state = state.copyWith(errorMessage: '');
      return vehicle;
    } on VehicleErrors catch (e) {
      if (!ref.mounted) return null;
      state = state.copyWith(errorMessage: e.message);
      return null;
    } catch (e) {
      if (!ref.mounted) return null;
      state = state.copyWith(errorMessage: e.toString());
      return null;
    }
  }

  void clearErrors() {
    state = state.copyWith(errorMessage: '');
  }
}

class VehiclesState {
  final List<Vehicle> vehicles;
  final bool isLoading;
  final String? errorMessage;
  VehiclesState({
    this.vehicles = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  VehiclesState copyWith({
    final List<Vehicle>? vehicles,
    final bool? isLoading,
    final String? errorMessage,
  }) => VehiclesState(
    vehicles: vehicles ?? this.vehicles,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
