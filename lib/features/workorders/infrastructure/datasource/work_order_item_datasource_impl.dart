import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/domain/entities/work_order_item_entity.dart';
import 'package:wms/features/auth/presentation/providers/auth_provider.dart';
import 'package:wms/features/workorders/domain/datasource/work_order_item_datasource.dart';
import 'package:wms/features/workorders/errors/work_order_errors.dart';

/// Implementación del datasource para gestionar ítems de órdenes de trabajo
class WorkOrderItemDatasourceImpl extends WorkOrderItemDatasource {
  final Ref ref;

  WorkOrderItemDatasourceImpl(this.ref);

  final dio = Dio(
    BaseOptions(baseUrl: '${dotenv.get('API_URL')}/workorderitem'),
  );

  String _getToken() {
    final bool expired = ref.read(authProvider.notifier).isTokenExpired();
    if (expired) {
      throw WorkOrderErrors(message: 'Token expirado');
    }
    return ref.read(authProvider).userSession!.token.accessToken;
  }

  @override
  Future<List<WorkOrderItem>> getItemsByWorkOrderId(int workOrderId) async {
    try {
      final response = await dio.get(
        '/',
        queryParameters: {'workOrderId': workOrderId},
        options: Options(headers: {'Authorization': 'Bearer ${_getToken()}'}),
      );
      return (response.data as List)
          .map((item) => _mapToWorkOrderItem(item))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw WorkOrderErrors(message: 'Token expirado');
      }
      throw WorkOrderErrors(message: 'Error al obtener ítems: ${e.message}');
    } catch (e) {
      throw WorkOrderErrors(message: 'Error desconocido: $e');
    }
  }

  @override
  Future<WorkOrderItem> createItem(WorkOrderItem item) async {
    try {
      final data = _itemToJson(item);
      print('=== CREATE ITEM ===');
      print('URL: ${dio.options.baseUrl}/');
      print('Data: $data');
      final response = await dio.post(
        '/',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer ${_getToken()}'}),
      );
      print('Response: ${response.data}');
      print('Mapeando respuesta...');
      final mapped = _mapToWorkOrderItem(response.data);
      print('Mapeo exitoso: ${mapped.id}');
      return mapped;
    } on DioException catch (e) {
      print('DioError: ${e.response?.statusCode} - ${e.message}');
      print('Response data: ${e.response?.data}');
      if (e.response?.statusCode == 401) {
        throw WorkOrderErrors(message: 'Token expirado');
      }
      if (e.response?.statusCode == 404) {
        throw WorkOrderErrors(message: 'Endpoint no encontrado');
      }
      // Capturar el mensaje de error del backend
      final backendMessage =
          e.response?.data?['detail'] ??
          e.response?.data?['message'] ??
          e.message;
      throw WorkOrderErrors(message: 'Error al crear ítem: $backendMessage');
    } catch (e) {
      print('Error desconocido: $e');
      throw WorkOrderErrors(message: 'Error desconocido: $e');
    }
  }

  @override
  Future<WorkOrderItem> updateItem(int id, WorkOrderItem item) async {
    try {
      final data = _itemToJson(item);
      final response = await dio.put(
        '/$id',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer ${_getToken()}'}),
      );
      return _mapToWorkOrderItem(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw WorkOrderErrors(message: 'Ítem no encontrado');
      }
      if (e.response?.statusCode == 401) {
        throw WorkOrderErrors(message: 'Token expirado');
      }
      throw WorkOrderErrors(message: 'Error al actualizar ítem: ${e.message}');
    } catch (e) {
      throw WorkOrderErrors(message: 'Error desconocido: $e');
    }
  }

  @override
  Future<void> deleteItem(int id) async {
    try {
      await dio.delete(
        '/$id',
        options: Options(headers: {'Authorization': 'Bearer ${_getToken()}'}),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw WorkOrderErrors(message: 'Ítem no encontrado');
      }
      if (e.response?.statusCode == 401) {
        throw WorkOrderErrors(message: 'Token expirado');
      }
      throw WorkOrderErrors(message: 'Error al eliminar ítem: ${e.message}');
    } catch (e) {
      throw WorkOrderErrors(message: 'Error desconocido: $e');
    }
  }

  /// Convierte la respuesta JSON a WorkOrderItem
  /// Maneja tanto String como num para unit_cost y unit_price
  WorkOrderItem _mapToWorkOrderItem(Map<String, dynamic> json) {
    // Función auxiliar para parsear números (String o num)
    double? parseNum(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return WorkOrderItem(
      id: json['id'] as int?,
      workOrderId: json['work_order_id'] as int?,
      itemType: (json['item_type'] as String?) ?? 'OTHER',
      description: (json['description'] as String?) ?? '',
      quantity: json['quantity'] as int?,
      unitCost: parseNum(json['unit_cost']),
      unitPrice: parseNum(json['unit_price']),
      beforePhoto: json['before_photo'] as String?,
      afterPhoto: json['after_photo'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  /// Convierte WorkOrderItem a JSON para la API
  Map<String, dynamic> _itemToJson(WorkOrderItem item) {
    return {
      if (item.workOrderId != null) 'work_order_id': item.workOrderId,
      'item_type': item.itemType,
      'description': item.description,
      if (item.quantity != null) 'quantity': item.quantity,
      if (item.unitCost != null) 'unit_cost': item.unitCost,
      if (item.unitPrice != null) 'unit_price': item.unitPrice,
      if (item.beforePhoto != null) 'before_photo': item.beforePhoto,
      if (item.afterPhoto != null) 'after_photo': item.afterPhoto,
    };
  }
}
