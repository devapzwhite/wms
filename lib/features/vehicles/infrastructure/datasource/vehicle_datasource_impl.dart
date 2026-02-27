import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/domain/entities/vehicle_entity.dart';
import 'package:wms/features/auth/presentation/providers/auth_provider.dart';
import 'package:wms/features/vehicles/domain/datasource/vehicles_datasource.dart';
import 'package:wms/features/vehicles/errors/vehicle_errors.dart';
import 'package:wms/features/vehicles/infrastructure/mappers/vehicle_mapper.dart';

class VehicleDatasourceImpl extends VehiclesDatasource {
  final Ref ref;

  VehicleDatasourceImpl({required this.ref});

  final dio = Dio(BaseOptions(baseUrl: '${dotenv.get('API_URL')}/vehicles'));
  Map<String, dynamic>? getHeaders() {
    final Map<String, dynamic>? headers = {
      'Authorization':
          'Bearer ${ref.read(authProvider).userSession!.token.accessToken}',
    };
    return headers;
  }

  @override
  Future<List<Vehicle>> getVehicles() async {
    try {
      final response = await dio.get(
        '',
        options: Options(
          headers: {
            'Authorization':
                'Bearer ${ref.read(authProvider).userSession!.token.accessToken}',
          },
        ),
      );
      final List<Vehicle> result = List<Vehicle>.from(
        response.data.map(
          (vehicle) => VehicleMapper.dataToVehicleEntity(vehicle),
        ),
      );
      return result;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw VehicleErrors(message: 'Token expirado');
      }
      throw VehicleErrors(
        message: 'Error al obtener los vehículos: ${e.message}',
      );
    } catch (e) {
      throw VehicleErrors(message: 'error no controlado ${e.toString()}');
    }
  }

  @override
  Future<Vehicle> addVehicle(Vehicle vehicle) async {
    try {
      final data = VehicleMapper.tipoVehiculoToData(vehicle);
      final response = await dio.post(
        '',
        data: data,
        options: Options(
          headers: {
            'Authorization':
                'Bearer ${ref.read(authProvider).userSession!.token.accessToken}',
          },
        ),
      );
      return vehicle = VehicleMapper.dataToVehicleEntity(response.data);
    } on DioException catch (e) {
      if (e.response!.statusCode == 400) {
        throw VehicleErrors(message: 'Este vehiculo ya existe');
      }
      if (e.response?.statusCode == 401) {
        throw VehicleErrors(message: 'Token expirado');
      }
      if (e.response?.statusCode == 422) {
        throw VehicleErrors(message: 'Falta elementos para el post');
      }
      throw VehicleErrors(message: 'Dio: Vehiculo no registrado');
    } catch (e) {
      throw VehicleErrors(message: 'Excepcion no controlado ${e.toString()}');
    }
  }

  @override
  Future<Vehicle> getVehicleById(int id) async {
    try {
      final response = await dio.get(
        '/searchById/$id',
        options: Options(headers: getHeaders()),
      );
      final Vehicle vehicle = VehicleMapper.dataToVehicleEntity(response.data);
      return vehicle;
    } on DioException catch (e) {
      if (e.response!.statusCode == 401) {
        throw VehicleErrors(message: 'token expirado');
      }
      throw VehicleErrors(
        message: e.message ?? 'error en dio desconocido jeje',
      );
    } catch (e) {
      throw VehicleErrors(message: 'error desconocido');
    }
  }

  @override
  Future<void> getVehicleByPlate(String plate) {
    // TODO: implement getVehicleByPlate
    throw UnimplementedError();
  }

  @override
  Future<void> updateVehicle(VehicleUpdate vehicle) async {
    try {
      final data = VehicleMapper.vehiculoUpdateToData(vehicle);
      await dio.put(
        '/${vehicle.id!}',
        data: data,
        options: Options(headers: getHeaders()),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw VehicleErrors(message: 'esta placa existe en otro vehiculo');
      }
      if (e.response!.statusCode == 401) {
        throw VehicleErrors(message: 'token expirado');
      }
      throw VehicleErrors(message: 'error no controlado en dio');
    } catch (e) {
      throw VehicleErrors(message: 'error desconocido');
    }
  }
}
