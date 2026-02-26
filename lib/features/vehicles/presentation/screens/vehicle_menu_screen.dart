import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/features/home/config/router/list_menu_items.dart';
import 'package:wms/features/vehicles/presentation/providers/form_add_vehicle_provider.dart';
import 'package:wms/features/vehicles/presentation/providers/vehicles_provider.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class VehicleMenuScreen extends ConsumerStatefulWidget {
  const VehicleMenuScreen({super.key});

  @override
  ConsumerState<VehicleMenuScreen> createState() => _VehicleMenuScreenState();
}

class _VehicleMenuScreenState extends ConsumerState<VehicleMenuScreen> {
  final String title = "Menú de Vehículos";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(vehiclesNotifierProvider.notifier).loadVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final vehiclesProvider = ref.watch(vehiclesNotifierProvider);
    ref.listen(formAddVehicleNotifierProvider, (previous, next) {
      if (!next.isSubmited) return;
      if (next.errorMessage != '') return;
      print('registrado!');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vehiculo registrado!')));
    });

    return Scaffold(
      appBar: AppBarCustom(title: title),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Wrap(
                spacing: 5,
                runSpacing: 5,
                children: [
                  //TODO: Refactorizar esto xd
                  Chip(
                    label: Text(
                      '${vehiclesProvider.vehicles.length.toString()} vehiculos',
                    ),
                    avatar: Icon(Icons.minor_crash_outlined),
                  ),
                  Chip(
                    label: Text(
                      'Autos: ${vehiclesProvider.vehicles.where((vehicle) => vehicle.vehicleType.nombre == 'Auto').length}',
                    ),
                  ),
                  Chip(
                    label: Text(
                      'Vagoneta: ${vehiclesProvider.vehicles.where((vehicle) => vehicle.vehicleType.nombre == 'Vagoneta').length}',
                    ),
                  ),
                  Chip(
                    label: Text(
                      'Furgon: ${vehiclesProvider.vehicles.where((vehicle) => vehicle.vehicleType.label == 'VAN').length}',
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            !vehiclesProvider.isLoading
                ? Expanded(
                    child: vehiclesProvider.vehicles.isNotEmpty
                        ? ListView.builder(
                            itemCount: vehiclesProvider.vehicles.length,
                            itemBuilder: (context, index) {
                              final vehicle = vehiclesProvider.vehicles[index];
                              return ListTile(
                                title: Text(vehicle.vehicleType.nombre),
                                subtitle: Text(vehicle.model),
                              );
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("No hay vehículos registrados"),
                          ),
                  )
                : CircularProgressIndicator(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/vehicles/addvehicle');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
