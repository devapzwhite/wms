import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/features/customers/presentation/providers/form_add_customer_provider.dart';
import 'package:wms/features/customers/presentation/widgets/custom_text_form_field.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class AddCustomerScreen extends StatelessWidget {
  final title = "Registrar Cliente";
  AddCustomerScreen({super.key});
  final ValueNotifier<bool> _addEmail = ValueNotifier(false);
  final ValueNotifier<bool> _addAddress = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            HeaderAddCustomer(addEmail: _addEmail, addAddress: _addAddress),
            Card(
              elevation: 15,
              child: FormAddCustomer(
                addEmail: _addEmail,
                addAddress: _addAddress,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderAddCustomer extends StatelessWidget {
  const HeaderAddCustomer({
    super.key,
    required ValueNotifier<bool> addEmail,
    required ValueNotifier<bool> addAddress,
  }) : _addEmail = addEmail,
       _addAddress = addAddress;

  final ValueNotifier<bool> _addEmail;
  final ValueNotifier<bool> _addAddress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          children: [
            Card(
              elevation: 10,
              child: Row(
                spacing: 5,
                children: [
                  SizedBox(width: 5),
                  Text('Email'),
                  ValueListenableBuilder(
                    valueListenable: _addEmail,
                    builder: (context, value, child) {
                      return Switch(
                        value: value,
                        onChanged: (value) {
                          _addEmail.value = value;
                        },
                      );
                    },
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ),
            SizedBox(width: 20),
            Card(
              elevation: 10,
              child: Row(
                spacing: 5,
                children: [
                  SizedBox(width: 5),
                  Text('Dirección'),
                  ValueListenableBuilder(
                    valueListenable: _addAddress,
                    builder: (context, value, child) => Switch(
                      value: value,
                      onChanged: (value) => _addAddress.value = value,
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FormAddCustomer extends ConsumerStatefulWidget {
  const FormAddCustomer({
    super.key,
    required ValueNotifier<bool> addEmail,
    required ValueNotifier<bool> addAddress,
  }) : _addEmail = addEmail,
       _addAddress = addAddress;

  final ValueNotifier<bool> _addEmail;
  final ValueNotifier<bool> _addAddress;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FormAddCustomerState();
}

class _FormAddCustomerState extends ConsumerState<FormAddCustomer> {
  @override
  Widget build(BuildContext context) {
    final formNotifier = ref.read(formAddCustomerProvider.notifier);
    final formProvider = ref.watch(formAddCustomerProvider);
    final colors = Theme.of(context).colorScheme;
    ref.listen(formAddCustomerProvider, (previous, next) {
      if (next.isSubmited) {
        if (next.errorMessage == null) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Cliente Registrado Correctamente!'),
              actions: [
                FilledButton(
                  onPressed: () {
                    context.pop();
                    context.pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
        if (next.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
          ref.read(formAddCustomerProvider.notifier).onAceptResults();
        }
      }
    });
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          spacing: 15,
          children: [
            CustomTextFormField(
              labelText: 'Nro. Documento',
              errorText: formProvider.documentId.errorMessage,
              onChange: formNotifier.onChangeDocumentId,
            ),
            CustomTextFormField(
              labelText: 'Nombre',
              errorText: formProvider.name.errorMessage,
              onChange: formNotifier.onChangeName,
            ),
            CustomTextFormField(
              labelText: 'Apellido',
              errorText: formProvider.lastName.errorMessage,
              onChange: formNotifier.onChangeLastName,
            ),
            CustomTextFormField(
              keyboardType: TextInputType.number,
              labelText: 'Nro. Celular',
              errorText: formProvider.phone.errorMessage,
              onChange: formNotifier.onChangePhone,
            ),
            ValueListenableBuilder(
              valueListenable: widget._addEmail,
              child: CustomTextFormField(
                labelText: 'Email',
                errorText: null,
                onChange: formNotifier.onChangeEmail,
              ),
              builder: (context, value, child) =>
                  value ? child! : SizedBox.shrink(),
            ),
            ValueListenableBuilder(
              valueListenable: widget._addAddress,
              child: CustomTextFormField(
                labelText: 'Dirección',
                errorText: null,
                onChange: formNotifier.onChangeAddress,
              ),
              builder: (context, value, child) =>
                  value ? child! : SizedBox.shrink(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      colors.primaryContainer,
                    ),
                  ),
                  onPressed: () async {
                    await ref.read(formAddCustomerProvider.notifier).onSubmit();
                  },
                  icon: Row(
                    children: [
                      Icon(Icons.save),
                      SizedBox(width: 5),
                      Text('Guardar'),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                IconButton.filledTonal(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      colors.errorContainer,
                    ),
                    foregroundColor: WidgetStatePropertyAll(
                      colors.onErrorContainer,
                    ),
                  ),
                  onPressed: () {
                    context.pop();
                  },
                  icon: Row(
                    children: [
                      Icon(Icons.clear),
                      SizedBox(width: 5),
                      Text('Cancelar'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
