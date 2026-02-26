import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/presentation/widgets/widgets.dart';

class CreateWorkorderScreen extends ConsumerStatefulWidget {
  const CreateWorkorderScreen({super.key});

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
      appBar: AppBarCustom(title: title),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            children: [
              SizedBox(
                width: size.width,
                child: Card(
                  elevation: 8,
                  child: Text('Holaa', textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
