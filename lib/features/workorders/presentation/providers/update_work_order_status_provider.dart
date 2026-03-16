import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/config/enums/status_enum.dart';
import 'package:wms/domain/entities/workorder_entity.dart';
import 'package:wms/features/workorders/presentation/providers/work_order_repository_provider.dart';

class UpdateWorkOrderStatusNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> updateStatus(int workOrderId, WorkStatus newStatus) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(workOrderRepositoryProvider);
      final detail = await repository.getWorkOrderDetail(workOrderId);
      final updatedWorkOrder = WorkOrder(
        id: detail.workorder.id,
        shopId: detail.workorder.shopId,
        vehicleId: detail.workorder.vehicleId,
        createdBy: detail.workorder.createdBy,
        checkIn: detail.workorder.checkIn,
        checkOut: detail.workorder.checkOut,
        initialDiagnosis: detail.workorder.initialDiagnosis,
        laborEstimate: detail.workorder.laborEstimate,
        partsEstimate: detail.workorder.partsEstimate,
        status: newStatus,
        notes: detail.workorder.notes,
        createdAt: detail.workorder.createdAt,
      );
      await repository.updateWorkOrder(workOrderId, updatedWorkOrder);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final updateWorkOrderStatusProvider =
    AsyncNotifierProvider<UpdateWorkOrderStatusNotifier, void>(
  UpdateWorkOrderStatusNotifier.new,
);
