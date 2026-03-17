import 'package:wms/domain/entities/work_order_item_entity.dart';

/// Interfaz del datasource para gestionar ítems de órdenes de trabajo
abstract class WorkOrderItemDatasource {
  /// Obtiene todos los ítems de una orden de trabajo
  Future<List<WorkOrderItem>> getItemsByWorkOrderId(int workOrderId);
  
  /// Crea un nuevo ítem en una orden de trabajo
  Future<WorkOrderItem> createItem(WorkOrderItem item);
  
  /// Actualiza un ítem existente
  Future<WorkOrderItem> updateItem(int id, WorkOrderItem item);
  
  /// Elimina un ítem
  Future<void> deleteItem(int id);
}
