import 'package:wms/domain/entities/entities.dart';
import 'package:wms/features/auth/domain/datasource/auth_datasource.dart';
import 'package:wms/features/auth/domain/repository/auth_repository.dart';
import 'package:wms/features/auth/infrastructure/datasource/auth_datasource_impl.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepositoryImpl({AuthDatasource? authDatasource})
    : authDatasource = authDatasource ?? AuthDatasourceImpl();

  @override
  Future<UserSessionEntity> login(String username, String password) {
    return authDatasource.login(username, password);
  }
}
