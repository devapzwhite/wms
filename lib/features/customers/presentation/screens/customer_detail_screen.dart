import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wms/features/customers/presentation/providers/customer_detail_provider.dart';
import 'package:wms/features/workorders/presentation/providers/work_order_providers.dart';
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
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: customerData.vehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = customerData.vehicles[index];
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            minVerticalPadding: 0,
                            contentPadding: EdgeInsets.all(0),
                            title: Column(
                              children: [
                                Text(vehicle.brand),
                                SizedBox(height: 5),
                                Text(
                                  '${vehicle.model} ( ${vehicle.year.toString()} )',
                                ),
                                SizedBox(height: 10),

                                SizedBox(height: 0, child: Divider()),
                                Row(
                                  spacing: 0,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        clipBehavior: Clip.antiAlias,
                                        borderRadius: BorderRadiusGeometry.only(
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        child: InkWell(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            height: 46,
                                            child: Center(
                                              child: Text(
                                                'Editar vehículo',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            await context.push(
                                              '/vehicles/updatevehicle/${vehicle.id}',
                                            );
                                            if (mounted) _loadData();
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 0,
                                      height:
                                          46, // mismo alto que tus “botones”
                                      child: VerticalDivider(
                                        color: Colors.grey,
                                        thickness: 1,
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          await context.push(
                                            '/workorders/addworkorder/${vehicle.id}',
                                          );
                                          ref.invalidate(
                                            workOrderFormProvider(vehicle.id!),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                            ),
                                            color: colors.primary.withOpacity(
                                              0.12,
                                            ),
                                          ),
                                          height: 46,
                                          child: Center(
                                            child: Text(
                                              'Crear Orden',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              context.push(
                                '/vehicles/detailvehicle/${vehicle.id}',
                              );
                            },
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
