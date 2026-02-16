import 'package:formz/formz.dart';
import 'package:wms/presentation/inputs/inputs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';

final loginFormProvider =
    NotifierProvider.autoDispose<LoginNotifier, LoginFormState>(
      LoginNotifier.new,
    );

class LoginNotifier extends Notifier<LoginFormState> {
  @override
  LoginFormState build() => LoginFormState();
  void updateUsername(String value) {
    final Username username = Username.dirty(value: value);
    state = state.copyWith(
      username: username,
      isFormValid: Formz.validate([username, state.password]),
    );
  }

  void updatePassword(String value) {
    final Password password = Password.dirty(value: value);
    state = state.copyWith(
      password: password,
      isFormValid: Formz.validate([state.username, password]),
    );
  }

  Future<void> submit() async {
    _touchAll();
    if (!state.isFormValid) return;
    await ref
        .read(authProvider.notifier)
        .loginUser(state.username.value, state.password.value);
  }

  void _touchAll() {
    final username = Username.dirty(value: state.username.value);
    final password = Password.dirty(value: state.password.value);
    state = state.copyWith(
      username: username,
      password: password,
      isFormValid: Formz.validate([username, password]),
    );
  }
}

class LoginFormState {
  final Username username;
  final Password password;
  final bool isFormValid;

  LoginFormState({
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.isFormValid = false,
  });
  LoginFormState copyWith({
    Username? username,
    Password? password,
    bool? isFormValid,
  }) {
    return LoginFormState(
      username: username ?? this.username,
      password: password ?? this.password,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }
}
