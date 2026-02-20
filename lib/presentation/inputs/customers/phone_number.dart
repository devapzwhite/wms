import 'package:formz/formz.dart';

enum PhoneNumberErrors { empty, lowLength, highLength, invalidFormat }

class PhoneNumber extends FormzInput<String, PhoneNumberErrors> {
  const PhoneNumber.pure() : super.pure('');
  const PhoneNumber.dirty({String value = ''}) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == PhoneNumberErrors.empty) {
      return 'el campo no puede estar vacio';
    }
    if (displayError == PhoneNumberErrors.lowLength ||
        displayError == PhoneNumberErrors.highLength) {
      return 'el numero debe tener 9 digitos';
    }
    if (displayError == PhoneNumberErrors.invalidFormat) {
      return 'Formato de numero de telefono invalido';
    }
    return null;
  }

  @override
  PhoneNumberErrors? validator(String value) {
    if (value.trim().isEmpty) return PhoneNumberErrors.empty;
    if (value.trim().length < 9) return PhoneNumberErrors.lowLength;
    if (value.trim().length > 9) return PhoneNumberErrors.highLength;
    final regex = RegExp(r'^[0-9]+$');
    if (!regex.hasMatch(value.trim())) return PhoneNumberErrors.invalidFormat;
    return null;
  }
}
