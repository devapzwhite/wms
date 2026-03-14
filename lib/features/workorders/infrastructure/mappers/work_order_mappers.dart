import 'package:wms/config/helpers/mappers.dart';
import 'package:wms/domain/entities/entities.dart';

class WorkOrderMappers {
  static WorkOrder dataMapToEntityWorkOrder(Map<String, dynamic> data) {
    return WorkOrder(
      id: data['id'],
      shopId: data['shop_id'],
      vehicleId: data['vehicle_id'],
      createdBy: data['created_by'],
      checkIn: data['check_in_at'] != null
          ? DateTime.parse(data['check_in_at'])
          : null,
      checkOut: data['check_out_at'] != null
          ? DateTime.parse(data['check_out_at'])
          : null,
      initialDiagnosis: data['initial_diagnosis'],
      laborEstimate: double.tryParse(data['labor_estimate'] ?? '0'),
      partsEstimate: double.tryParse(data['parts_estimate'] ?? '0'),
      status: Mappers.textToWorkOrderStatus(data['status']),
      notes: data['notes'],
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : null,
    );
  }

  static Map<String, dynamic> entityWorkOrderToData(WorkOrder workOrder) {
    return {
      "vehicle_id": workOrder.vehicleId,
      "initial_diagnosis": workOrder.initialDiagnosis,
      "status": workOrder.status.label,
      "notes": workOrder.notes,
    };
  }

  static Map<String, dynamic> entityWorkOrderDetailsToDataMap(
    WorkOrderDetail workOrderDetail,
  ) {
    final Map<String, dynamic> workOrderData = {
      "vehicle_id": workOrderDetail.workorder.vehicleId,
      "initial_diagnosis": workOrderDetail.workorder.initialDiagnosis,
      "status": workOrderDetail.workorder.status.label,
      "notes": workOrderDetail.workorder.notes,
    };
    final items = <Map<String, dynamic>>[];
    if (workOrderDetail.items.isNotEmpty) {
      for (final item in workOrderDetail.items) {
        final Map<String, dynamic> itemData = {
          "item_type": item.itemType,
          "description": item.description,
          "quantity": item.quantity ?? 1,
          // "unit_cost":,
          "unit_price": item.unitPrice ?? 0,
          // "before_photo":"",
          // "after_photo":""
        };
        items.add(itemData);
      }
    }
    workOrderData['workorder_items'] = items;

    return workOrderData;
  }

  static WorkOrderDetail dataMapWorkOrderDetailsToEntityWorkOrder(
    Map<String, dynamic> data,
  ) {
    final List<dynamic> items = data['workorder_items'];
    final WorkOrder workOrder = WorkOrder(
      id: data['id'],
      vehicleId: data['vehicle_id'],
      status: Mappers.textToWorkOrderStatus(data['status']),
      checkIn: DateTime.tryParse(data['check_in_at']),
      initialDiagnosis: data['initial_diagnosis'],
      notes: data['notes'],
      laborEstimate: double.tryParse(data['labor_estimate']),
      checkOut: data['check_out_at'] != null
          ? DateTime.parse(data['check_out_at'])
          : null,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : null,
    );
    final WorkOrderDetail result = WorkOrderDetail(
      workorder: workOrder,
      items: List.from(
        items.map(
          (item) => WorkOrderItem(
            id: item['id'],
            itemType: item['item_type'],
            description: item['description'],
            quantity: item['quantity'],
            unitPrice: double.tryParse(item['unit_price']),
            createdAt: item['created_at'] != null
                ? DateTime.parse(item['created_at'])
                : null,
            // unitCost: item['unit_cost'],
            // beforePhoto: item['before_photo'],
            // afterPhoto: item['after_photo'],
          ),
        ),
      ),
    );
    return result;
  }
}
