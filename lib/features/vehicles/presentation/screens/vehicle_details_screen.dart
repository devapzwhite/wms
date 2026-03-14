import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    final colors = Theme.of(context).colorScheme;
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
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 4),
                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 10),
                              Chip(
                                labelStyle: TextStyle(),
                                label: SizedBox(
                                  child: Text(
                                    workOrder.status.nombre,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),

                              Chip(
                                label: Text(
                                  '${workOrder.laborEstimate.toString()}CLP',
                                ),
                              ),
                            ],
                          ),

                          Text(
                            workOrder.initialDiagnosis ??
                                'NO TIENE DIAGNOSTICO INICIAL',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      subtitle: Text(
                        workOrder.notes != null && workOrder.notes?.trim() != ''
                            ? workOrder.notes!
                            : 'NO TIENE OBSERVACIONES',
                        textAlign: TextAlign.center,
                      ),
                    ),
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
                                    'Editar',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              onTap: () async {
                                await context.push(
                                  '/workorders/updateworkorder/${workOrder.id}',
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 0,
                          height: 46, // mismo alto que tus “botones”
                          child: VerticalDivider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                ),
                                color: colors.primary.withOpacity(0.12),
                              ),
                              height: 46,
                              child: Center(
                                child: Text(
                                  'cambiar de estado',
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
              );
            }, childCount: vehicle.orders.length),
          ),
        ],
      ),
    );
  }
}
