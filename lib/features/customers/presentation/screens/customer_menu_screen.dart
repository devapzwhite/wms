import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/features/home/config/router/list_menu_items.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class CustomerMenuScreen extends ConsumerWidget {
  const CustomerMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String title = "Menú de Clientes";
    return Scaffold(
      appBar: AppBarCustom(title: title),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              children: customerListMenuItems.map((item) {
                return HomeMenuCard(menuItem: item);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
