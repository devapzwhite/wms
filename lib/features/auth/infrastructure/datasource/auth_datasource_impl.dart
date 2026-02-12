import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wms/domain/entities/user_session_entity.dart';
import 'package:wms/features/auth/domain/datasource/auth_datasource.dart';
import 'package:wms/features/auth/infrastructure/mappers/user_session_mapper.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_URL')));

  @override
  Future<UserSessionEntity> login(String username, String password) async {
    try {
      final response = await dio.post(
        'login',
        data: {'username': username, 'password': password},
      );
      if (response.statusCode == 200) {
        final data = UserSessionMapper.UserSessionToEntity(response.data);
        return data;
      } else {
        throw Exception("Invalid credentials");
      }
    } catch (e) {
      throw Exception("Error logging in");
    }
  }
}
