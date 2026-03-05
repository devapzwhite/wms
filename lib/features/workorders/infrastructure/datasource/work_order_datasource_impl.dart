import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/domain/entities/work_order_item_entity.dart';
import 'package:wms/domain/entities/workorder_entity.dart';
import 'package:wms/features/auth/presentation/providers/auth_provider.dart';
import 'package:wms/features/workorders/domain/datasource/work_order_datasource.dart';
import 'package:wms/features/workorders/errors/work_order_errors.dart';
import 'package:wms/features/workorders/infrastructure/mappers/work_order_mappers.dart';

class WorkOrderDatasourceImpl extends WorkOrderDatasource {
  final Ref ref;

  WorkOrderDatasourceImpl(this.ref);

  final dio = Dio(BaseOptions(baseUrl: '${dotenv.get('API_URL')}/workorders'));

  String _getToken() {
    final bool expired = ref.read(authProvider.notifier).isTokenExpired();
    if (expired) {
      throw WorkOrderErrors(message: 'Token expirado');
    }
    return ref.read(authProvider).userSession!.token.accessToken;
  }

  @override
  Future<WorkOrderDetail> createWorkOrder(WorkOrderDetail workorderData) async {
    final Map<String, dynamic> data =
        WorkOrderMappers.entityWorkOrderDetailsToDataMap(workorderData);

    final response = await dio.post(
      '/',
      options: Options(headers: {'Authorization': 'Bearer ${_getToken()}'}),
      data: data,
    );
    final result = WorkOrderMappers.dataMapWorkOrderDetailsToEntityWorkOrder(
      response.data,
    );
    try {
      print('Registro Exitoso!');
      return result;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw WorkOrderErrors(message: 'Este vehiculo no existe!');
      }
      throw WorkOrderErrors(message: 'error en dio desconocido ${e.message}');
    } catch (e) {
      throw WorkOrderErrors(message: 'error desconocido ${e.toString()}');
    }
  }

  @override
  Future<List<WorkOrderItem>> getItemsFromWorkOrderId(int id) {
    // TODO: implement getItemsFromWorkOrderId
    throw UnimplementedError();
  }

  @override
  Future<List<WorkOrder>> getListWorkOrders(int idVehicle) {
    // TODO: implement getListWorkOrders
    throw UnimplementedError();
  }

  @override
  Future<WorkOrderDetail> getWorkOrderDetail(int id) {
    // TODO: implement getWorkOrderDetail
    throw UnimplementedError();
  }
}
