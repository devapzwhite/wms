import 'package:wms/config/enums/status_enum.dart';

class WorkOrderItem {
  final int? id;
  final int workOrder;
  final WorkOrderItemType itenType;
  final String description;
  final int? quantity;
  final double? unitCost;
  final double? unitPrice;
  final String? beforePhoto;
  final String? afterPhoto;

  WorkOrderItem({
    this.id,
    required this.workOrder,
    required this.itenType,
    required this.description,
    this.quantity,
    this.unitCost,
    this.unitPrice,
    this.beforePhoto,
    this.afterPhoto,
  });
}
