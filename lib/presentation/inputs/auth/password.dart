import 'package:formz/formz.dart';

// Define input validation errors
enum PasswordError { empty, lowLength }

// Extend FormzInput and provide the input type and error type.
class Password extends FormzInput<String, PasswordError> {
  // Call super.pure to represent an unmodified form input.
  const Password.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Password.dirty({String value = ''}) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == PasswordError.empty) {
      return "el campo no puede estar vacio";
    }
    if (displayError == PasswordError.lowLength) {
      return "la contraseña debe tener al menos 8 caracteres";
    }
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  PasswordError? validator(String value) {
    if (value.trim().isEmpty) {
      return PasswordError.empty;
    }
    if (value.trim().length <= 8) {
      return PasswordError.lowLength;
    }
    return null;
  }
}
