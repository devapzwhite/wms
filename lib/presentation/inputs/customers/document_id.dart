import 'package:formz/formz.dart';

enum DocumentIdError { empty, incomplete }

class DocumentId extends FormzInput<String, DocumentIdError> {
  const DocumentId.pure() : super.pure('');

  const DocumentId.dirty({String value = ''}) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == DocumentIdError.empty) {
      return "el campo no puede estar vacio";
    }
    if (displayError == DocumentIdError.incomplete) {
      return "este campo debe tener mas de 6 caracteres";
    }
    return null;
  }

  @override
  DocumentIdError? validator(String value) {
    if (value.trim().isEmpty) {
      return DocumentIdError.empty;
    }
    if (value.trim().length < 6) {
      return DocumentIdError.incomplete;
    }
    return null;
  }
}
