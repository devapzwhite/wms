import 'package:wms/domain/entities/entities.dart';

abstract class KeyValueStorageServices {
  Future<void> saveKeyValue<T>(String key, T value);
  Future<T?> getKeyValue<T>(String key);
  Future<void> deleteKeyValue(String key);
  Future<void> saveUserSession({
    required String token,
    required DateTime expiresAt,
    required int id,
    required int shopId,
    required String username,
    required String name,
    required String email,
  });
  Future<UserSessionEntity?> getUserSession();
  Future<void> clearUserSession();
}
