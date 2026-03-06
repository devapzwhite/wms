import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/config/enums/status_enum.dart';
import 'package:wms/config/helpers/mappers.dart';
import 'package:wms/features/workorders/presentation/providers/work_order_providers.dart';
import 'package:wms/features/workorders/presentation/widgets/work_orders_widgets.dart';

class CreateWorkorderScreen extends ConsumerStatefulWidget {
  final int idVehiculo;
  const CreateWorkorderScreen({super.key, required this.idVehiculo});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateWorkorderScreenState();
}

class _CreateWorkorderScreenState extends ConsumerState<CreateWorkorderScreen> {
  @override
  Widget build(BuildContext context) {
    final formdata = ref.watch(workOrderFormProvider(widget.idVehiculo));
    final formWorkOrderNP = ref.read(
      workOrderFormProvider(widget.idVehiculo).notifier,
    );
    ref.listen(workOrderFormProvider(widget.idVehiculo), (previous, next) {
      if (!next.onSubmit) return;
      final wasLoading = previous?.isLoading ?? false;
      if (wasLoading &&
          !next.isLoading &&
          previous!.errorMessage == '' &&
          next.errorMessage == '') {
        ref.invalidate(workOrderFormProvider(widget.idVehiculo));
        // context.go('/vehicles/detailvehicle/${widget.idVehiculo}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Orden Registrado Exitosamente!')),
        );
        context.pop();
      }
      if (wasLoading && !next.isLoading && next.errorMessage != '') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage)));
        ref
            .read(workOrderFormProvider(widget.idVehiculo).notifier)
            .clearResults();
      }
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '${formdata.vehicle?.plate} ${formdata.vehicle?.brand} ${formdata.vehicle?.model}',
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
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(child: Text('Estado de orden:')),
                          Flexible(
                            child: DropdownMenuFormField(
                              initialSelection: formdata.status,
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
                              onSelected: (value) =>
                                  formWorkOrderNP.onChangeStatus(value!),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        minLines: 3,
                        maxLines: 6,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          label: Text('Diagnostico inicial:'),
                        ),
                        onChanged: formWorkOrderNP.onChangeInitialDiagnosis,
                      ),
                      TextFormField(
                        minLines: 3,
                        maxLines: 6,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          label: Text('Observaciones:'),
                          hint: Text(''),
                        ),
                        onChanged: formWorkOrderNP.onChangeNotes,
                      ),
                      // Botones
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                //TODO: limpiar registro de orden
                              },
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
                              onPressed: () {
                                //TODO: registrar
                                formWorkOrderNP.onSubmit();
                              },
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
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = formdata.items[index];
              return Dismissible(
                key: ValueKey(item.hashCode),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  formWorkOrderNP.removeItem(index);
                },
                child: Card(
                  child: ListTile(
                    title: Text(
                      Mappers.textToWorkOrderItemType(item.itemType).nombre,
                    ),
                    subtitle: Text(
                      item.description,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            }, childCount: formdata.items.length),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) =>
                FormAddWorkOrderItemDialogWidget(idVehicle: widget.idVehiculo),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
