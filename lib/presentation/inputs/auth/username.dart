import 'package:formz/formz.dart';

enum UsernameError { empty, invalid }

class Username extends FormzInput<String, UsernameError> {
  const Username.pure() : super.pure('');

  const Username.dirty({String value = ''}) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == UsernameError.empty) {
      return "el campo no puede estar vacio";
    }
    if (displayError == UsernameError.invalid) {
      return "el username debe tener al menos 6 caracteres";
    }
    return null;
  }

  @override
  UsernameError? validator(String value) {
    if (value.trim().isEmpty) {
      return UsernameError.empty;
    }
    if (value.trim().length < 6) {
      return UsernameError.invalid;
    }
    return null;
  }
}
