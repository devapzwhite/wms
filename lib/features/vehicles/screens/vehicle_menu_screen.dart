import 'package:flutter/material.dart';
import 'package:wms/features/home/config/router/list_menu_items.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class VehicleMenuScreen extends StatelessWidget {
  final String title = "Menú de Vehículos";
  const VehicleMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: title),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            alignment: Alignment.center,
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              children: vehicleListMenuItems
                  .map((item) => HomeMenuCard(menuItem: item))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
