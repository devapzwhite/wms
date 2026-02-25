import 'package:flutter/material.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class MenuWorkordersScreen extends StatelessWidget {
  const MenuWorkordersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String title = 'Menu de ordenes';
    return Scaffold(appBar: AppBarCustom(title: title));
  }
}
