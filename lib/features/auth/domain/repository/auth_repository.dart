import 'package:wms/domain/entities/entities.dart';

abstract class AuthRepository {
  Future<UserSessionEntity> login(String username, String password);
}
