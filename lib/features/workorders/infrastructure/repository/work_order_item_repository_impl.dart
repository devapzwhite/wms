import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wms/domain/entities/work_order_item_entity.dart';
import 'package:wms/features/workorders/domain/datasource/work_order_item_datasource.dart';
import 'package:wms/features/workorders/domain/repository/work_order_item_repository.dart';
import 'package:wms/features/workorders/infrastructure/datasource/work_order_item_datasource_impl.dart';

/// Provider del datasource de ítems de órdenes de trabajo
final workOrderItemDatasourceProvider = Provider<WorkOrderItemDatasourceImpl>((
  ref,
) {
  return WorkOrderItemDatasourceImpl(ref);
});

/// Implementación del repositorio de ítems de órdenes de trabajo
class WorkOrderItemRepositoryImpl implements WorkOrderItemRepository {
  final WorkOrderItemDatasource datasource;

  WorkOrderItemRepositoryImpl({required this.datasource});

  @override
  Future<List<WorkOrderItem>> getItemsByWorkOrderId(int workOrderId) {
    return datasource.getItemsByWorkOrderId(workOrderId);
  }

  @override
  Future<WorkOrderItem> createItem(WorkOrderItem item) {
    return datasource.createItem(item);
  }

  @override
  Future<WorkOrderItem> createItemWithPhotos({
    required int workOrderId,
    required String itemType,
    required String description,
    int? quantity,
    double? unitCost,
    double? unitPrice,
    XFile? beforePhoto,
    XFile? afterPhoto,
  }) {
    return datasource.createItemWithPhotos(
      workOrderId: workOrderId,
      itemType: itemType,
      description: description,
      quantity: quantity,
      unitCost: unitCost,
      unitPrice: unitPrice,
      beforePhoto: beforePhoto,
      afterPhoto: afterPhoto,
    );
  }

  @override
  Future<WorkOrderItem> updateItem(int id, WorkOrderItem item) {
    return datasource.updateItem(id, item);
  }

  @override
  Future<WorkOrderItem> updateItemWithPhotos({
    required int id,
    required int workOrderId,
    required String itemType,
    required String description,
    int? quantity,
    double? unitCost,
    double? unitPrice,
    XFile? beforePhoto,
    XFile? afterPhoto,
  }) {
    return datasource.updateItemWithPhotos(
      id: id,
      workOrderId: workOrderId,
      itemType: itemType,
      description: description,
      quantity: quantity,
      unitCost: unitCost,
      unitPrice: unitPrice,
      beforePhoto: beforePhoto,
      afterPhoto: afterPhoto,
    );
  }

  @override
  Future<void> deleteItem(int id) {
    return datasource.deleteItem(id);
  }
}
