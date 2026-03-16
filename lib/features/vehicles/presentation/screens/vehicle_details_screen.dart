import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/config/enums/status_enum.dart';
import 'package:wms/config/enums/work_status_extension.dart';
import 'package:wms/domain/entities/customer_entity.dart';
import 'package:wms/domain/entities/workorder_entity.dart';
import 'package:wms/features/vehicles/presentation/providers/vehicle_detail_provider.dart';
import 'package:wms/features/workorders/presentation/providers/update_work_order_status_provider.dart';

class VehicleDetailsScreen extends ConsumerStatefulWidget {
  final int idVehiculo;
  const VehicleDetailsScreen({super.key, required this.idVehiculo});

  @override
  ConsumerState<VehicleDetailsScreen> createState() =>
      _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends ConsumerState<VehicleDetailsScreen> {
  Future<void> _refreshVehicle() async {
    // Recargar los datos del vehículo
    ref.invalidate(vehiclesDetailsNotifierProvider(widget.idVehiculo));
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = ref.watch(
      vehiclesDetailsNotifierProvider(widget.idVehiculo),
    );
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: colors.surface,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
              title: Text(
                vehicle.vehicle?.plate.toUpperCase() ?? 'Vehiculo',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                  letterSpacing: 2,
                ),
              ),
              background: _VehicleHeader(vehicle: vehicle),
            ),
          ),

          if (vehicle.customer != null)
            SliverToBoxAdapter(
              child: _CustomerCard(customer: vehicle.customer!),
            ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                children: [
                  Icon(Icons.build_outlined, size: 20, color: colors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Ordenes de Trabajo (${vehicle.orders.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          vehicle.orders.isEmpty
              ? SliverToBoxAdapter(child: _EmptyWorkOrders())
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _WorkOrderCard(
                        workOrder: vehicle.orders[index],
                        onEditComplete: _refreshVehicle,
                      ),
                      childCount: vehicle.orders.length,
                    ),
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _VehicleHeader extends StatelessWidget {
  final VehicleDetailState vehicle;
  const _VehicleHeader({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final v = vehicle.vehicle;
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primaryContainer.withOpacity(0.5), colors.surface],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (v?.vehicleType != null)
                _buildInfoChip(
                  context,
                  Icons.directions_car,
                  v!.vehicleType.nombre,
                ),
              if (v?.brand != null)
                _buildInfoChip(context, Icons.business, v!.brand),
              if (v?.model != null)
                _buildInfoChip(context, Icons.car_rental, v!.model),
              if (v?.year != null)
                _buildInfoChip(
                  context,
                  Icons.calendar_today,
                  v!.year.toString(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        avatar: Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final Customer customer;
  const _CustomerCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colors.primaryContainer,
                child: Icon(Icons.person, color: colors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${customer.name} ${customer.lastName}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.badge, size: 16, color: colors.outline),
                        const SizedBox(width: 4),
                        Text(
                          customer.documentId,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colors.outline),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (customer.phone != null)
                IconButton(
                  icon: Icon(Icons.phone, color: colors.primary),
                  onPressed: () {},
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyWorkOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: colors.outline),
            const SizedBox(height: 16),
            Text(
              'No hay Ordenes de trabajo',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: colors.outline),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkOrderCard extends StatelessWidget {
  final WorkOrder workOrder;
  final VoidCallback? onEditComplete;
  const _WorkOrderCard({required this.workOrder, this.onEditComplete});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final total =
        (workOrder.laborEstimate ?? 0) + (workOrder.partsEstimate ?? 0);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () =>
            context.push('/workorders/detailworkorder/${workOrder.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatusBadge(status: workOrder.status),
                  Text(
                    '$total CLP',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                workOrder.initialDiagnosis ?? 'Sin diagnostico',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (workOrder.notes?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Text(
                  workOrder.notes!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: colors.outline),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await context.push(
                          '/workorders/updateworkorder/${workOrder.id}',
                        );
                        // Recargar datos al regresar
                        onEditComplete?.call();
                      },
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Editar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () => _showStatusBottomSheet(context),
                      icon: const Icon(Icons.swap_horiz, size: 18),
                      label: const Text('Estado'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStatusBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _StatusBottomSheet(
        workOrder: workOrder,
        onStatusChanged: onEditComplete,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final WorkStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 16, color: status.color),
          const SizedBox(width: 6),
          Text(
            status.nombre,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBottomSheet extends ConsumerWidget {
  final WorkOrder workOrder;
  final VoidCallback? onStatusChanged;
  const _StatusBottomSheet({required this.workOrder, this.onStatusChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateStatus = ref.read(updateWorkOrderStatusProvider.notifier);
    final isLoading = ref.watch(updateWorkOrderStatusProvider).isLoading;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cambiar Estado',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: WorkStatus.values.length,
              itemBuilder: (context, index) {
                final status = WorkStatus.values[index];
                return ListTile(
                  leading: Icon(status.icon, color: status.color),
                  title: Text(status.nombre),
                  selected: workOrder.status == status,
                  enabled: !isLoading,
                  onTap: isLoading
                      ? null
                      : () async {
                          await updateStatus.updateStatus(
                            workOrder.id!,
                            status,
                          );
                          if (context.mounted) {
                            Navigator.pop(context);
                            onStatusChanged?.call();
                          }
                        },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
