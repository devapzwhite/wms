import 'package:wms/domain/entities/workshop_entity.dart';

/// Interfaz abstracta del datasource para obtener datos del taller
abstract class WorkshopDatasource {
  /// Obtiene los datos del taller por su ID
  Future<Workshop> getWorkshopById(int shopId);
}
