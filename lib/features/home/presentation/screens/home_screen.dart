import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/features/home/config/router/list_menu_items.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBarCustom(title: "Bienvenido a WMS"),
      body: BodyMenuCards(),
    );
  }
}

class BodyMenuCards extends StatelessWidget {
  const BodyMenuCards({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: listMenuItems.map((item) {
              return HomeMenuCard(menuItem: item);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
