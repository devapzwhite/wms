import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/features/home/presentation/providers/home_stats_provider.dart';
import 'package:wms/features/home/presentation/widgets/stats_card_widget.dart';

class HomeStatsWidget extends ConsumerWidget {
  const HomeStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(homeStatsProvider);
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Resumen',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: () {
                  ref.read(homeStatsProvider.notifier).refreshStats();
                },
                tooltip: 'Actualizar',
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            StatsCardWidget(
              icon: Icons.people_outline,
              title: 'Clientes',
              value: stats.totalCustomers,
              iconColor: Colors.blue,
            ),
            StatsCardWidget(
              icon: Icons.directions_car_outlined,
              title: 'Vehículos',
              value: stats.totalVehicles,
              iconColor: Colors.green,
            ),
            StatsCardWidget(
              icon: Icons.assignment_outlined,
              title: 'Órdenes Totales',
              value: stats.totalWorkOrders,
              iconColor: Colors.orange,
            ),
            StatsCardWidget(
              icon: Icons.pending_actions,
              title: 'Órdenes Abiertas',
              value: stats.openWorkOrders,
              iconColor: Colors.amber,
            ),
          ],
        ),
        if (stats.completedWorkOrders > 0) ...[
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: colors.primaryContainer.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: colors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Órdenes Completadas',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Text(
                          '${stats.completedWorkOrders} reparaciones finalizadas',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    stats.completedWorkOrders.toString(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
