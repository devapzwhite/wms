import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wms/config/helpers/mappers.dart';
import 'package:wms/domain/entities/entities.dart';
import 'package:wms/features/vehicles/presentation/providers/vehicles_provider.dart';
import 'package:wms/features/workorders/errors/work_order_errors.dart';
import 'package:wms/features/workorders/presentation/providers/work_order_repository_provider.dart';
import 'package:wms/features/workorders/presentation/providers/work_order_item_repository_provider.dart';

final workOrderFormProvider =
    NotifierProvider.family<WorkOrderFormNotifier, FormWorkOrderState, int>(
      WorkOrderFormNotifier.new,
    );

class WorkOrderFormNotifier extends Notifier<FormWorkOrderState> {
  final int idVehicle;
  final ImagePicker _imagePicker = ImagePicker();

  WorkOrderFormNotifier(this.idVehicle);
  @override
  FormWorkOrderState build() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
    return FormWorkOrderState(vehicleId: idVehicle);
  }

  void _loadData() async {
    //TODO: Traer datos del vehiculo para mostrar datos
    // state = state.copyWith(vehicleId: idVehicle);
    final vehicle = await ref
        .read(vehiclesNotifierProvider.notifier)
        .getVehicle(idVehicle);
    if (ref.mounted) {
      state = state.copyWith(vehicle: vehicle);
    }
  }

  /// Seleccionar foto "antes" de la cámara
  Future<void> pickBeforePhotoFromCamera() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (photo != null) {
      state = state.copyWith(beforePhotoFile: photo);
    }
  }

  /// Seleccionar foto "antes" de la galería
  Future<void> pickBeforePhotoFromGallery() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (photo != null) {
      state = state.copyWith(beforePhotoFile: photo);
    }
  }

  /// Seleccionar foto "después" de la cámara
  Future<void> pickAfterPhotoFromCamera() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (photo != null) {
      state = state.copyWith(afterPhotoFile: photo);
    }
  }

  /// Seleccionar foto "después" de la galería
  Future<void> pickAfterPhotoFromGallery() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (photo != null) {
      state = state.copyWith(afterPhotoFile: photo);
    }
  }

  /// Limpiar foto "antes"
  void clearBeforePhoto() {
    state = state.copyWith(clearBeforePhotoFile: true);
  }

  /// Limpiar foto "después"
  void clearAfterPhoto() {
    state = state.copyWith(clearAfterPhotoFile: true);
  }

  void cleanItem() {
    state = state.copyWith(
      type: 'DIAGNOSIS',
      description: '',
      quantity: 1,
      unitPrice: 0,
      clearBeforePhotoFile: true,
      clearAfterPhotoFile: true,
    );
  }

  void removeItem(int index) {
    final newList = List<WorkOrderItem>.from(state.items);
    newList.removeAt(index);
    state = state.copyWith(items: newList);
  }

  void onChangeStatus(String value) {
    final status = value;
    state = state.copyWith(status: status);
  }

  void onChangeInitialDiagnosis(String value) {
    final initialDiagnosis = value;
    state = state.copyWith(initialDiagnosis: initialDiagnosis);
  }

  void onChangeNotes(String value) {
    final notes = value;
    state = state.copyWith(notes: notes);
  }

  void onChangeTypeItem(String value) {
    final type = value;
    state = state.copyWith(type: type);
  }

  void onChangeDescription(String value) {
    final description = value;
    state = state.copyWith(description: description);
  }

  void onChangeQuantity(String value) {
    final quantity = int.tryParse(value) ?? 1;
    state = state.copyWith(quantity: quantity);
  }

  void onChangeUnitPrice(String value) {
    final unitPrice = double.tryParse(value) ?? 0;
    state = state.copyWith(unitPrice: unitPrice);
  }

  /// Añade un ítem. Si hay fotos, las sube primero al backend.
  /// Requiere que ya exista una work order (workOrderId).
  void addItem({int? workOrderId}) {
    final isValid =
        true; //TODO: hacer metodo que devuelve bool para validar campos
    if (!isValid) return;

    // Si hay fotos y tenemos un workOrderId, subimos el ítem con fotos
    if (workOrderId != null &&
        (state.beforePhotoFile != null || state.afterPhotoFile != null)) {
      _addItemWithPhotos(workOrderId);
      return;
    }

    // Sinon, añadir ítem sin fotos (solo datos locales)
    final WorkOrderItem newItem = WorkOrderItem(
      itemType: state.type,
      description: state.description,
      quantity: state.quantity,
      unitPrice: state.unitPrice,
      beforePhotoFile: state.beforePhotoFile,
      afterPhotoFile: state.afterPhotoFile,
    );
    state = state.copyWith(
      items: [...state.items, newItem],
      clearBeforePhotoFile: true,
      clearAfterPhotoFile: true,
    );
  }

  /// Sube un ítem con fotos al backend
  Future<void> _addItemWithPhotos(int workOrderId) async {
    state = state.copyWith(isUploadingPhotos: true);

    try {
      final repository = ref.read(workOrderItemRepositoryProvider);
      final newItem = await repository.createItemWithPhotos(
        workOrderId: workOrderId,
        itemType: state.type,
        description: state.description,
        quantity: state.quantity,
        unitCost: state.unitCost,
        unitPrice: state.unitPrice,
        beforePhoto: state.beforePhotoFile,
        afterPhoto: state.afterPhotoFile,
      );

      // Añadir el ítem received del backend (con URLs de fotos)
      if (ref.mounted) {
        state = state.copyWith(
          items: [...state.items, newItem],
          clearBeforePhotoFile: true,
          clearAfterPhotoFile: true,
          isUploadingPhotos: false,
        );
      }
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(
          errorMessage: 'Error al subir fotos: $e',
          isUploadingPhotos: false,
        );
      }
    }
  }

  void onSubmit() async {
    state = state.copyWith(onSubmit: true, isLoading: true);
    final isValid = true;
    if (!isValid) return;
    final workOrder = WorkOrder(
      vehicleId: state.vehicleId,
      status: Mappers.textToWorkOrderStatus(state.status),
      initialDiagnosis: state.initialDiagnosis,
      notes: state.notes,
    );
    try {
      final WorkOrderDetail detail = WorkOrderDetail(
        workorder: workOrder,
        items: state.items,
      );
      await ref.read(workOrderRepositoryProvider).createWorkOrder(detail);
      if (ref.mounted) {
        state = state.copyWith(isLoading: false);
      }
    } on WorkOrderErrors catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void clearResults() {
    state = state.copyWith(errorMessage: '', onSubmit: false, isLoading: false);
  }
}

