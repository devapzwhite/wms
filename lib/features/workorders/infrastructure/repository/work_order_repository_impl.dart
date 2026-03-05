import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/domain/entities/work_order_item_entity.dart';
import 'package:wms/domain/entities/workorder_entity.dart';
import 'package:wms/features/workorders/domain/datasource/work_order_datasource.dart';
import 'package:wms/features/workorders/domain/repository/work_order_repository.dart';
import 'package:wms/features/workorders/infrastructure/datasource/work_order_datasource_impl.dart';

class WorkOrderRepositoryImpl extends WorkOrderRepository {
  final WorkOrderDatasource workOrderDatasource;
  final Ref ref;

  WorkOrderRepositoryImpl({WorkOrderDatasource? datasource, required this.ref})
    : workOrderDatasource = datasource ?? WorkOrderDatasourceImpl(ref);
  @override
  Future<WorkOrderDetail> createWorkOrder(WorkOrderDetail workorderData) {
    return workOrderDatasource.createWorkOrder(workorderData);
  }

  @override
  Future<List<WorkOrderItem>> getItemsFromWorkOrderId(int id) {
    return workOrderDatasource.getItemsFromWorkOrderId(id);
  }

  @override
  Future<WorkOrderDetail> getWorkOrderDetail(int id) {
    return workOrderDatasource.getWorkOrderDetail(id);
  }

  @override
  Future<List<WorkOrder>> getListWorkOrders(int idVehicle) {
    return workOrderDatasource.getListWorkOrders(idVehicle);
  }
}
