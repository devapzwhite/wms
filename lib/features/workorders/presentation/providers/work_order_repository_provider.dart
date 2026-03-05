import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/features/workorders/infrastructure/datasource/work_order_datasource_impl.dart';
import 'package:wms/features/workorders/infrastructure/repository/work_order_repository_impl.dart';

final workOrderRepositoryProvider = Provider<WorkOrderRepositoryImpl>((ref) {
  return WorkOrderRepositoryImpl(
    ref: ref,
    datasource: WorkOrderDatasourceImpl(ref),
  );
});
