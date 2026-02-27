import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/config/enums/tipo_vehiculo_enum.dart';
import 'package:wms/features/customers/presentation/providers/customers_provider.dart';
import 'package:wms/features/vehicles/presentation/providers/form_add_vehicle_provider.dart';
import 'package:wms/presentation/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class AddVehicleScreen extends ConsumerStatefulWidget {
  final int? idCliente;
  const AddVehicleScreen({this.idCliente, super.key});

  @override
  ConsumerState<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends ConsumerState<AddVehicleScreen> {
  final String title = "Registrar Vehículo";
  ValueNotifier<bool> clientIsSelected = ValueNotifier(
    false,
  ); // Cambia a true para mostrar el formulario de vehículo directamente

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _initValues();
    });
  }

  void _initValues() {
    ref.read(customerNotifierProvider.notifier).loadCustomers();
    if (widget.idCliente != null) {
      ref
          .read(formAddVehicleNotifierProvider.notifier)
          .onClientIdSelected(widget.idCliente!);
      clientIsSelected.value = true;
    }
  }

  @override
  void dispose() {
    clientIsSelected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerNotifierProvider).customers;
    final formAddVehicleProvider = ref.read(
      formAddVehicleNotifierProvider.notifier,
    );
    ref.listen(formAddVehicleNotifierProvider, (previous, next) {
      if (next.isSubmited && next.errorMessage == '') {
        context.pop();
        return;
      }
      if (previous?.errorMessage == next.errorMessage) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error al registrar Vehiculo'),
          content: Text(next.errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(formAddVehicleNotifierProvider.notifier).clearErrors();
                if (mounted) context.pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    });

    final colors = Theme.of(context).colorScheme;

    String _getNameCustomer(int idCustomer) {
      final customer = customers
          .where((customer) => customer.id == widget.idCliente)
          .first;
      return '${customer.name} ${customer.lastName}';
    }

    return Scaffold(
      appBar: AppBarCustom(title: title),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    child: Column(
                      children: [
                        widget.idCliente == null
                            ? DropdownButtonFormField(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: "Cliente",
                                  hint: Text(
                                    "Seleccione un cliente",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                items: List<DropdownMenuItem>.from(
                                  customers.map((customer) {
                                    return DropdownMenuItem(
                                      value: customer.id,
                                      child: Text(
                                        '${customer.name} ${customer.lastName}',
                                      ),
                                    );
                                  }),
                                ),
                                onChanged: (value) {
                                  print('Cliente seleccionado: ${value}');
                                  if (value == null) return;
                                  formAddVehicleProvider.onClientIdSelected(
                                    value,
                                  );
                                  clientIsSelected.value =
                                      value !=
                                      null; // Aquí se actualizaría el estado para mostrar el formulario de vehículo
                                },
                              )
                            : TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: _getNameCustomer(
                                    widget.idCliente!,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged:
                                    formAddVehicleProvider.onBrandChanged,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: clientIsSelected,
              builder: (context, value, child) {
                if (value) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Form(
                          child: Column(
                            children: [
                              DropdownMenuFormField(
                                expandedInsets: EdgeInsets.all(12),
                                dropdownMenuEntries: TipoVehiculo.values
                                    .map(
                                      (tipo) => DropdownMenuEntry(
                                        value: tipo.label,
                                        label: tipo.nombre,
                                      ),
                                    )
                                    .toList(),

                                hintText: 'Seleccione un tipo de vehículo',
                                onSelected: (value) =>
                                    formAddVehicleProvider.onTypeChanged(value),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Placa",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged:
                                    formAddVehicleProvider.onPlateChanged,
                              ),

                              SizedBox(height: 20),

                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Marca",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged:
                                    formAddVehicleProvider.onBrandChanged,
                              ),
                              SizedBox(height: 20),

                              Row(
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: "Modelo",
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged:
                                          formAddVehicleProvider.onModelChanged,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "AÑO",
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged:
                                          formAddVehicleProvider.onYearChanged,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton.filledTonal(
                                    onPressed: () {
                                      ref
                                          .read(
                                            formAddVehicleNotifierProvider
                                                .notifier,
                                          )
                                          .onSubmit();
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
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "Seleccione un cliente para registrar un vehículo",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
