import 'package:wms/domain/entities/entities.dart';

class UserSessionMapper {
  static UserSessionEntity userSessionToEntity(Map<String, dynamic> data) =>
      UserSessionEntity(
        user: User.jsonToUser(data["user"]),
        token: Token.jsonToToken(data),
      );
}
