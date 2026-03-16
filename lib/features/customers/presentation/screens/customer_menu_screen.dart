import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/features/customers/presentation/providers/customers_provider.dart';

class CustomerMenuScreen extends ConsumerStatefulWidget {
  const CustomerMenuScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerMenuScreenState();
}

class _CustomerMenuScreenState extends ConsumerState<CustomerMenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(customerNotifierProvider.notifier).loadCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final customersProvider = ref.watch(customerNotifierProvider);
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Clientes'), centerTitle: true),
      body: customersProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : customersProvider.customers.isEmpty
          ? _EmptyCustomers(colors: colors, textStyle: textStyle)
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        Icon(Icons.people, size: 20, color: colors.primary),
                        const SizedBox(width: 8),
                        Text(
                          '${customersProvider.customers.length} ${customersProvider.customers.length == 1 ? 'Cliente' : 'Clientes'}',
                          style: textStyle.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final customer = customersProvider.customers[index];
                      return _CustomerCard(
                        customer: customer,
                        onTap: () =>
                            context.push('/customers/details/${customer.id}'),
                        onEditTap: () => context.push(
                          '/customers/updatecustomer/${customer.id}',
                        ),
                      );
                    }, childCount: customersProvider.customers.length),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/customers/addcustomer'),
        icon: const Icon(Icons.person_add),
        label: const Text('Agregar cliente'),
      ),
    );
  }
}

class _EmptyCustomers extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textStyle;

  const _EmptyCustomers({required this.colors, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: colors.outline),
          const SizedBox(height: 16),
          Text(
            'No hay clientes registrados',
            style: textStyle.titleMedium?.copyWith(color: colors.outline),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón + para agregar el primero',
            style: textStyle.bodyMedium?.copyWith(color: colors.outline),
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final dynamic customer;
  final VoidCallback onTap;
  final VoidCallback onEditTap;

  const _CustomerCard({
    required this.customer,
    required this.onTap,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colors.primaryContainer,
                child: Text(
                  '${customer.name[0]}${customer.lastName[0]}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${customer.name} ${customer.lastName}',
                      style: textStyle.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: colors.outline,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            customer.address ?? 'Sin dirección',
                            style: textStyle.bodySmall?.copyWith(
                              color: colors.outline,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onEditTap,
                icon: Icon(Icons.edit_outlined),
                color: colors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
