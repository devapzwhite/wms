import 'package:flutter_test/flutter_test.dart';
import 'package:wms/config/enums/status_enum.dart';
import 'package:wms/domain/entities/work_order_item_entity.dart';
import 'package:wms/domain/entities/workorder_entity.dart';
import 'package:wms/features/workorders/infrastructure/mappers/work_order_mappers.dart';

void main() {
  group('WorkOrderMappers - entityWorkOrderDetailsToDataMap', () {
    test('convierte WorkOrderDetail a Map correctamente', () {
      final workOrderDetail = WorkOrderDetail(
        workorder: WorkOrder(
          id: 1,
          vehicleId: 10,
          status: WorkStatus.received,
          initialDiagnosis: 'Diagnóstico inicial',
          notes: 'Notas de prueba',
        ),
        items: [],
      );

      final result = WorkOrderMappers.entityWorkOrderDetailsToDataMap(workOrderDetail);

      expect(result['vehicle_id'], 10);
      expect(result['initial_diagnosis'], 'Diagnóstico inicial');
      expect(result['status'], 'RECEIVED');
      expect(result['notes'], 'Notas de prueba');
      expect(result['workorder_items'], isEmpty);
    });

    test('incluye items cuando no están vacíos', () {
      final workOrderDetail = WorkOrderDetail(
        workorder: WorkOrder(
          id: 1,
          vehicleId: 10,
          status: WorkStatus.inProgress,
          initialDiagnosis: 'Diagnóstico inicial',
        ),
        items: [
          WorkOrderItem(
            id: 1,
            itemType: 'labor',
            description: 'Cambio de aceite',
            quantity: 1,
            unitPrice: 50.0,
          ),
        ],
      );

      final result = WorkOrderMappers.entityWorkOrderDetailsToDataMap(workOrderDetail);

      expect(result['workorder_items'], isNotEmpty);
      expect((result['workorder_items'] as List).length, 1);
    });

    test('items usan quantity por defecto 1 si es null', () {
      final workOrderDetail = WorkOrderDetail(
        workorder: WorkOrder(
          id: 1,
          vehicleId: 10,
          status: WorkStatus.received,
        ),
        items: [
          WorkOrderItem(
            itemType: 'labor',
            description: 'Cambio de aceite',
            quantity: null,
            unitPrice: 50.0,
          ),
        ],
      );

      final result = WorkOrderMappers.entityWorkOrderDetailsToDataMap(workOrderDetail);
      final items = result['workorder_items'] as List;

      expect(items[0]['quantity'], 1);
    });

    test('itemsusan unitPrice por defecto 0 si es null', () {
      final workOrderDetail = WorkOrderDetail(
        workorder: WorkOrder(
          id: 1,
          vehicleId: 10,
          status: WorkStatus.received,
        ),
        items: [
          WorkOrderItem(
            itemType: 'labor',
            description: 'Cambio de aceite',
            quantity: 1,
            unitPrice: null,
          ),
        ],
      );

      final result = WorkOrderMappers.entityWorkOrderDetailsToDataMap(workOrderDetail);
      final items = result['workorder_items'] as List;

      expect(items[0]['unit_price'], 0);
    });
  });

  group('WorkOrderMappers - dataMapWorkOrderDetailsToEntityWorkOrder', () {
    test('convierte Map a WorkOrderDetail correctamente', () {
      final data = {
        'id': 1,
        'vehicle_id': 10,
        'status': 'RECEIVED',
        'initial_diagnosis': 'Diagnóstico inicial',
        'notes': 'Notas de prueba',
        'labor_estimate': '100.50',
        'check_in_at': '2024-06-15T10:00:00Z',
        'check_out_at': null,
        'created_at': '2024-06-15T10:00:00Z',
        'workorder_items': [],
      };

      final result = WorkOrderMappers.dataMapWorkOrderDetailsToEntityWorkOrder(data);

      expect(result.workorder.id, 1);
      expect(result.workorder.vehicleId, 10);
      expect(result.workorder.status, WorkStatus.received);
      expect(result.workorder.initialDiagnosis, 'Diagnóstico inicial');
      expect(result.workorder.notes, 'Notas de prueba');
      expect(result.workorder.laborEstimate, 100.50);
      expect(result.items, isEmpty);
    });

    test('parsea workorder_items correctamente', () {
      final data = {
        'id': 1,
        'vehicle_id': 10,
        'status': 'RECEIVED',
        'initial_diagnosis': 'Diagnóstico inicial',
        'notes': 'notas',
        'labor_estimate': '100.50',
        'check_in_at': '2024-06-15T10:00:00Z',
        'check_out_at': '2024-06-20T10:00:00Z',
        'created_at': '2024-06-15T10:00:00Z',
        'workorder_items': [
          {
            'id': 1,
            'item_type': 'labor',
            'description': 'Cambio de aceite',
            'quantity': 2,
            'unit_price': '50.00',
            'created_at': '2024-06-15T10:00:00Z',
          },
        ],
      };

      final result = WorkOrderMappers.dataMapWorkOrderDetailsToEntityWorkOrder(data);

      expect(result.items.length, 1);
      expect(result.items[0].id, 1);
      expect(result.items[0].itemType, 'labor');
      expect(result.items[0].description, 'Cambio de aceite');
      expect(result.items[0].quantity, 2);
      expect(result.items[0].unitPrice, 50.0);
    });

  });
}
