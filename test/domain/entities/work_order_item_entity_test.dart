import 'package:flutter_test/flutter_test.dart';
import 'package:wms/domain/entities/work_order_item_entity.dart';

void main() {
  group('WorkOrderItem', () {
    test('creates WorkOrderItem with required fields', () {
      final item = WorkOrderItem(
        itemType: 'labor',
        description: 'Cambio de aceite',
      );

      expect(item.itemType, 'labor');
      expect(item.description, 'Cambio de aceite');
    });

    test('creates WorkOrderItem with all fields', () {
      final now = DateTime.now();
      final item = WorkOrderItem(
        id: 1,
        workOrderId: 10,
        itemType: 'labor',
        description: 'Cambio de aceite',
        quantity: 2,
        unitCost: 30.0,
        unitPrice: 50.0,
        beforePhoto: 'http://example.com/before.jpg',
        afterPhoto: 'http://example.com/after.jpg',
        createdAt: now,
      );

      expect(item.id, 1);
      expect(item.workOrderId, 10);
      expect(item.itemType, 'labor');
      expect(item.description, 'Cambio de aceite');
      expect(item.quantity, 2);
      expect(item.unitCost, 30.0);
      expect(item.unitPrice, 50.0);
      expect(item.beforePhoto, 'http://example.com/before.jpg');
      expect(item.afterPhoto, 'http://example.com/after.jpg');
      expect(item.createdAt, now);
    });

    test('allows null optional fields', () {
      final item = WorkOrderItem(
        itemType: 'labor',
        description: 'Cambio de aceite',
        id: null,
        workOrderId: null,
        quantity: null,
        unitCost: null,
        unitPrice: null,
        beforePhoto: null,
        afterPhoto: null,
        createdAt: null,
      );

      expect(item.id, isNull);
      expect(item.workOrderId, isNull);
      expect(item.quantity, isNull);
      expect(item.unitCost, isNull);
      expect(item.unitPrice, isNull);
      expect(item.beforePhoto, isNull);
      expect(item.afterPhoto, isNull);
      expect(item.createdAt, isNull);
    });
  });
}
