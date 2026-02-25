import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/features/customers/presentation/providers/customers_provider.dart';
import 'package:wms/features/home/config/router/list_menu_items.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class CustomerMenuScreen extends ConsumerStatefulWidget {
  const CustomerMenuScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerMenuScreenState();
}

class _CustomerMenuScreenState extends ConsumerState<CustomerMenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(customerNotifierProvider.notifier).loadCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title = "Menú de Clientes";
    final customersProvider = ref.watch(customerNotifierProvider);
    return Scaffold(
      appBar: AppBarCustom(title: title),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  Chip(
                    label: Text(
                      '${customersProvider.customers.length.toString()} ${customersProvider.customers.length > 1 ? 'Clientes' : 'Cliente'}',
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            !customersProvider.isLoading
                ? Flexible(
                    child: customersProvider.customers.isNotEmpty
                        ? ListView.builder(
                            itemCount: customersProvider.customers.length,
                            itemBuilder: (context, index) {
                              final customer =
                                  customersProvider.customers[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                child: Card(
                                  elevation: 8,
                                  child: ListTile(
                                    onTap: () {
                                      context.push(
                                        '/customers/details/${customer.id}',
                                      );
                                    },
                                    title: Text(
                                      '${customer.name} ${customer.lastName}',
                                    ),
                                    subtitle: Text(
                                      customer.address ??
                                          'no tiene registrado direccion',
                                    ),
                                    leading: CircleAvatar(
                                      child: Text(
                                        '${customer.name.toUpperCase().substring(0, 1)}${customer.lastName.toUpperCase().substring(0, 1)}',
                                      ),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        context.push(
                                          '/customers/updatecustomer/${customer.id}',
                                        );
                                      },
                                      icon: Icon(Icons.edit_document),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Padding(
                            padding: EdgeInsetsGeometry.all(10),
                            child: Text('No hay clientes registrados'),
                          ),
                  )
                : CircularProgressIndicator(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/customers/addcustomer');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
