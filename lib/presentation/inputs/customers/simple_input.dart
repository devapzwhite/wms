import 'package:formz/formz.dart';

enum BasicStringInputErrors { empty }

class BasicStringInput extends FormzInput<String, BasicStringInputErrors> {
  const BasicStringInput.pure() : super.pure('');
  const BasicStringInput.dirty({String value = ''}) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == BasicStringInputErrors.empty) {
      return "el campo no puede estar vacio";
    }
    return null;
  }

  @override
  BasicStringInputErrors? validator(String value) {
    if (value.trim().isEmpty) {
      return BasicStringInputErrors.empty;
    }
    return null;
  }
}
