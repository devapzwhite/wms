import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkOrderDetailsScreen extends ConsumerStatefulWidget {
  final int idVehiculo;
  const WorkOrderDetailsScreen({super.key, required this.idVehiculo});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateWorkorderScreenState();
}

class _CreateWorkorderScreenState
    extends ConsumerState<WorkOrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final String title = 'Registrar orden';
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBarCustom(title: title),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            // title: Text('Datos de la orden'),
            flexibleSpace: FlexibleSpaceBar(title: Text('Titulo del flexible')),
          ),
          SliverFloatingHeader(
            animationStyle: AnimationStyle(
              curve: Curves.bounceIn,
              reverseCurve: Curves.bounceInOut,
            ),
            // snapMode: FloatingHeaderSnapMode.scroll,
            child: Container(
              padding: EdgeInsets.all(10),
              height: 190,
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Chip(label: Text('ID:')),
                        Chip(label: Text('Nombre Completo')),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Column(
                      children: [
                        Chip(label: Text('PLACA123')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Chip(label: Text('TIPO')),
                            Chip(label: Text('Marca')),
                            Chip(label: Text('Modelo')),
                            Chip(label: Text('anio')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Card(
                child: ListTile(
                  title: Text('Item'),
                  leading: Icon(Icons.abc),
                  trailing: Icon(Icons.abc),
                ),
              );
            }, childCount: 20),
          ),
        ],
      ),
    );
  }
}
