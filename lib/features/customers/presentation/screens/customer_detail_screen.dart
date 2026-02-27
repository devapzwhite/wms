import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wms/features/customers/presentation/providers/customer_detail_provider.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class CustomerDetailScreen extends ConsumerStatefulWidget {
  final int idCustomer;
  const CustomerDetailScreen({super.key, required this.idCustomer});

  @override
  ConsumerState<CustomerDetailScreen> createState() =>
      _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends ConsumerState<CustomerDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  void _loadData() {
    ref
        .read(customerDetailNotifierProvider.notifier)
        .loadDetailsCustomer(widget.idCustomer);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final customerData = ref.watch(customerDetailNotifierProvider);
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    print(
      'BUILD ejecutado - vehiculos: ${customerData.vehicles.length} - isLoading: ${customerData.isLoading}',
    );
    return Scaffold(
      appBar: AppBarCustom(title: 'Detalle de cliente'),
      body: customerData.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsGeometry.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      width: size.width - 20,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(15),
                          child: Column(
                            children: [
                              Text(
                                '${customerData.customer.name} ${customerData.customer.lastName}'
                                    .toUpperCase(),
                                style: textStyle.headlineMedium,
                              ),
                              Chip(
                                label: Text(
                                  'RUT: ${customerData.customer.documentId}',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Chip(
                                label: Text('${customerData.customer.email}'),
                              ),
                              IconButton.filled(
                                onPressed: () async {
                                  final phone = customerData.customer.phone
                                      .replaceAll('+', '')
                                      .replaceAll(' ', '');
                                  await launchUrl(
                                    Uri.parse('https://wa.me/$phone'),
                                  );
                                },
                                style: IconButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: SizedBox(
                                  width: 140,
                                  child: Row(
                                    spacing: 10,
                                    children: [
                                      ImageIcon(
                                        AssetImage(
                                          'assets/icons/whatsapp-color-icon.png',
                                        ),
                                        size: 20,
                                      ),
                                      Text(
                                        customerData.customer.phone,
                                        style: TextStyle(
                                          color: colors.inversePrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Chip(
                                label: Text(
                                  customerData.customer.address ??
                                      'No tiene direccion',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Chip(
                      label: Text(
                        'Vehiculos Registrados',
                        style: textStyle.titleLarge,
                      ),
                      elevation: 10,
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(), // ← porque ya tienes SingleChildScrollView
                      itemCount: customerData.vehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = customerData.vehicles[index];
                        return Card(
                          child: ListTile(
                            title: Column(
                              children: [
                                Text(vehicle.brand),
                                Text(
                                  '${vehicle.model} ( ${vehicle.year.toString()} )',
                                ),
                              ],
                            ),
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleDialog(
                                    title: Text(
                                      '${vehicle.plate.toUpperCase()} ',
                                      textAlign: TextAlign.center,
                                    ),
                                    children: [
                                      Text(
                                        vehicle.vehicleType.nombre,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        vehicle.brand,
                                        textAlign: TextAlign.center,
                                      ),

                                      Text(
                                        vehicle.model,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        vehicle.year.toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            leading: IconButton(
                              onPressed: () async {
                                await context.push(
                                  '/vehicles/updatevehicle/${vehicle.id}',
                                );
                                if (mounted) _loadData();
                              },
                              icon: Icon(Icons.edit_document),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                context.push(
                                  '/workorders/addorder/${vehicle.id}',
                                );
                              },
                              icon: Icon(Icons.note_add),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print('navegando con idCustomer: ${widget.idCustomer}');
          await context.push('/vehicles/addvehicle/${widget.idCustomer}');
          if (mounted) _loadData();
        },
        child: Icon(Icons.commute_rounded),
      ),
    );
  }
}
