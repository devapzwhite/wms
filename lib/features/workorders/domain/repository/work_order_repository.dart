import 'package:wms/domain/entities/entities.dart';

abstract class WorkOrderRepository {
  Future<WorkOrderDetail> createWorkOrder(WorkOrderDetail workorderData);
  Future<WorkOrderDetail> getWorkOrderDetail(int id);
  Future<List<WorkOrder>> getListWorkOrders(int idVehicle);
  Future<List<WorkOrderItem>> getItemsFromWorkOrderId(int id);
  Future<List<WorkOrder>> getWorkOrders();
  Future<WorkOrder> updateWorkOrder(int id, WorkOrder workOrder);
}
