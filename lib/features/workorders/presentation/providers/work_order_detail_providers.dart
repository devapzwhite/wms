import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/domain/entities/entities.dart';
import 'package:wms/features/workorders/presentation/providers/work_order_repository_provider.dart';

final workOrderNotifierProvider =
    NotifierProvider.family<WorkOrderDetailNotifier, WorkOrderDetailState, int>(
      WorkOrderDetailNotifier.new,
    );

class WorkOrderDetailNotifier extends Notifier<WorkOrderDetailState> {
  final int workOrderId;

  WorkOrderDetailNotifier(this.workOrderId);
  @override
  WorkOrderDetailState build() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
    return WorkOrderDetailState();
  }

  void _loadData() async {
    state = state.copyWith(isLoading: true);
    try {
      final repository = ref.read(workOrderRepositoryProvider);
      final workOrderDetail = await repository.getWorkOrderDetail(workOrderId);

      if (ref.mounted) {
        state = state.copyWith(
          workOrder: workOrderDetail.workorder,
          workOrderItem: workOrderDetail.items,
          isLoading: false,
        );
      }
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
    }
  }

  void refresh() {
    _loadData();
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
