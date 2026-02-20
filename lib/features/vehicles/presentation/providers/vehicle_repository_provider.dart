import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/features/vehicles/infrastructure/datasource/vehicle_datasource_impl.dart';
import 'package:wms/features/vehicles/infrastructure/repository/vehicle_repository.dart';

final vehicleRepositoryProvider = Provider((ref) {
  return VehicleRepositoryImpl(
    ref: ref,
    datasource: VehicleDatasourceImpl(ref: ref),
  );
});
