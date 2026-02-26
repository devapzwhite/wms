import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:wms/config/helpers/customer_provider_helpers.dart';
import 'package:wms/domain/entities/entities.dart';
import 'package:wms/features/customers/errors/customer_errors.dart';
import 'package:wms/features/customers/presentation/providers/customers_provider.dart';
import 'package:wms/features/customers/presentation/providers/customer_repository_provider.dart';
import 'package:wms/presentation/inputs/inputs.dart';

final formAddCustomerProvider =
    NotifierProvider.autoDispose<FormAddCustomerNotifier, FormAddCustomerState>(
      () {
        return FormAddCustomerNotifier();
      },
    );

class FormAddCustomerNotifier extends Notifier<FormAddCustomerState> {
  @override
  FormAddCustomerState build() {
    return FormAddCustomerState();
  }

  void onAceptResults() {
    state = state.copyWith(isSubmited: false, clearErrorMessage: true);
  }

  void onChangeDocumentId(String value) {
    final documentId = DocumentId.dirty(value: value);
    state = state.copyWith(
      documentId: documentId,
      isFormValid: Formz.validate([
        documentId,
        state.name,
        state.lastName,
        state.phone,
      ]),
    );
  }

  void onChangeName(String value) {
    final name = BasicStringInput.dirty(value: value);
    state = state.copyWith(
      name: name,
      isFormValid: Formz.validate([
        name,
        state.documentId,
        state.lastName,
        state.phone,
      ]),
    );
  }

  void onChangeLastName(String value) {
    final lastName = BasicStringInput.dirty(value: value);
    state = state.copyWith(
      lastName: lastName,
      isFormValid: Formz.validate([
        lastName,
        state.documentId,
        state.name,
        state.phone,
      ]),
    );
  }

  void onChangePhone(String value) {
    final phone = PhoneNumber.dirty(value: value);
    state = state.copyWith(
      phone: phone,
      isFormValid: Formz.validate([
        phone,
        state.documentId,
        state.name,
        state.lastName,
      ]),
    );
  }

  void onChangeEmail(String value) {
    state = state.copyWith(email: value);
  }

  void onChangeAddress(String value) {
    state = state.copyWith(address: value);
  }

  Future<void> onSubmit() async {
    _validate();
    final customerRepository = ref.read(customersRepositoryProvider);
    final customerProvider = ref.read(customerNotifierProvider.notifier);
    if (!state.isFormValid) return;
    final customer = Customer(
      documentId: state.documentId.value,
      name: state.name.value,
      lastName: state.lastName.value,
      phone: CustomerProviderHelpers.completePhoneNumber(state.phone.value),
      email: state.email,
      address: state.address,
    );
    try {
      final customerResponse = await customerRepository.addCustomer(customer);
      if (!ref.mounted) return;
      customerProvider.addCustomer(customerResponse);
      state = state.copyWith(isSubmited: true);
    } on CustomerErrors catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isSubmited: true,
        errorMessage: e.message.toString(),
      );
      return;
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isSubmited: true,
        errorMessage: 'Error no controlado ${e.toString()}',
      );
      return;
    }
  }

  Future<void> onUpdateCustomer(Customer customer) async {
    final updatesCustomer = getchanges(customer);
    final customersNotifier = ref.read(customerNotifierProvider.notifier);
    final repository = ref.read(customersRepositoryProvider);

    try {
      await repository.updateCustomer(updatesCustomer);
      if (!ref.mounted) return;
      customersNotifier.loadCustomers();
      state = state.copyWith(isSubmited: true);
    } on CustomerErrors catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isSubmited: true,
        errorMessage: 'error al modificar usuario ${e.message}',
      );
    }
  }

  Customer getchanges(Customer customer) {
    return customer = Customer(
      id: customer.id,
      documentId: state.documentId.isPure ? '' : state.documentId.value,
      name: state.name.isPure ? '' : state.name.value,
      lastName: state.lastName.isPure ? '' : state.lastName.value,
      phone: state.phone.isPure ? '' : state.phone.value,
      address: state.address?.trim() == '' ? null : state.address,
      email: state.email?.trim() == '' ? null : state.email?.trim(),
    );
  }

  void _validate() {
    state = state.copyWith(
      documentId: DocumentId.dirty(value: state.documentId.value),
      name: BasicStringInput.dirty(value: state.name.value),
      lastName: BasicStringInput.dirty(value: state.lastName.value),
      phone: PhoneNumber.dirty(value: state.phone.value),
      email: state.email,
      address: state.address,
    );
    state = state.copyWith(
      isFormValid: Formz.validate([
        state.documentId,
        state.name,
        state.lastName,
        state.phone,
      ]),
    );
  }
}

class FormAddCustomerState {
  final DocumentId documentId;
  final BasicStringInput name;
  final BasicStringInput lastName;
  final PhoneNumber phone;
  final String? email;
  final String? address;
  final bool isFormValid;
  final String? errorMessage;
  final bool isSubmited;
  FormAddCustomerState({
    this.documentId = const DocumentId.pure(),
    this.name = const BasicStringInput.pure(),
    this.lastName = const BasicStringInput.pure(),
    this.phone = const PhoneNumber.pure(),
    this.email,
    this.address,
    this.isFormValid = false,
    this.errorMessage,
    this.isSubmited = false,
  });

  FormAddCustomerState copyWith({
    DocumentId? documentId,
    BasicStringInput? name,
    BasicStringInput? lastName,
    PhoneNumber? phone,
    String? email,
    String? address,
    bool? isFormValid,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isSubmited,
  }) => FormAddCustomerState(
    documentId: documentId ?? this.documentId,
    name: name ?? this.name,
    lastName: lastName ?? this.lastName,
    isFormValid: isFormValid ?? this.isFormValid,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    address: address ?? this.address,
    errorMessage: clearErrorMessage
        ? null
        : (errorMessage ?? this.errorMessage),
    isSubmited: isSubmited ?? this.isSubmited,
  );
}
