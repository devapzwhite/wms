import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/features/home/config/router/list_menu_items.dart';
import 'package:wms/features/home/presentation/providers/home_stats_provider.dart';
import 'package:wms/features/home/presentation/widgets/home_header_widget.dart';
import 'package:wms/features/home/presentation/widgets/home_stats_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(homeStatsProvider.notifier).loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: const HomeHeaderWidget()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeStatsWidget(),
                  const SizedBox(height: 24),
                  // Header de sección mejorado
                  _SectionHeader(
                    title: 'Módulos',
                    subtitle: 'Accede a las diferentes secciones',
                    icon: Icons.apps_rounded,
                  ),
                  const SizedBox(height: 16),
                  // Grid de módulos
                  _ModulesGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Header de sección con estilo moderno
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: colors.onPrimaryContainer, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Grid de módulos con tarjetas mejoradas
class _ModulesGrid extends StatelessWidget {
  const _ModulesGrid();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    // Determinar número de columnas según el tamaño de pantalla
    final crossAxisCount = isTablet ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: listMenuItems.length,
      itemBuilder: (context, index) {
        final item = listMenuItems[index];
        return _ModuleCard(menuItem: item, index: index);
      },
    );
  }
}

/// Tarjeta de módulo individual con estilo moderno
class _ModuleCard extends StatelessWidget {
  final dynamic menuItem;
  final int index;

  const _ModuleCard({required this.menuItem, required this.index});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Colores para cada tarjeta (variación)
    final cardColors = [
      (colors.primary, colors.primaryContainer),
      (colors.secondary, colors.secondaryContainer),
      (colors.tertiary, colors.tertiaryContainer),
      (colors.primary, colors.primaryContainer),
      (colors.secondary, colors.secondaryContainer),
      (colors.tertiary, colors.tertiaryContainer),
    ];

    final colorPair = cardColors[index % cardColors.length];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(menuItem.route),
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorPair.$2, colorPair.$2.withValues(alpha: 0.7)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colorPair.$1.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícono con fondo
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorPair.$1.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(menuItem.icon, size: 28, color: colorPair.$1),
                ),
                const SizedBox(height: 12),
                // Título
                Text(
                  menuItem.title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
