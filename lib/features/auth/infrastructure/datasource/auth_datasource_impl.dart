import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wms/domain/entities/user_session_entity.dart';
import 'package:wms/features/auth/domain/datasource/auth_datasource.dart';
import 'package:wms/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:wms/features/auth/infrastructure/mappers/user_session_mapper.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.get('API_URL'),
      connectTimeout: Duration(seconds: 30), // Tiempo para conectar
      receiveTimeout: Duration(seconds: 30), // Tiempo para recibir datos
      sendTimeout: Duration(seconds: 30),
      receiveDataWhenStatusError: true,
    ),
  );

  @override
  Future<UserSessionEntity> login(String username, String password) async {
    try {
      final response = await dio.post(
        '/auth',
        data: FormData.fromMap({'username': username, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = UserSessionMapper.UserSessionToEntity(response.data);
        return data;
      } else {
        throw Exception("Invalid credentials");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError("Invalid credentials");
      }
      if (e.type == DioExceptionType.sendTimeout) {
        throw CustomError('Timeout error: ${e.message}');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw CustomError('Timeout error: ${e.message}');
      }
      throw CustomError("Error logging in ${e.message}");
    } catch (e) {
      throw CustomError("Error logging in");
    }
  }
}
