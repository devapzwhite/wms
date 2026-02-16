import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/domain/entities/entities.dart';
import 'package:wms/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:wms/features/auth/infrastructure/repository/auth_repository_impl.dart';
import 'package:wms/infrastructure/datasource/services/key_value_storage_services.dart';

import '../../domain/repository/auth_repository.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  final authRepository = AuthRepositoryImpl();
  return AuthNotifier(authRepository);
});

class AuthNotifier extends Notifier<AuthState> {
  final AuthRepository authRepository;
  AuthNotifier(this.authRepository);

  final storage = KeyValueStorageServicesImpl();
  @override
  AuthState build() {
    return AuthState();
  }

  Future<void> loginUser(String username, String password) async {
    try {
      if (!ref.mounted) return;
      final userSession = await authRepository.login(username, password);

      await storage.saveUserSession(
        token: userSession.token.accessToken,
        expiresAt: userSession.token.expiresAt,
        id: userSession.user.id,
        shopId: userSession.user.shopId,
        username: userSession.user.username,
        name: userSession.user.name,
        email: userSession.user.email,
      );
      if (!ref.mounted) return;
      state = state.copyWith(
        status: AuthStatus.authenticated,
        userSession: userSession,
        errorMessage: "",
      );
    } on CustomError catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: AuthStatus.notAuthenticated,
        errorMessage: e.message,
        userSession: null,
      );
    }
  }

  Future<void> logout() async {
    await storage.clearUserSession();
    if (!ref.mounted) return;
    state = state.copyWith(
      status: AuthStatus.notAuthenticated,
      userSession: null,
      errorMessage: "",
    );
  }

  void setUserSession(UserSessionEntity userSession) {
    if (!ref.mounted) return;
    state = state.copyWith(
      status: AuthStatus.authenticated,
      userSession: userSession,
      errorMessage: "",
    );
  }

  bool isTokenExpired() {
    if (state.userSession?.token == null) return true;
    final expiryDate = state.userSession!.token.expiresAt;
    return DateTime.now().isAfter(expiryDate);
  }
}

class AuthState {
  final AuthStatus status;
  final UserSessionEntity? userSession;
  final String errorMessage;
  AuthState({
    this.status = AuthStatus.checking,
    this.userSession,
    this.errorMessage = "",
  });
  AuthState copyWith({
    AuthStatus? status,
    UserSessionEntity? userSession,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      userSession: userSession ?? this.userSession,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
