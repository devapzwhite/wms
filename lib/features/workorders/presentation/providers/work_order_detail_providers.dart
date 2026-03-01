import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/domain/entities/entities.dart';

final workOrderNotifierProvider =
    NotifierProvider.family<WorkOrderDetailNotifier, WorkOrderDetailState, int>(
      WorkOrderDetailNotifier.new,
    );

class WorkOrderDetailNotifier extends Notifier<WorkOrderDetailState> {
  final int workOrderId;

  WorkOrderDetailNotifier(this.workOrderId);
  @override
  WorkOrderDetailState build() {
    _loadData(); //ojo abajo retorna un state vacio
    return WorkOrderDetailState();
  }

  void _loadData() async {
    //TODO: que cargue los datos con el workorder id
  }
}

class WorkOrderDetailState {
  final Customer? customer;
  final Vehicle? vehicle;
  final WorkOrder? workOrder;
  final List<WorkOrderItem> workOrderItem;
  final bool isLoading;
  final String errorMessage;
  final bool onSubmit;

  WorkOrderDetailState({
    this.customer,
    this.vehicle,
    this.workOrder,
    this.workOrderItem = const <WorkOrderItem>[],
    this.isLoading = false,
    this.errorMessage = '',
    this.onSubmit = false,
  });

  WorkOrderDetailState copyWith({
    final Customer? customer,
    final Vehicle? vehicle,
    final WorkOrder? workOrder,
    final List<WorkOrderItem>? workOrderItem,
    final bool? isLoading,
    final String? errorMessage,
    final bool? onSubmit,
  }) => WorkOrderDetailState(
    customer: customer ?? this.customer,
    vehicle: vehicle ?? this.vehicle,
    workOrder: workOrder ?? this.workOrder,
    workOrderItem: workOrderItem ?? this.workOrderItem,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage ?? this.errorMessage,
    onSubmit: onSubmit ?? this.onSubmit,
  );
}
