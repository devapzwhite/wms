import 'package:flutter_test/flutter_test.dart';
import 'package:wms/config/enums/status_enum.dart';
import 'package:wms/domain/entities/work_order_item_entity.dart';
import 'package:wms/domain/entities/workorder_entity.dart';

void main() {
  group('WorkOrder', () {
    test('creates workOrder with required fields', () {
      final workOrder = WorkOrder(
        vehicleId: 1,
        status: WorkStatus.received,
      );

      expect(workOrder.vehicleId, 1);
      expect(workOrder.status, WorkStatus.received);
    });

    test('creates workOrder with all fields', () {
      final now = DateTime.now();
      final workOrder = WorkOrder(
        id: 1,
        shopId: 10,
        vehicleId: 1,
        createdBy: 5,
        checkIn: now,
        checkOut: now,
        initialDiagnosis: 'Cambio de aceite',
        laborEstimate: 100.0,
        partsEstimate: 50.0,
        status: WorkStatus.inProgress,
        notes: 'Notas de trabajo',
        createdAt: now,
      );

      expect(workOrder.id, 1);
      expect(workOrder.shopId, 10);
      expect(workOrder.vehicleId, 1);
      expect(workOrder.createdBy, 5);
      expect(workOrder.checkIn, now);
      expect(workOrder.checkOut, now);
      expect(workOrder.initialDiagnosis, 'Cambio de aceite');
      expect(workOrder.laborEstimate, 100.0);
      expect(workOrder.partsEstimate, 50.0);
      expect(workOrder.status, WorkStatus.inProgress);
      expect(workOrder.notes, 'Notas de trabajo');
      expect(workOrder.createdAt, now);
    });

    test('allows null optional fields', () {
      final workOrder = WorkOrder(
        vehicleId: 1,
        status: WorkStatus.received,
        id: null,
        shopId: null,
        createdBy: null,
        checkIn: null,
        checkOut: null,
        initialDiagnosis: null,
        laborEstimate: null,
        partsEstimate: null,
        notes: null,
        createdAt: null,
      );

      expect(workOrder.id, isNull);
      expect(workOrder.shopId, isNull);
      expect(workOrder.createdBy, isNull);
      expect(workOrder.checkIn, isNull);
      expect(workOrder.checkOut, isNull);
      expect(workOrder.initialDiagnosis, isNull);
      expect(workOrder.laborEstimate, isNull);
      expect(workOrder.partsEstimate, isNull);
      expect(workOrder.notes, isNull);
      expect(workOrder.createdAt, isNull);
    });
  });

  group('WorkOrderDetail', () {
    test('creates WorkOrderDetail with required fields', () {
      final workOrder = WorkOrder(
        vehicleId: 1,
        status: WorkStatus.received,
      );
      final workOrderDetail = WorkOrderDetail(
        workorder: workOrder,
        items: [],
      );

      expect(workOrderDetail.workorder, workOrder);
      expect(workOrderDetail.items, isEmpty);
    });

    test('creates WorkOrderDetail with items', () {
      final workOrder = WorkOrder(
        vehicleId: 1,
        status: WorkStatus.received,
      );
      final items = <WorkOrderItem>[];
      final workOrderDetail = WorkOrderDetail(
        workorder: workOrder,
        items: items,
      );

      expect(workOrderDetail.workorder.vehicleId, 1);
      expect(workOrderDetail.items, items);
    });
  });
}
