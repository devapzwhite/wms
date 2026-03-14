import 'package:flutter_test/flutter_test.dart';
import 'package:wms/config/enums/status_enum.dart';

void main() {
  group('WorkStatus', () {
    test('has correct labels', () {
      expect(WorkStatus.received.label, 'RECEIVED');
      expect(WorkStatus.diagnosis.label, 'DIAGNOSIS');
      expect(WorkStatus.waitingAproval.label, 'WAITING_APPROVAL');
      expect(WorkStatus.aproved.label, 'APPROVED');
      expect(WorkStatus.inProgress.label, 'IN_PROGRESS');
      expect(WorkStatus.waitingParts.label, 'WAITING_PARTS');
      expect(WorkStatus.reapired.label, 'REPAIRED');
      expect(WorkStatus.readyForDelivery.label, 'READY_FOR_DELIVERY');
      expect(WorkStatus.completed.label, 'COMPLETED');
      expect(WorkStatus.canceled.label, 'CANCELLED');
    });

    test('has correct nombres', () {
      expect(WorkStatus.received.nombre, 'RECIBIDO');
      expect(WorkStatus.diagnosis.nombre, 'DIAGNÓSTICO');
      expect(WorkStatus.waitingAproval.nombre, 'ESPERANDO APROBACIÓN');
      expect(WorkStatus.aproved.nombre, 'APROBADO');
      expect(WorkStatus.inProgress.nombre, 'EN CURSO');
      expect(WorkStatus.waitingParts.nombre, 'ESPERANDO PIEZAS');
      expect(WorkStatus.reapired.nombre, 'REPARADO');
      expect(WorkStatus.readyForDelivery.nombre, 'LISTO PARA ENTREGA');
      expect(WorkStatus.completed.nombre, 'COMPLETO');
      expect(WorkStatus.canceled.nombre, 'CANCELADO');
    });

    test('has 10 status values', () {
      expect(WorkStatus.values.length, 10);
    });
  });

  group('WorkOrderItemType', () {
    test('has correct labels', () {
      expect(WorkOrderItemType.diagnosis.label, 'DIAGNOSIS');
      expect(WorkOrderItemType.labor.label, 'LABOR');
      expect(WorkOrderItemType.part.label, 'PART');
    });

    test('has correct nombres', () {
      expect(WorkOrderItemType.diagnosis.nombre, 'diagnostico');
      expect(WorkOrderItemType.labor.nombre, 'mano de obra');
      expect(WorkOrderItemType.part.nombre, 'pieza');
    });

    test('has 3 item type values', () {
      expect(WorkOrderItemType.values.length, 3);
    });
  });
}
