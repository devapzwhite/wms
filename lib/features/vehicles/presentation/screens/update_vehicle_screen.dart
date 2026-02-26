import 'package:flutter/material.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class UpdateVehicleScreen extends StatelessWidget {
  final int idVehiculo;
  final String title = "Actualizar Vehículo";
  const UpdateVehicleScreen({super.key, required this.idVehiculo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: title),
      body: Center(
        child: Text(
          "Pantalla para actualizar un vehículo existente ${idVehiculo}",
        ),
      ),
    );
  }
}
