import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/domain/entities/entities.dart';
import 'package:wms/features/vehicles/presentation/providers/vehicle_detail_provider.dart';

class VehicleDetailsScreen extends ConsumerStatefulWidget {
  final int idVehiculo;
  const VehicleDetailsScreen({super.key, required this.idVehiculo});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateWorkorderScreenState();
}

class _CreateWorkorderScreenState extends ConsumerState<VehicleDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final String title = 'Detalle del Vehiculo';
    final vehicle = ref.watch(
      vehiclesDetailsNotifierProvider(widget.idVehiculo),
    );
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            flexibleSpace: FlexibleSpaceBar(title: Text(title)),
          ),
          SliverFloatingHeader(
            animationStyle: AnimationStyle(
              curve: Curves.bounceIn,
              reverseCurve: Curves.bounceInOut,
            ),
            // snapMode: FloatingHeaderSnapMode.scroll,
            child: Container(
              padding: EdgeInsets.all(10),
              height: 190,
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Chip(
                          label: Text(
                            'Document: ${vehicle.customer?.documentId ?? 'NO DOCUMENT!'}',
                          ),
                        ),
                        Chip(
                          label: Text(
                            '${vehicle.customer?.name} ${vehicle.customer?.lastName}',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Column(
                      children: [
                        Chip(
                          label: Text(
                            vehicle.vehicle?.plate.toUpperCase() ?? '',
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Chip(
                              label: Text(
                                vehicle.vehicle?.vehicleType.nombre ?? '',
                              ),
                            ),
                            Chip(
                              label: Text(vehicle.vehicle?.brand ?? 'NO BRAND'),
                            ),
                            Chip(
                              label: Text(vehicle.vehicle?.model ?? 'NO MODEL'),
                            ),
                            Chip(
                              label: Text(
                                vehicle.vehicle?.year.toString() ?? 'NO YEAR',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final workOrder = vehicle.orders[index];
              return Card(
                child: ListTile(
                  title: Text(
                    workOrder.initialDiagnosis ?? 'NO NOTE',
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Text(
                    '[ ${workOrder.status.nombre} ]',
                    style: TextStyle(fontSize: 15),
                  ),
                  trailing: Icon(Icons.abc),
                ),
              );
            }, childCount: vehicle.orders.length),
          ),
        ],
      ),
    );
  }
}
