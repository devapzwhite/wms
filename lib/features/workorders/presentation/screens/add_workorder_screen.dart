import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateWorkorderScreen extends ConsumerStatefulWidget {
  final int idVehiculo;
  const CreateWorkorderScreen({super.key, required this.idVehiculo});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateWorkorderScreenState();
}

class _CreateWorkorderScreenState extends ConsumerState<CreateWorkorderScreen> {
  @override
  Widget build(BuildContext context) {
    final String title = 'Registrar orden';
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            // title: Text('Datos de la orden'),
            flexibleSpace: FlexibleSpaceBar(title: Text('Titulo del flexible')),
          ),
          SliverToBoxAdapter(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  child: Column(
                    spacing: 16,
                    children: [
                      Text('Registro de Orden'),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          label: Text('Numero de placa:'),
                          hint: Text(''),
                        ),
                        onChanged: (value) {},
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          label: Text('Numero de placa:'),
                          hint: Text(''),
                        ),
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Card(
                child: ListTile(
                  title: Text('Item ${index}'),
                  leading: Icon(Icons.abc),
                  trailing: Icon(Icons.abc),
                ),
              );
            }, childCount: 1),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
