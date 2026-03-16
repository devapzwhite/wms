import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/config/enums/status_enum.dart';
import 'package:wms/features/workorders/presentation/providers/update_work_order_provider.dart';
import 'package:wms/features/workorders/presentation/widgets/largue_text_form_field_widget.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class UpdateWorkOrderScreen extends ConsumerStatefulWidget {
  final int idWorkOrder;

  const UpdateWorkOrderScreen({super.key, required this.idWorkOrder});

  @override
  ConsumerState<UpdateWorkOrderScreen> createState() =>
      _UpdateWorkOrderScreenState();
}

class _UpdateWorkOrderScreenState extends ConsumerState<UpdateWorkOrderScreen> {
  late final TextEditingController _diagnosisController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _diagnosisController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(updateWorkOrderProvider(widget.idWorkOrder));
    final notifier = ref.read(
      updateWorkOrderProvider(widget.idWorkOrder).notifier,
    );
    final colors = Theme.of(context).colorScheme;

    // Inicializar controllers cuando se cargan los datos
    if (state.workOrder != null &&
        _diagnosisController.text.isEmpty &&
        state.initialDiagnosis.isNotEmpty) {
      _diagnosisController.text = state.initialDiagnosis;
    }
    if (state.workOrder != null &&
        _notesController.text.isEmpty &&
        state.notes.isNotEmpty) {
      _notesController.text = state.notes;
    }

    ref.listen(updateWorkOrderProvider(widget.idWorkOrder), (previous, next) {
      if (next.isSuccess && previous?.isSuccess != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Orden de trabajo actualizada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
      if (next.errorMessage.isNotEmpty &&
          previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage),
            backgroundColor: colors.error,
          ),
        );
        notifier.clearError();
      }
    });

    return Scaffold(
      appBar: AppBarCustom(
        title: 'Editar Orden de Trabajo',
        actions: [
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: state.isLoading && state.workOrder == null
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(context, state, notifier),
    );
  }

  Widget _buildContent(
    BuildContext context,
    UpdateWorkOrderState state,
    UpdateWorkOrderNotifier notifier,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVehicleCard(context, state),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Estado de la Orden'),
          const SizedBox(height: 8),
          _buildStatusDropdown(context, state, notifier),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Diagnóstico Inicial'),
          const SizedBox(height: 8),
          CustomLargeTextFormField(
            controller: _diagnosisController,
            minLines: 3,
            maxLines: 6,
            borderRadius: 10,
            label: 'Diagnóstico inicial',
            hintText: 'Ingrese el diagnóstico inicial',
            onChanged: notifier.onChangeInitialDiagnosis,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Notas / Observaciones'),
          const SizedBox(height: 8),
          CustomLargeTextFormField(
            controller: _notesController,
            minLines: 3,
            maxLines: 6,
            borderRadius: 10,
            label: 'Notas',
            hintText: 'Ingrese notas u observaciones',
            onChanged: notifier.onChangeNotes,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Ítems (${state.items.length})'),
          const SizedBox(height: 8),
          if (state.items.isEmpty)
            _buildEmptyItemsCard(context)
          else
            ...state.items.asMap().entries.map(
              (entry) =>
                  _buildItemCard(context, entry.value, entry.key, notifier),
            ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: state.isLoading ? null : notifier.onSubmit,
              icon: const Icon(Icons.save),
              label: const Text('Guardar Cambios'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildVehicleCard(BuildContext context, UpdateWorkOrderState state) {
    final vehicle = state.vehicle;
    final customer = state.customer;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.directions_car, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle != null
                            ? '${vehicle.brand} ${vehicle.model}'
                            : 'Cargando...',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (vehicle != null)
                        Text(
                          '${vehicle.plate} | ${vehicle.year}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (customer != null) ...[
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.person, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${customer.name} ${customer.lastName}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown(
    BuildContext context,
    UpdateWorkOrderState state,
    UpdateWorkOrderNotifier notifier,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: DropdownButtonFormField<String>(
          value: state.status,
          isExpanded: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.flag),
          ),
          items: WorkStatus.values.map((status) {
            return DropdownMenuItem(
              value: status.label,
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(status),
                    size: 20,
                    color: _getStatusColor(status),
                  ),
                  const SizedBox(width: 12),
                  Text(status.nombre),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) notifier.onChangeStatus(value);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyItemsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 8),
              Text(
                'No hay ítems registrados',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    dynamic item,
    int index,
    UpdateWorkOrderNotifier notifier,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    _getItemTypeLabel(item.itemType),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => notifier.removeItem(index),
                  color: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.description ?? ''),
            if (item.quantity != null && item.unitPrice != null) ...[
              const SizedBox(height: 8),
              Text(
                'Cantidad: ${item.quantity} x ${item.unitPrice!.toStringAsFixed(0)} CLP',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                'Subtotal: ${(item.quantity! * item.unitPrice!).toStringAsFixed(0)} CLP',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(WorkStatus status) {
    switch (status) {
      case WorkStatus.received:
        return Icons.inbox;
      case WorkStatus.inProgress:
        return Icons.build;
      case WorkStatus.completed:
        return Icons.check_circle;
      case WorkStatus.readyForDelivery:
        return Icons.local_shipping;
      case WorkStatus.canceled:
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  Color _getStatusColor(WorkStatus status) {
    switch (status) {
      case WorkStatus.received:
        return Colors.blue;
      case WorkStatus.inProgress:
        return Colors.orange;
      case WorkStatus.completed:
        return Colors.green;
      case WorkStatus.readyForDelivery:
        return Colors.purple;
      case WorkStatus.canceled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getItemTypeLabel(String itemType) {
    switch (itemType.toUpperCase()) {
      case 'DIAGNOSIS':
        return 'Diagnóstico';
      case 'LABOR':
        return 'Mano de obra';
      case 'PART':
        return 'Repuesto';
      case 'OTHER':
        return 'Otro';
      default:
        return itemType;
    }
  }
}
