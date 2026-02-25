import 'package:flutter/material.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class UpdateCustomerScreen extends StatelessWidget {
  final int idCustomer;
  const UpdateCustomerScreen({super.key, required this.idCustomer});
  final String title = "Actualizar Cliente";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: title),
      body: Center(child: Text('customerId ${idCustomer.toString()}')),
    );
  }
}
