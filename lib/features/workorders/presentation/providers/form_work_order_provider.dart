import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/config/helpers/mappers.dart';
import 'package:wms/domain/entities/entities.dart';
import 'package:wms/features/vehicles/presentation/providers/vehicles_provider.dart';
import 'package:wms/features/workorders/errors/work_order_errors.dart';
import 'package:wms/features/workorders/presentation/providers/work_order_repository_provider.dart';

final workOrderFormProvider =
    NotifierProvider.family<WorkOrderFormNotifier, FormWorkOrderState, int>(
      WorkOrderFormNotifier.new,
    );

class WorkOrderFormNotifier extends Notifier<FormWorkOrderState> {
  final int idVehicle;

  WorkOrderFormNotifier(this.idVehicle);
  @override
  FormWorkOrderState build() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
    return FormWorkOrderState(vehicleId: idVehicle);
  }

  void _loadData() async {
    //TODO: Traer datos del vehiculo para mostrar datos
    // state = state.copyWith(vehicleId: idVehicle);
    final vehicle = await ref
        .read(vehiclesNotifierProvider.notifier)
        .getVehicle(idVehicle);
    if (ref.mounted) {
      state = state.copyWith(vehicle: vehicle);
    }
  }

  void cleanItem() {
    state = state.copyWith(
      type: 'DIAGNOSIS',
      description: '',
      quantity: 1,
      unitPrice: 0,
    );
  }

  void removeItem(int index) {
    final newList = List<WorkOrderItem>.from(state.items);
    newList.removeAt(index);
    state = state.copyWith(items: newList);
  }

  void onChangeStatus(String value) {
    final status = value;
    state = state.copyWith(status: status);
  }

  void onChangeInitialDiagnosis(String value) {
    final initialDiagnosis = value;
    state = state.copyWith(initialDiagnosis: initialDiagnosis);
  }

  void onChangeNotes(String value) {
    final notes = value;
    state = state.copyWith(notes: notes);
  }

  void onChangeTypeItem(String value) {
    final type = value;
    state = state.copyWith(type: type);
  }

  void onChangeDescription(String value) {
    final description = value;
    state = state.copyWith(description: description);
  }

  void onChangeQuantity(String value) {
    final quantity = int.tryParse(value) ?? 1;
    state = state.copyWith(quantity: quantity);
  }

  void onChangeUnitPrice(String value) {
    final unitPrice = double.tryParse(value) ?? 0;
    state = state.copyWith(unitPrice: unitPrice);
  }

  void addItem() {
    final isValid =
        true; //TODO: hacer metodo que devuelve bool para validar campos
    if (!isValid) return;
    final WorkOrderItem newItem = WorkOrderItem(
      itemType: state.type,
      description: state.description,
      quantity: state.quantity,
      unitPrice: state.unitPrice,
    );
    state = state.copyWith(items: [...state.items, newItem]);
  }

  void onSubmit() async {
    state = state.copyWith(onSubmit: true, isLoading: true);
    final isValid = true;
    if (!isValid) return;
    final workOrder = WorkOrder(
      vehicleId: state.vehicleId,
      status: Mappers.textToWorkOrderStatus(state.status),
      initialDiagnosis: state.initialDiagnosis,
      notes: state.notes,
    );
    try {
      final WorkOrderDetail detail = WorkOrderDetail(
        workorder: workOrder,
        items: state.items,
      );
      await ref.read(workOrderRepositoryProvider).createWorkOrder(detail);
      if (ref.mounted) {
        state = state.copyWith(isLoading: false);
      }
    } on WorkOrderErrors catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      print('error workOrder ${e.message}');
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      print('error workOrder ${e.toString()}');
    }
  }

  void clearResults() {
    state = state.copyWith(errorMessage: '', onSubmit: false, isLoading: false);
  }
}

class FormWorkOrderState {
  //-------Workorder
  final int vehicleId;
  final Vehicle? vehicle;
  final String status;
  final String initialDiagnosis;
  final String notes;
  //------items
  final String type;
  final String description;
  final int quantity;
  final double unitCost;
  final double unitPrice;
  final String? beforePhoto;
  final String? afterPhoto;
  final bool isValid;
  final List<WorkOrderItem> items;
  final String errorMessage;
  final bool onSubmit;
  final bool isLoading;

  FormWorkOrderState({
    required this.vehicleId,
    this.vehicle,
    this.status = 'RECEIVED',
    this.initialDiagnosis = '',
    this.notes = '',
    this.type = 'DIAGNOSIS',
    this.description = '',
    this.quantity = 1,
    this.unitCost = 0,
    this.unitPrice = 0,
    this.beforePhoto,
    this.afterPhoto,
    this.isValid = false,
    this.items = const <WorkOrderItem>[],
    this.errorMessage = '',
    this.onSubmit = false,
    this.isLoading = false,
  });
  FormWorkOrderState copyWith({
    int? vehicleId,
    Vehicle? vehicle,
    String? status,
    String? initialDiagnosis,
    String? notes,
    String? type,
    String? description,
    int? quantity,
    double? unitCost,
    double? unitPrice,
    String? beforePhoto,
    String? afterPhoto,
    bool? isValid,
    List<WorkOrderItem>? items,
    String? errorMessage,
    bool? onSubmit,
    bool? isLoading,
  }) {
    return FormWorkOrderState(
      vehicleId: vehicleId ?? this.vehicleId,
      vehicle: vehicle ?? this.vehicle,
      status: status ?? this.status,
      initialDiagnosis: initialDiagnosis ?? this.initialDiagnosis,
      notes: notes ?? this.notes,
      type: type ?? this.type,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
      unitPrice: unitPrice ?? this.unitPrice,
      beforePhoto: beforePhoto ?? this.beforePhoto,
      afterPhoto: afterPhoto ?? this.afterPhoto,
      isValid: isValid ?? this.isValid,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
      onSubmit: onSubmit ?? this.onSubmit,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
