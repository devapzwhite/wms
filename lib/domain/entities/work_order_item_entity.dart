class WorkOrderItem {
  final int? id;
  final int? workOrderId;
  final String itemType;
  final String description;
  final int? quantity;
  final double? unitCost;
  final double? unitPrice;
  final String? beforePhoto;
  final String? afterPhoto;

  WorkOrderItem({
    this.id,
    this.workOrderId,
    required this.itemType,
    required this.description,
    this.quantity,
    this.unitCost,
    this.unitPrice,
    this.beforePhoto,
    this.afterPhoto,
  });
}
