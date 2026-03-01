import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/config/enums/status_enum.dart';
import 'package:wms/domain/entities/entities.dart';

final workOrderFormProvider = NotifierProvider.family
    .autoDispose<WorkOrderFormNotifier, FormWorkOrderState, int>(
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

  void _loadData() {
    //TODO: Traer datos del vehiculo para mostrar datos
    state = state.copyWith(vehicleId: idVehicle);
  }
}

class FormWorkOrderState {
  //-------Workorder
  final int vehicleId;
  final WorkStatus status;
  final String initialDiagnosis;
  final String notes;
  //------items
  final WorkOrderItemType type;
  final String description;
  final int quantity;
  final double unitCost;
  final double unitPrice;
  final String? beforePhoto;
  final String? afterPhoto;
  final List<WorkOrderItem> items;

  FormWorkOrderState({
    required this.vehicleId,
    this.status = WorkStatus.received,
    this.initialDiagnosis = '',
    this.notes = '',
    this.type = WorkOrderItemType.diagnosis,
    this.description = '',
    this.quantity = 1,
    this.unitCost = 0,
    this.unitPrice = 0,
    this.beforePhoto,
    this.afterPhoto,
    this.items = const <WorkOrderItem>[],
  });
  FormWorkOrderState copyWith({
    int? vehicleId,
    WorkStatus? status,
    String? initialDiagnosis,
    String? notes,
    WorkOrderItemType? type,
    String? description,
    int? quantity,
    double? unitCost,
    double? unitPrice,
    String? beforePhoto,
    String? afterPhoto,
    List<WorkOrderItem>? items,
  }) {
    return FormWorkOrderState(
      vehicleId: vehicleId ?? this.vehicleId,
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
      items: items ?? this.items,
    );
  }
}
