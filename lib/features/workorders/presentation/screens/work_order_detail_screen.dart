import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/config/enums/status_enum.dart';
import 'package:wms/features/workorders/presentation/providers/work_order_detail_providers.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class WorkOrderDetailScreen extends ConsumerWidget {
  final int idWorkOrder;

  const WorkOrderDetailScreen({super.key, required this.idWorkOrder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String title = 'Detalle de Orden de Trabajo';
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(workOrderNotifierProvider(idWorkOrder));

    if (state.isLoading) {
      return Scaffold(
        appBar: AppBarCustom(title: title),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBarCustom(title: title),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: colors.error),
              const SizedBox(height: 16),
              Text('Error: ${state.errorMessage}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(workOrderNotifierProvider(idWorkOrder).notifier)
                      .refresh();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final workOrder = state.workOrder;
    if (workOrder == null) {
      return Scaffold(
        appBar: AppBarCustom(title: title),
        body: const Center(child: Text('Orden de trabajo no encontrada')),
      );
    }

    return Scaffold(
      appBar: AppBarCustom(title: title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estado de la orden
            _buildStatusSection(context, workOrder.status),
            const SizedBox(height: 24),

            // Diagnóstico inicial
            _buildSectionTitle(context, 'Diagnóstico Inicial'),
            const SizedBox(height: 8),
            _buildContentCard(
              context,
              workOrder.initialDiagnosis ?? 'Sin diagnóstico inicial',
            ),
            const SizedBox(height: 24),

            // Notas
            _buildSectionTitle(context, 'Notas'),
            const SizedBox(height: 8),
            _buildContentCard(
              context,
              workOrder.notes?.isNotEmpty == true
                  ? workOrder.notes!
                  : 'Sin notas',
            ),
            const SizedBox(height: 24),

            // Fechas
            _buildSectionTitle(context, 'Fechas'),
            const SizedBox(height: 8),
            _buildDatesCard(context, workOrder),
            const SizedBox(height: 24),

            // Estimaciones
            if (workOrder.laborEstimate != null ||
                workOrder.partsEstimate != null) ...[
              _buildSectionTitle(context, 'Estimaciones'),
              const SizedBox(height: 8),
              _buildEstimationsCard(context, workOrder),
              const SizedBox(height: 24),
            ],

            // Ítems de la orden
            _buildSectionTitle(
              context,
              'Ítems (${state.workOrderItem.length})',
            ),
            const SizedBox(height: 8),
            if (state.workOrderItem.isEmpty)
              _buildContentCard(context, 'No hay ítems registrados')
            else
              ...state.workOrderItem.map(
                (item) => _buildItemCard(context, item),
              ),
          ],
        ),
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

  Widget _buildStatusSection(BuildContext context, WorkStatus status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(_getStatusIcon(status), size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Estado'),
                Text(
                  status.nombre,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
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
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildContentCard(BuildContext context, String content) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16), child: Text(content)),
    );
  }

  Widget _buildDatesCard(BuildContext context, dynamic workOrder) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (workOrder.checkIn != null)
              _buildDateRow(context, 'Check-in', workOrder.checkIn!),
            if (workOrder.checkOut != null)
              _buildDateRow(context, 'Check-out', workOrder.checkOut!),
            if (workOrder.createdAt != null)
              _buildDateRow(context, 'Creado', workOrder.createdAt!),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRow(BuildContext context, String label, DateTime date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
          ),
        ],
      ),
    );
  }

  Widget _buildEstimationsCard(BuildContext context, dynamic workOrder) {
    final labor = workOrder.laborEstimate ?? 0;
    final parts = workOrder.partsEstimate ?? 0;
    final total = labor + parts;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildEstimationRow(context, 'Mano de obra', labor),
            const Divider(),
            // _buildEstimationRow(context, 'Repuestos', double.parse(parts)),
            // const Divider(),
            _buildEstimationRow(context, 'Total', total, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildEstimationRow(
    BuildContext context,
    String label,
    double amount, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? const TextStyle(fontWeight: FontWeight.bold)
                : null,
          ),
          Text(
            '${amount.toStringAsFixed(0)} CLP',
            style: isTotal
                ? const TextStyle(fontWeight: FontWeight.bold)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, dynamic item) {
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
                if (item.quantity != null)
                  Text(
                    'x${item.quantity}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.description),
            if (item.unitPrice != null) ...[
              const SizedBox(height: 8),
              Text(
                'Precio unitario: ${item.unitPrice!.toStringAsFixed(0)} CLP',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (item.quantity != null)
                Text(
                  'Subtotal: ${(item.unitPrice! * item.quantity!).toStringAsFixed(0)} CLP',
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
