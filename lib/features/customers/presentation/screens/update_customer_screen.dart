import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/domain/entities/customer_entity.dart';
import 'package:wms/features/customers/presentation/providers/customers_provider.dart';
import 'package:wms/features/customers/presentation/providers/form_add_customer_provider.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class UpdateCustomerScreen extends ConsumerStatefulWidget {
  final int idCustomer;
  const UpdateCustomerScreen({super.key, required this.idCustomer});
  final String title = "Actualizar Cliente";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateCustomerScreenState();
}

class _UpdateCustomerScreenState extends ConsumerState<UpdateCustomerScreen> {
  Customer? _customerData;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    loadCustomer();
  }

  Future<void> loadCustomer() async {
    final customer = await ref
        .read(customerNotifierProvider.notifier)
        .getCustomerToUpdate(widget.idCustomer);
    if (mounted) {
      setState(() {
        _customerData = customer;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    ref.listen(formAddCustomerProvider, (previous, next) {
      if (next.isSubmited && next.errorMessage == null) {
        showDialog(
          builder: (context) => AlertDialog(
            title: Text('Cliente Modificado!'),
            actions: [
              TextButton(
                onPressed: () {
                  if (mounted) {
                    context.pop();
                    context.pop();
                  }
                },
                child: Text('OK'),
              ),
            ],
          ),
          context: context,
        );
      }
      if (next.isSubmited && next.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        ref.read(formAddCustomerProvider.notifier).onAceptResults();
      }
    });
    return Scaffold(
      appBar: AppBarCustom(title: widget.title),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Chip(
                elevation: 15,
                avatar: Icon(Icons.person),
                label: Text(
                  'ID: ${widget.idCustomer.toString()}',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: Card(
                  elevation: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Form(
                      child: Column(
                        spacing: 16,
                        children: [
                          Text('Datos del Cliente', style: textTheme.bodyLarge),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              label: Text(
                                'Numero de documento: ${_customerData?.documentId ?? ''}',
                              ),
                              hint: Text(_customerData?.documentId ?? ''),
                            ),
                            onChanged: ref
                                .read(formAddCustomerProvider.notifier)
                                .onChangeDocumentId,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              hint: Text(_customerData?.name ?? ''),
                              label: Text(
                                'Nombre ${_customerData?.name ?? ''}',
                              ),
                            ),
                            onChanged: ref
                                .read(formAddCustomerProvider.notifier)
                                .onChangeName,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              label: Text(
                                'Apellido: ${_customerData?.lastName ?? ''}',
                              ),
                              hint: Text(_customerData?.lastName ?? ''),
                            ),
                            onChanged: ref
                                .read(formAddCustomerProvider.notifier)
                                .onChangeLastName,
                          ),
                          TextField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              label: Text(
                                'Celular: ${_customerData?.phone ?? ''}',
                              ),
                              prefix: Text('+56 '),
                              hint: Text(
                                _customerData?.phone.substring(4) ?? '',
                              ),
                            ),
                            onChanged: ref
                                .read(formAddCustomerProvider.notifier)
                                .onChangePhone,
                          ),
                          TextField(
                            keyboardType: TextInputType.streetAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              label: Text(
                                'Direccion: ${_customerData?.address ?? ''}',
                              ),
                              hint: Text(_customerData?.address ?? ''),
                            ),
                            onChanged: ref
                                .read(formAddCustomerProvider.notifier)
                                .onChangeAddress,
                          ),
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              label: Text(
                                'Email: ${_customerData?.email ?? ''}',
                              ),
                              hint: Text(_customerData?.email ?? ''),
                            ),
                            onChanged: ref
                                .read(formAddCustomerProvider.notifier)
                                .onChangeEmail,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FilledButton.tonal(
                                onPressed: () async {
                                  await ref
                                      .read(formAddCustomerProvider.notifier)
                                      .onUpdateCustomer(_customerData!);
                                },
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    Icon(Icons.save_as_outlined),
                                    Text('GUARDAR'),
                                  ],
                                ),
                              ),
                              FilledButton.tonal(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    Colors.red,
                                  ),
                                  foregroundColor: WidgetStateProperty.all(
                                    Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  context.pop();
                                },
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    Icon(Icons.cancel_outlined),
                                    Text('CANCELAR'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
