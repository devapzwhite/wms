import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/features/workorders/infrastructure/repository/work_order_item_repository_impl.dart';

/// Provider del repositorio de ítems de órdenes de trabajo
final workOrderItemRepositoryProvider = Provider<WorkOrderItemRepositoryImpl>((
  ref,
) {
  final datasource = ref.watch(workOrderItemDatasourceProvider);
  return WorkOrderItemRepositoryImpl(datasource: datasource);
});
