import 'entities.dart';

class UserSessionEntity {
  final User user;
  final Token token;

  UserSessionEntity({required this.user, required this.token});
}
