import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/config/helpers/mappers.dart';
import 'package:wms/domain/entities/entities.dart';
import 'package:wms/features/customers/presentation/providers/customers_provider.dart';
import 'package:wms/features/vehicles/presentation/providers/vehicles_provider.dart';
import 'package:wms/features/workorders/errors/work_order_errors.dart';
import 'package:wms/features/workorders/presentation/providers/work_order_repository_provider.dart';

final updateWorkOrderProvider =
    NotifierProvider.family<UpdateWorkOrderNotifier, UpdateWorkOrderState, int>(
      UpdateWorkOrderNotifier.new,
    );

class UpdateWorkOrderNotifier extends Notifier<UpdateWorkOrderState> {
  final int workOrderId;

  UpdateWorkOrderNotifier(this.workOrderId);

  @override
  UpdateWorkOrderState build() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
    return UpdateWorkOrderState(workOrderId: workOrderId);
  }

  void _loadData() async {
    state = state.copyWith(isLoading: true);
    try {
      final repository = ref.read(workOrderRepositoryProvider);
      final detail = await repository.getWorkOrderDetail(workOrderId);
      final workOrder = detail.workorder;

      // Obtener vehículo: usa el método existente que busca en cache primero
      final vehicleData = await ref
          .read(vehiclesNotifierProvider.notifier)
          .getVehicle(workOrder.vehicleId);

      // Obtener cliente: usa el método existente que busca en cache primero
      Customer? customerData;
      if (vehicleData != null && vehicleData.customerId != 0) {
        customerData = await ref
            .read(customerNotifierProvider.notifier)
            .getCustomerToUpdate(vehicleData.customerId);
      }

      if (ref.mounted) {
        state = state.copyWith(
          workOrder: workOrder,
          vehicle: vehicleData,
          customer: customerData,
          status: workOrder.status.label,
          initialDiagnosis: workOrder.initialDiagnosis ?? '',
          notes: workOrder.notes ?? '',
          items: detail.items,
          isLoading: false,
        );
      }
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
    }
  }

  void onChangeStatus(String value) {
    state = state.copyWith(status: value);
  }

  void onChangeInitialDiagnosis(String value) {
    state = state.copyWith(initialDiagnosis: value);
  }

  void onChangeNotes(String value) {
    state = state.copyWith(notes: value);
  }

  void addItem(WorkOrderItem item) {
    state = state.copyWith(items: [...state.items, item]);
  }

  void removeItem(int index) {
    final newList = List<WorkOrderItem>.from(state.items);
    newList.removeAt(index);
    state = state.copyWith(items: newList);
  }

  void updateItem(int index, WorkOrderItem item) {
    final newList = List<WorkOrderItem>.from(state.items);
    newList[index] = item;
    state = state.copyWith(items: newList);
  }

  bool _validate() {
    if (state.status.isEmpty) {
      state = state.copyWith(errorMessage: 'Seleccione un estado');
      return false;
    }
    return true;
  }

  void onSubmit() async {
    if (!_validate()) return;

    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final updatedWorkOrder = WorkOrder(
        id: workOrderId,
        vehicleId: state.workOrder!.vehicleId,
        status: Mappers.textToWorkOrderStatus(state.status),
        initialDiagnosis: state.initialDiagnosis.isEmpty
            ? null
            : state.initialDiagnosis,
        notes: state.notes.isEmpty ? null : state.notes,
        createdAt: state.workOrder!.createdAt,
        checkIn: state.workOrder!.checkIn,
        checkOut: state.workOrder!.checkOut,
        laborEstimate: state.workOrder!.laborEstimate,
        partsEstimate: state.workOrder!.partsEstimate,
        shopId: state.workOrder!.shopId,
        createdBy: state.workOrder!.createdBy,
      );

      await ref
          .read(workOrderRepositoryProvider)
          .updateWorkOrder(workOrderId, updatedWorkOrder);

      if (ref.mounted) {
        state = state.copyWith(isLoading: false, isSuccess: true);
      }
    } on WorkOrderErrors catch (e) {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false, errorMessage: e.message);
      }
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: '');
  }
}

class UpdateWorkOrderState {
  final int workOrderId;
  final WorkOrder? workOrder;
  final Vehicle? vehicle;
  final Customer? customer;
  final String status;
  final String initialDiagnosis;
  final String notes;
  final List<WorkOrderItem> items;
  final bool isLoading;
  final String errorMessage;
  final bool isSuccess;

  UpdateWorkOrderState({
    required this.workOrderId,
    this.workOrder,
    this.vehicle,
    this.customer,
    this.status = 'RECEIVED',
    this.initialDiagnosis = '',
    this.notes = '',
    this.items = const [],
    this.isLoading = false,
    this.errorMessage = '',
    this.isSuccess = false,
  });

  UpdateWorkOrderState copyWith({
    int? workOrderId,
    WorkOrder? workOrder,
    Vehicle? vehicle,
    Customer? customer,
    String? status,
    String? initialDiagnosis,
    String? notes,
    List<WorkOrderItem>? items,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return UpdateWorkOrderState(
      workOrderId: workOrderId ?? this.workOrderId,
      workOrder: workOrder ?? this.workOrder,
      vehicle: vehicle ?? this.vehicle,
      customer: customer ?? this.customer,
      status: status ?? this.status,
      initialDiagnosis: initialDiagnosis ?? this.initialDiagnosis,
      notes: notes ?? this.notes,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
