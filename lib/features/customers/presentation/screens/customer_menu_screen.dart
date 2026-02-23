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
    final size = MediaQuery.of(context).size;
    final customersProvider = ref.watch(customerNotifierProvider);
    return Scaffold(
      appBar: AppBarCustom(title: title),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          spacing: 10,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: customerListMenuItems.map((item) {
                  return HomeMenuCard(
                    menuItem: item,
                    width: size.width * 0.20,
                    height: size.width * 0.20,
                    fontSize: 9,
                    iconsize: 30,
                    spacing: 5,
                  );
                }).toList(),
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: CircleAvatar(
                                          child: Text(
                                            '${customer.name.toUpperCase().substring(0, 1)}${customer.lastName.toUpperCase().substring(0, 1)}',
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${customer.name} ${customer.lastName}',
                                          ),
                                          Text(
                                            customer.email ?? '',
                                            style: TextStyle(fontSize: 11),
                                          ),
                                          Text(
                                            customer.address ?? '',
                                            style: TextStyle(fontSize: 11),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      IconButton(
                                        onPressed: () => context.push(
                                          '/customers/details/${customer.id}',
                                        ),
                                        icon: Icon(Icons.arrow_forward_ios),
                                      ),
                                    ],
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
    );
  }
}
