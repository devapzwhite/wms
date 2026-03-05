import 'package:wms/config/enums/status_enum.dart';

class Mappers {
  static WorkOrderItemType textToWorkOrderItemType(String texto) {
    switch (texto) {
      case 'DIAGNOSIS':
        return WorkOrderItemType.diagnosis;
      case 'LABOR':
        return WorkOrderItemType.labor;
      case 'PART':
        return WorkOrderItemType.part;
      default:
        return WorkOrderItemType.diagnosis;
    }
  }

  static WorkStatus textToWorkOrderStatus(String texto) {
    switch (texto) {
      case 'RECEIVED':
        return WorkStatus.received;
      case 'DIAGNOSIS':
        return WorkStatus.diagnosis;
      case 'WAITING_APPROVAL':
        return WorkStatus.waitingAproval;
      case 'APPROVED':
        return WorkStatus.aproved;
      case 'IN_PROGRESS':
        return WorkStatus.inProgress;
      case 'WAITING_PARTS':
        return WorkStatus.waitingParts;
      case 'REPAIRED':
        return WorkStatus.reapired;
      case 'READY_FOR_DELIVERY':
        return WorkStatus.readyForDelivery;
      case 'COMPLETED':
        return WorkStatus.completed;
      case 'CANCELLED':
        return WorkStatus.canceled;
      default:
        return WorkStatus.received;
    }
  }
}
