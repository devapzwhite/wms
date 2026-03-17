import 'package:wms/domain/entities/workshop_entity.dart';

/// Interfaz del repositorio para obtener datos del taller
abstract class WorkshopRepository {
  /// Obtiene los datos del taller por su ID
  Future<Workshop> getWorkshopById(int shopId);
}
