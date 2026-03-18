import 'package:image_picker/image_picker.dart';
import 'package:wms/domain/entities/work_order_item_entity.dart';

/// Interfaz del datasource para gestionar ítems de órdenes de trabajo
abstract class WorkOrderItemDatasource {
  /// Obtiene todos los ítems de una orden de trabajo
  Future<List<WorkOrderItem>> getItemsByWorkOrderId(int workOrderId);

  /// Crea un nuevo ítem en una orden de trabajo
  Future<WorkOrderItem> createItem(WorkOrderItem item);

  /// Crea un nuevo ítem con imágenes (multipart/form-data)
  Future<WorkOrderItem> createItemWithPhotos({
    required int workOrderId,
    required String itemType,
    required String description,
    int? quantity,
    double? unitCost,
    double? unitPrice,
    XFile? beforePhoto,
    XFile? afterPhoto,
  });

  /// Actualiza un ítem existente
  Future<WorkOrderItem> updateItem(int id, WorkOrderItem item);

  /// Actualiza un ítem existente con nuevas imágenes (multipart/form-data)
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
  });

  /// Elimina un ítem
  Future<void> deleteItem(int id);
}
