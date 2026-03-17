import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wms/features/customers/presentation/providers/customer_detail_provider.dart';
import 'package:wms/features/workorders/presentation/providers/work_order_providers.dart';

class CustomerDetailScreen extends ConsumerStatefulWidget {
  final int idCustomer;
  const CustomerDetailScreen({super.key, required this.idCustomer});

  @override
  ConsumerState<CustomerDetailScreen> createState() =>
      _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends ConsumerState<CustomerDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  void _loadData() {
    ref
        .read(customerDetailNotifierProvider.notifier)
        .loadDetailsCustomer(widget.idCustomer);
  }

  @override
  Widget build(BuildContext context) {
    final customerData = ref.watch(customerDetailNotifierProvider);
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      body: customerData.isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // AppBar con gradiente
                SliverAppBar(
                  expandedHeight: 220,
                  pinned: true,
                  backgroundColor: colors.surface,
                  surfaceTintColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 56, bottom: 16),

                    title: Text(
                      '${customerData.customer.name} ${customerData.customer.lastName}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colors.primaryContainer.withOpacity(0.8),
                            colors.surface,
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: colors.primary,
                              child: Text(
                                '${customerData.customer.name.trim().isEmpty ? '' : customerData.customer.name[0].toUpperCase()}${customerData.customer.lastName.trim().isEmpty ? '' : customerData.customer.lastName[0].toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: colors.onPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'RUT: ${customerData.customer.documentId}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Información de contacto
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _ContactSection(
                      customer: customerData.customer,
                      colors: colors,
                    ),
                  ),
                ),

                // Sección de vehículos
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.directions_car,
                            size: 20,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Vehículos (${customerData.vehicles.length})',
                          style: textStyle.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Lista de vehículos
                customerData.vehicles.isEmpty
                    ? SliverToBoxAdapter(
                        child: _EmptyState(
                          icon: Icons.directions_car_outlined,
                          title: 'Sin vehículos',
                          subtitle: 'Agrega el primer vehículo de este cliente',
                          colors: colors,
                          textStyle: textStyle,
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final vehicle = customerData.vehicles[index];
                            return _VehicleCard(
                              vehicle: vehicle,
                              colors: colors,
                              textStyle: textStyle,
                              onEditTap: () async {
                                await context.push(
                                  '/vehicles/updatevehicle/${vehicle.id}',
                                );
                                if (mounted) _loadData();
                              },
                              onCreateOrderTap: () async {
                                await context.push(
                                  '/workorders/addworkorder/${vehicle.id}',
                                );
                                ref.invalidate(
                                  workOrderFormProvider(vehicle.id!),
                                );
                              },
                              onTap: () {
                                context.push(
                                  '/vehicles/detailvehicle/${vehicle.id}',
                                );
                              },
                            );
                          }, childCount: customerData.vehicles.length),
                        ),
                      ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/vehicles/addvehicle/${widget.idCustomer}');
          if (mounted) _loadData();
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Vehículo'),
        backgroundColor: colors.primaryContainer,
        foregroundColor: colors.primary,
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  final dynamic customer;
  final ColorScheme colors;

  const _ContactSection({required this.customer, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _ContactTile(
            icon: Icons.email_outlined,
            label: 'Correo',
            value: customer.email ?? 'No registrado',
            colors: colors,
          ),
          const Divider(height: 24),
          _WhatsAppTile(phone: customer.phone, colors: colors),
          const Divider(height: 24),
          _ContactTile(
            icon: Icons.location_on_outlined,
            label: 'Dirección',
            value: customer.address ?? 'No registrada',
            colors: colors,
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colors;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.primaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: colors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: colors.outline),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WhatsAppTile extends StatelessWidget {
  final String phone;
  final ColorScheme colors;

  const _WhatsAppTile({required this.phone, required this.colors});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final cleanPhone = phone.replaceAll('+', '').replaceAll(' ', '');
        await launchUrl(Uri.parse('https://wa.me/$cleanPhone'));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade700, Colors.green.shade500],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.chat, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    phone,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Contactar por WhatsApp',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ColorScheme colors;
  final TextTheme textStyle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.primaryContainer.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: colors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: textStyle.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: textStyle.bodyMedium?.copyWith(color: colors.outline),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final dynamic vehicle;
  final ColorScheme colors;
  final TextTheme textStyle;
  final VoidCallback onEditTap;
  final VoidCallback onCreateOrderTap;
  final VoidCallback onTap;

  const _VehicleCard({
    required this.vehicle,
    required this.colors,
    required this.textStyle,
    required this.onEditTap,
    required this.onCreateOrderTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Header del vehículo
            InkWell(
              onTap: onTap,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.directions_car,
                        color: colors.onPrimary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.brand.toString().toUpperCase(),
                            style: textStyle.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${vehicle.model} • ${vehicle.year}',
                            style: textStyle.bodyMedium?.copyWith(
                              color: colors.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Botones de acción
            Container(
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: onEditTap,
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Editar'),
                      style: TextButton.styleFrom(
                        foregroundColor: colors.primary,
                      ),
                    ),
                  ),
                  Container(width: 1, height: 24, color: colors.outlineVariant),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: onCreateOrderTap,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Crear Orden'),
                      style: TextButton.styleFrom(
                        foregroundColor: colors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
