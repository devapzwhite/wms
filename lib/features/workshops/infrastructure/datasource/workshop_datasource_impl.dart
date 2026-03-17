import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/domain/entities/workshop_entity.dart';
import 'package:wms/features/auth/presentation/providers/auth_provider.dart';
import 'package:wms/features/workshops/domain/datasource/workshop_datasource.dart';

/// Implementación del datasource para obtener datos del taller
class WorkshopDatasourceImpl extends WorkshopDatasource {
  final Ref ref;
  
  WorkshopDatasourceImpl(this.ref);
  
  final dio = Dio(
    BaseOptions(
      baseUrl: '${dotenv.get('API_URL')}/workshops',
      headers: {'Authorization': 'bearer'},
    ),
  );
  
  String _getToken() {
    final bool expired = ref.read(authProvider.notifier).isTokenExpired();
    if (expired) {
      throw Exception('Token expirado');
    }
    return ref.read(authProvider).userSession!.token.accessToken;
  }

  @override
  Future<Workshop> getWorkshopById(int shopId) async {
    try {
      final response = await dio.get(
        '/$shopId',
        options: Options(headers: {'Authorization': 'Bearer ${_getToken()}'}),
      );
      
      // Mapear la respuesta a Workshop
      return Workshop(
        name: response.data['name'] ?? 'Taller sin nombre',
        ownerName: response.data['owner_name'] ?? '',
        phone: response.data['phone'] ?? '',
        address: response.data['address'] ?? '',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Taller no encontrado');
      }
      throw Exception(
        'Error al obtener taller: ${e.response?.statusCode ?? 'sin código'} - ${e.message}',
      );
    } catch (e) {
      throw Exception('Error no controlado: $e');
    }
  }
}
