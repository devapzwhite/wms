import 'package:wms/domain/entities/workshop_entity.dart';
import 'package:wms/features/workshops/domain/datasource/workshop_datasource.dart';
import 'package:wms/features/workshops/domain/repositories/workshop_repository.dart';

/// Implementación del repositorio de talleres
class WorkshopRepositoryImpl implements WorkshopRepository {
  final WorkshopDatasource datasource;
  
  WorkshopRepositoryImpl(this.datasource);

  @override
  Future<Workshop> getWorkshopById(int shopId) async {
    return await datasource.getWorkshopById(shopId);
  }
}
