import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/config/enums/status_enum.dart';
import 'package:wms/config/helpers/mappers.dart';
import 'package:wms/features/workorders/presentation/providers/work_order_providers.dart';
import 'package:wms/features/workorders/presentation/widgets/work_orders_widgets.dart';

class UpdateWorkOrderScreen extends ConsumerStatefulWidget {
  final int idWorkOrder;
  const UpdateWorkOrderScreen({super.key, required this.idWorkOrder});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateWorkorderScreenState();
}

class _CreateWorkorderScreenState extends ConsumerState<UpdateWorkOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Datos del vehiculo',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  child: Column(
                    spacing: 16,
                    children: [
                      Text(
                        'Registro de Orden',
                        style: TextTheme.of(context).titleLarge,
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          Flexible(child: Text('Estado de orden:')),
                          Flexible(
                            child: DropdownMenuFormField(
                              initialSelection: 'RECIBIDO',
                              expandedInsets: EdgeInsets.all(12),
                              dropdownMenuEntries: WorkStatus.values
                                  .map(
                                    (tipo) => DropdownMenuEntry(
                                      value: tipo.label,
                                      label: tipo.nombre,
                                    ),
                                  )
                                  .toList(),

                              hintText: 'Seleccione el estado',
                              onSelected: (value) {},
                            ),
                          ),
                        ],
                      ),
                      CustomLargeTextFormField(
                        minLines: 3,
                        maxLines: 6,
                        borderRadius: 10,
                        label: 'Diagnostico inicial:',
                        onChanged: (value) {},
                      ),
                      CustomLargeTextFormField(
                        minLines: 3,
                        maxLines: 6,
                        borderRadius: 10,
                        label: 'Observaciones:',
                        onChanged: (value) {},
                      ),
                      // Botones
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('Limpiar'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.save, size: 18),
                              label: const Text('Registrar Orden'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
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
          // SliverList(
          //   delegate: SliverChildBuilderDelegate((context, index) {
          //     final item = formdata.items[index];

          //     return ItemDimissible(
          //       item: item,
          //       index: index,
          //       onDismissed: (direction) {
          //         formWorkOrderNP.removeItem(index);
          //       },
          //     );
          //   }, childCount: formdata.items.length),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // await showDialog(
          //   context: context,
          //   builder: (context) =>
          //       FormAddWorkOrderItemDialogWidget(idVehicle: widget.idVehiculo),
          // );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
