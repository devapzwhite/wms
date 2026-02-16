import 'package:flutter/material.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class AddVehicleScreen extends StatelessWidget {
  final String title = "Registrar Nuevo Vehículo";
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: title),
      body: Center(child: Text("Pantalla para registrar un nuevo vehículo")),
    );
  }
}
