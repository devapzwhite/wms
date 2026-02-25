import 'package:flutter/material.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class CreateWorkorderScreen extends StatelessWidget {
  const CreateWorkorderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String title = 'Registrar orden';
    return Scaffold(appBar: AppBarCustom(title: title));
  }
}
