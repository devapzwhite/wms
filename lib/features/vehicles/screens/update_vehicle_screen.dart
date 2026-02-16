import 'package:flutter/material.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class UpdateVehicleScreen extends StatelessWidget {
  final String title = "Actualizar Vehículo";
  const UpdateVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: title),
      body: Center(
        child: Text("Pantalla para actualizar un vehículo existente"),
      ),
    );
  }
}
