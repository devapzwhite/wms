import 'package:flutter/material.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class AddCustomerScreen extends StatelessWidget {
  final title = "Agregar Nuevo Cliente";
  const AddCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBarCustom(title: title));
  }
}
