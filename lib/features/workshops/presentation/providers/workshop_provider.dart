import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/domain/entities/workshop_entity.dart';
import 'package:wms/features/auth/presentation/providers/auth_provider.dart';
import 'package:wms/features/workshops/infrastructure/datasource/workshop_datasource_impl.dart';
import 'package:wms/features/workshops/infrastructure/repositories/workshop_repository_impl.dart';

/// Provider del datasource de talleres
final workshopDatasourceProvider = Provider<WorkshopDatasourceImpl>((ref) {
  return WorkshopDatasourceImpl(ref);
});

/// Provider del repositorio de talleres
final workshopRepositoryProvider = Provider<WorkshopRepositoryImpl>((ref) {
  final datasource = ref.watch(workshopDatasourceProvider);
  return WorkshopRepositoryImpl(datasource);
});

/// Provider para obtener los datos del taller actual
/// Usa el shopId del usuario autenticado
final workshopProvider = FutureProvider<Workshop>((ref) async {
  // Obtener el shopId del usuario autenticado
  final authState = ref.watch(authProvider);
  final shopId = authState.userSession?.user.shopId;
  
  if (shopId == null) {
    return Workshop.empty();
  }
  
  // Obtener los datos del taller
  final repository = ref.watch(workshopRepositoryProvider);
  return await repository.getWorkshopById(shopId);
});
