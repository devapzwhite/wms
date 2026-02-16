import 'package:shared_preferences/shared_preferences.dart';
import 'package:wms/domain/datasource/services/key_value_storage_services.dart';
import 'package:wms/domain/entities/entities.dart';

class KeyValueStorageServicesImpl extends KeyValueStorageServices {
  @override
  Future<void> deleteKeyValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  @override
  Future<T?> getKeyValue<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    switch (T) {
      case String:
        return prefs.getString(key) as T?;
      case int:
        return prefs.getInt(key) as T?;
      case bool:
        return prefs.getBool(key) as T?;
      case DateTime:
        final dateStr = prefs.getString(key);
        if (dateStr == null) return null;
        return DateTime.tryParse(dateStr) as T?;
      default:
        throw UnimplementedError('Unimplemented type: ${T.runtimeType}');
    }
  }

  @override
  Future<void> saveKeyValue<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();
    switch (T) {
      case String:
        await prefs.setString(key, value as String);
        break;
      case int:
        await prefs.setInt(key, value as int);
        break;
      case bool:
        await prefs.setBool(key, value as bool);
        break;
      default:
        throw UnimplementedError('Unimplemented type: ${T.runtimeType}');
    }
  }

  @override
  Future<void> clearUserSession() {
    return Future.wait([
      deleteKeyValue('token'),
      deleteKeyValue('expiresAt'),
      deleteKeyValue('id'),
      deleteKeyValue('shop_id'),
      deleteKeyValue('username'),
      deleteKeyValue('name'),
      deleteKeyValue('email'),
    ]);
  }

  @override
  Future<UserSessionEntity?> getUserSession() async {
    //devuelve el user session o null si no hay session
    try {
      final token = await getKeyValue<String>('token');
      final expiresAtStr = await getKeyValue<String>('expiresAt');
      final id = await getKeyValue<int>('id');
      final shopId = await getKeyValue<int>('shop_id');
      final username = await getKeyValue<String>('username');
      final name = await getKeyValue<String>('name');
      final email = await getKeyValue<String>('email');

      if (token == null ||
          token.isEmpty ||
          expiresAtStr == null ||
          expiresAtStr.isEmpty ||
          id == null ||
          shopId == null ||
          username == null ||
          name == null ||
          email == null) {
        await clearUserSession();
        return null;
      }

      final Token tokenEntity = Token(
        accessToken: token,
        tokenType: "Bearer",
        expiresAt: DateTime.tryParse(expiresAtStr)!,
      );
      final User userEntity = User(
        id: id,
        shopId: shopId,
        username: username,
        name: name,
        email: email,
      );

      return UserSessionEntity(token: tokenEntity, user: userEntity);
    } catch (e) {
      await clearUserSession();
      return null;
    }
  }

  @override
  Future<void> saveUserSession({
    required String token,
    required DateTime expiresAt,
    required int id,
    required int shopId,
    required String username,
    required String name,
    required String email,
  }) async {
    await Future.wait([
      saveKeyValue<String>('token', token),
      saveKeyValue<String>('expiresAt', expiresAt.toIso8601String()),
      saveKeyValue<int>('id', id),
      saveKeyValue<int>('shop_id', shopId),
      saveKeyValue<String>('username', username),
      saveKeyValue<String>('name', name),
      saveKeyValue<String>('email', email),
    ]);
  }
}
