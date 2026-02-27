import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/config/enums/tipo_vehiculo_enum.dart';
import 'package:wms/domain/entities/vehicle_entity.dart';
import 'package:wms/features/vehicles/presentation/providers/form_add_vehicle_provider.dart';
import 'package:wms/features/vehicles/presentation/providers/vehicles_provider.dart';
import 'package:wms/presentation/widgets/app_bar_custom_widget.dart';

class UpdateVehicleScreen extends ConsumerStatefulWidget {
  final int idVehiculo;
  const UpdateVehicleScreen({super.key, required this.idVehiculo});
  final String title = 'editar vehiculo';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateVehicleScreenState();
}

class _UpdateVehicleScreenState extends ConsumerState<UpdateVehicleScreen> {
  Vehicle? _vehicleData;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getVehicle();
    });
  }

  void _getVehicle() async {
    final vehicle = await ref
        .read(vehiclesNotifierProvider.notifier)
        .getVehicle(widget.idVehiculo);
    if (mounted) {
      setState(() {
        _vehicleData = vehicle;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(formAddVehicleNotifierProvider, (previous, next) {
      if (next.isSubmited == true) {
        if (next.errorMessage.isEmpty) {
          //sucess
          ref.read(formAddVehicleNotifierProvider.notifier).clearErrors();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Vehiculo modificado exitosamente!')),
          );
          context.pop();
        }
        if (next.errorMessage.isNotEmpty) {
          //error
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.errorMessage)));
          ref.read(formAddVehicleNotifierProvider.notifier).clearErrors();
        }
      }
    });
    ref.listen(vehiclesNotifierProvider, (previous, next) {
      if (previous?.errorMessage == '' && next.errorMessage != '') {
        ref.read(vehiclesNotifierProvider.notifier).clearErrors();
        context.pop();
      }
    });
    final vehiclesNotifier = ref.read(formAddVehicleNotifierProvider.notifier);
    final formState = ref.watch(
      formAddVehicleNotifierProvider,
    ); //solo para mantener vivo el provider
    return Scaffold(
      appBar: AppBarCustom(title: widget.title),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Chip(label: Text('Cliente: ${_vehicleData?.customerId}')),
                ],
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      spacing: 16,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            label: Text(
                              'Numero de placa: ${_vehicleData?.plate ?? ''}',
                            ),
                            hint: Text(_vehicleData?.plate ?? ''),
                          ),
                          onChanged: vehiclesNotifier.onPlateChanged,
                        ),
                        DropdownMenuFormField(
                          label: Text(
                            _vehicleData?.vehicleType.nombre ?? 'no selected',
                          ),
                          dropdownMenuEntries: [
                            ...TipoVehiculo.values.map(
                              (tipo) => DropdownMenuEntry(
                                value: tipo.label,
                                label: tipo.nombre,
                              ),
                            ),
                          ],
                          onSelected: vehiclesNotifier.onTypeChanged,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            label: Text('Marca: ${_vehicleData?.brand ?? ''}'),
                            hint: Text(_vehicleData?.brand ?? ''),
                          ),
                          onChanged: vehiclesNotifier.onBrandChanged,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            label: Text('Modelo: ${_vehicleData?.model ?? ''}'),
                            hint: Text(_vehicleData?.model ?? ''),
                          ),
                          onChanged: vehiclesNotifier.onModelChanged,
                        ),

                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            label: Text('Año: ${_vehicleData?.year ?? ''}'),
                            hint: Text(_vehicleData?.year.toString() ?? ''),
                          ),
                          onChanged: vehiclesNotifier.onYearChanged,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 20,
                          children: [
                            FilledButton.tonal(
                              onPressed: () async {
                                vehiclesNotifier.onUpdateVehicle(
                                  widget.idVehiculo,
                                );
                              },
                              child: Text('Guardar'),
                            ),
                            FilledButton.tonal(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  Colors.red.shade700,
                                ),
                                foregroundColor: WidgetStateProperty.all(
                                  Colors.white,
                                ),
                              ),
                              onPressed: () {
                                context.pop();
                              },
                              child: Text('cancelar'),
                            ),
                          ],
                        ),
                      ],
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
