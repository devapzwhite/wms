import 'package:flutter/material.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class UpdateCustomerScreen extends StatelessWidget {
  const UpdateCustomerScreen({super.key});
  final String title = "Actualizar Cliente";

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBarCustom(title: title));
  }
}
