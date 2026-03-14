import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/features/home/config/router/list_menu_items.dart';
import 'package:wms/features/home/presentation/providers/home_stats_provider.dart';
import 'package:wms/features/home/presentation/widgets/home_header_widget.dart';
import 'package:wms/features/home/presentation/widgets/home_menu_card_widget.dart';
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
                  Text(
                    'Navegación',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const BodyMenuCards(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BodyMenuCards extends StatelessWidget {
  const BodyMenuCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.start,
      children: listMenuItems.map((item) {
        return HomeMenuCard(menuItem: item);
      }).toList(),
    );
  }
}