class FormWorkOrderState {
  //-------Workorder
  final int vehicleId;
  final Vehicle? vehicle;
  final String status;
  final String initialDiagnosis;
  final String notes;
  //------items
  final String type;
  final String description;
  final int quantity;
  final double unitCost;
  final double unitPrice;
  // Fotos locales (XFile para subida)
  final XFile? beforePhotoFile;
  final XFile? afterPhotoFile;
  // URLs de fotos (después de subir al backend)
  final String? beforePhoto;
  final String? afterPhoto;
  final bool isValid;
  final List<WorkOrderItem> items;
  final String errorMessage;
  final bool onSubmit;
  final bool isLoading;
  final bool isUploadingPhotos;

  FormWorkOrderState({
    required this.vehicleId,
    this.vehicle,
    this.status = 'RECEIVED',
    this.initialDiagnosis = '',
    this.notes = '',
    this.type = 'DIAGNOSIS',
    this.description = '',
    this.quantity = 1,
    this.unitCost = 0,
    this.unitPrice = 0,
    this.beforePhotoFile,
    this.afterPhotoFile,
    this.beforePhoto,
    this.afterPhoto,
    this.isValid = false,
    this.items = const <WorkOrderItem>[],
    this.errorMessage = '',
    this.onSubmit = false,
    this.isLoading = false,
    this.isUploadingPhotos = false,
  });
  FormWorkOrderState copyWith({
    int? vehicleId,
    Vehicle? vehicle,
    String? status,
    String? initialDiagnosis,
    String? notes,
    String? type,
    String? description,
    int? quantity,
    double? unitCost,
    double? unitPrice,
    XFile? beforePhotoFile,
    XFile? afterPhotoFile,
    String? beforePhoto,
    String? afterPhoto,
    bool clearBeforePhotoFile = false,
    bool clearAfterPhotoFile = false,
    bool? isValid,
    List<WorkOrderItem>? items,
    String? errorMessage,
    bool? onSubmit,
    bool? isLoading,
    bool? isUploadingPhotos,
  }) {
    return FormWorkOrderState(
      vehicleId: vehicleId ?? this.vehicleId,
      vehicle: vehicle ?? this.vehicle,
      status: status ?? this.status,
      initialDiagnosis: initialDiagnosis ?? this.initialDiagnosis,
      notes: notes ?? this.notes,
      type: type ?? this.type,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
      unitPrice: unitPrice ?? this.unitPrice,
      beforePhotoFile: clearBeforePhotoFile
          ? null
          : (beforePhotoFile ?? this.beforePhotoFile),
      afterPhotoFile: clearAfterPhotoFile
          ? null
          : (afterPhotoFile ?? this.afterPhotoFile),
      beforePhoto: beforePhoto ?? this.beforePhoto,
      afterPhoto: afterPhoto ?? this.afterPhoto,
      isValid: isValid ?? this.isValid,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
      onSubmit: onSubmit ?? this.onSubmit,
      isLoading: isLoading ?? this.isLoading,
      isUploadingPhotos: isUploadingPhotos ?? this.isUploadingPhotos,
    );
  }
}
