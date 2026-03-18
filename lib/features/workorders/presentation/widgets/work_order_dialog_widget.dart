import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wms/config/enums/status_enum.dart';
import 'package:wms/config/helpers/mappers.dart';
import 'package:wms/features/workorders/presentation/providers/form_work_order_provider.dart';

class FormAddWorkOrderItemDialogWidget extends ConsumerStatefulWidget {
  final int idVehicle;
  const FormAddWorkOrderItemDialogWidget({super.key, required this.idVehicle});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddWorkOrderItemDialogWidgetState();
}

class _AddWorkOrderItemDialogWidgetState
    extends ConsumerState<FormAddWorkOrderItemDialogWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController _typeCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _qtyCtrl;
  late final TextEditingController _priceCtrl;

  @override
  void initState() {
    super.initState();
    final data = ref.read(workOrderFormProvider(widget.idVehicle));
    _typeCtrl = TextEditingController(
      text: Mappers.textToWorkOrderItemType(data.type).nombre,
    );
    _descCtrl = TextEditingController(text: data.description);
    _qtyCtrl = TextEditingController(text: data.quantity.toString());
    _priceCtrl = TextEditingController(text: data.unitPrice.toString());
  }

  @override
  void dispose() {
    _typeCtrl.dispose();
    _descCtrl.dispose();
    _qtyCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerNotifier = ref.read(
      workOrderFormProvider(widget.idVehicle).notifier,
    );
    return AlertDialog(
      scrollable: true,
      title: const Text('Nuevo ítem', textAlign: TextAlign.center),
      content: SizedBox(
        width: double.maxFinite,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownMenuFormField<String>(
                  controller: _typeCtrl,
                  expandedInsets: EdgeInsets.all(12),
                  menuStyle: MenuStyle(elevation: WidgetStatePropertyAll(20)),
                  dropdownMenuEntries: WorkOrderItemType.values
                      .map(
                        (tipo) => DropdownMenuEntry(
                          value: tipo.label,
                          label: tipo.nombre,
                        ),
                      )
                      .toList(),

                  hintText: 'Seleccione un tipo de vehículo',
                  onSelected: (value) {
                    providerNotifier.onChangeTypeItem(value!);
                  },
                ),
                const SizedBox(height: 16),

                // Descripción
                _buildTextField(
                  controller: _descCtrl,
                  label: 'Descripción *',
                  validator: (value) =>
                      (value ?? '').isEmpty ? 'Requerido' : null,
                  maxLines: 3,
                  onChange: (value) {
                    providerNotifier.onChangeDescription(value);
                  },
                ),
                const SizedBox(height: 16),

                // Cantidad y precios
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _qtyCtrl,
                        label: 'Cantidad',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          final qty = int.tryParse(value);
                          return qty == null || qty <= 0
                              ? 'Cantidad válida'
                              : null;
                        },
                        onChange: (value) {
                          providerNotifier.onChangeQuantity(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _priceCtrl,
                        label: 'Precio (\$)',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChange: (value) {
                          providerNotifier.onChangeUnitPrice(value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Foto "Antes"
                _buildPhotoSection(
                  context: context,
                  label: 'Foto Antes',
                  photoFile: ref
                      .watch(workOrderFormProvider(widget.idVehicle))
                      .beforePhotoFile,
                  onPickFromCamera: () =>
                      providerNotifier.pickBeforePhotoFromCamera(),
                  onPickFromGallery: () =>
                      providerNotifier.pickBeforePhotoFromGallery(),
                  onClear: () => providerNotifier.clearBeforePhoto(),
                ),
                const SizedBox(height: 16),

                // Foto "Después"
                _buildPhotoSection(
                  context: context,
                  label: 'Foto Después',
                  photoFile: ref
                      .watch(workOrderFormProvider(widget.idVehicle))
                      .afterPhotoFile,
                  onPickFromCamera: () =>
                      providerNotifier.pickAfterPhotoFromCamera(),
                  onPickFromGallery: () =>
                      providerNotifier.pickAfterPhotoFromGallery(),
                  onClear: () => providerNotifier.clearAfterPhoto(),
                ),
                const SizedBox(height: 20),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          providerNotifier.cleanItem();
                          _typeCtrl.text = 'diagnostico';
                          _descCtrl.text = '';
                          _qtyCtrl.text = '1';
                          _priceCtrl.text = '0';
                          // formKey.currentState?.reset();
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Limpiar'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (formKey.currentState?.validate() == true) {
                            providerNotifier.addItem();
                            providerNotifier.cleanItem();
                            context.pop();
                          }
                        },
                        icon: const Icon(Icons.save, size: 18),
                        label: const Text('Guardar ítem'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
    Function(String)? onChange,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      validator: validator,
      onChanged: onChange,
    );
  }

  /// Widget para seleccionar y previsualizar fotos
  Widget _buildPhotoSection({
    required BuildContext context,
    required String label,
    required XFile? photoFile,
    required VoidCallback onPickFromCamera,
    required VoidCallback onPickFromGallery,
    required VoidCallback onClear,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        if (photoFile != null) ...[
          // Previsualización de la foto
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(photoFile.path),
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          // Botón para quitar la foto
          TextButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.close, size: 18),
            label: const Text('Quitar'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ] else ...[
          // Botones para seleccionar foto
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onPickFromCamera,
                  icon: const Icon(Icons.camera_alt, size: 18),
                  label: const Text('Cámara'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onPickFromGallery,
                  icon: const Icon(Icons.photo_library, size: 18),
                  label: const Text('Galería'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
