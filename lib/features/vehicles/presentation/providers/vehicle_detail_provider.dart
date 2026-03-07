import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/domain/entities/entities.dart';
import 'package:wms/features/vehicles/presentation/providers/vehicle_repository_provider.dart';

final vehiclesDetailsNotifierProvider = NotifierProvider.autoDispose
    .family<VehicleDetailsNotifier, VehicleDetailState, int>(
      VehicleDetailsNotifier.new,
    );

class VehicleDetailsNotifier extends Notifier<VehicleDetailState> {
  final int idVehicle;

  VehicleDetailsNotifier(this.idVehicle);

  @override
  VehicleDetailState build() {
    WidgetsBinding.instance.addPostFrameCallback((_) => getData());
    return VehicleDetailState();
  }

  void getData() async {
    state = state.copyWith(isLoading: true);
    try {
      final Vehicle vehicleDetails = await ref
          .read(vehicleRepositoryProvider)
          .getVehicleDetailById(idVehicle);

      final Vehicle vehicle = Vehicle(
        id: vehicleDetails.id,
        shopId: vehicleDetails.shopId,
        customerId: vehicleDetails.customerId,
        vehicleType: vehicleDetails.vehicleType,
        plate: vehicleDetails.plate,
        brand: vehicleDetails.brand,
        model: vehicleDetails.model,
        year: vehicleDetails.year,
        photoUrl: vehicleDetails.photoUrl,
        createAt: vehicleDetails.createAt,
      );

      if (!ref.mounted) return;
      if (vehicleDetails.orders.isNotEmpty) {
        vehicleDetails.orders.sort(
          (a, b) => b.createdAt!.compareTo(a.createdAt!),
        );
      }
      state = state.copyWith(
        vehicle: vehicle,
        customer: vehicleDetails.customer,
        orders: vehicleDetails.orders,
        isLoading: false,
      );
    } catch (e) {
      //TODO: mostrar el error
      print(e.toString());
    }
  }
}

class VehicleDetailState {
  final Customer? customer;
  final Vehicle? vehicle;
  final List<WorkOrder> orders;
  final bool isLoading;

  VehicleDetailState({
    this.customer,
    this.vehicle,
    this.orders = const <WorkOrder>[],
    this.isLoading = false,
  });
  VehicleDetailState copyWith({
    Customer? customer,
    Vehicle? vehicle,
    List<WorkOrder>? orders,
    bool? isLoading,
  }) => VehicleDetailState(
    customer: customer ?? this.customer,
    vehicle: vehicle ?? this.vehicle,
    orders: orders ?? this.orders,
    isLoading: isLoading ?? this.isLoading,
  );
}
