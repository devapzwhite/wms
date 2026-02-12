import 'package:wms/domain/entities/entities.dart';

abstract class AuthDatasource {
  Future<UserSessionEntity> login(String username, String password);
}
