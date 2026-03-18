import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/config/helpers/mappers.dart';
import 'package:wms/domain/entities/entities.dart';
import 'package:wms/features/customers/presentation/providers/customers_provider.dart';
import 'package:wms/features/vehicles/presentation/providers/vehicles_provider.dart';
import 'package:wms/features/workorders/errors/work_order_errors.dart';
import 'package:wms/features/workorders/presentation/providers/work_order_repository_provider.dart';
import 'package:wms/features/workorders/presentation/providers/work_order_item_repository_provider.dart';

final updateWorkOrderProvider =
    NotifierProvider.family<UpdateWorkOrderNotifier, UpdateWorkOrderState, int>(
      UpdateWorkOrderNotifier.new,
    );

class UpdateWorkOrderNotifier extends Notifier<UpdateWorkOrderState> {
  final int workOrderId;

  UpdateWorkOrderNotifier(this.workOrderId);

  @override
  UpdateWorkOrderState build() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
    return UpdateWorkOrderState(workOrderId: workOrderId);
  }

  void _loadData() async {
    state = state.copyWith(isLoading: true);
    try {
      final repository = ref.read(workOrderRepositoryProvider);
      final detail = await repository.getWorkOrderDetail(workOrderId);
      final workOrder = detail.workorder;

      // Obtener vehículo: usa el método existente que busca en cache primero
      final vehicleData = await ref
          .read(vehiclesNotifierProvider.notifier)
          .getVehicle(workOrder.vehicleId);

      // Obtener cliente: usa el método existente que busca en cache primero
      Customer? customerData;
      if (vehicleData != null && vehicleData.customerId != 0) {
        customerData = await ref
            .read(customerNotifierProvider.notifier)
            .getCustomerToUpdate(vehicleData.customerId);
      }

      if (ref.mounted) {
        state = state.copyWith(
          workOrder: workOrder,
          vehicle: vehicleData,
          customer: customerData,
          status: workOrder.status.label,
          initialDiagnosis: workOrder.initialDiagnosis ?? '',
          notes: workOrder.notes ?? '',
          items: detail.items,
          originalItems: List.from(
            detail.items,
          ), // Guardar copia para comparar después
          isLoading: false,
        );
      }
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
    }
  }

  void onChangeStatus(String value) {
    state = state.copyWith(status: value);
  }

  void onChangeInitialDiagnosis(String value) {
    state = state.copyWith(initialDiagnosis: value);
  }

  void onChangeNotes(String value) {
    state = state.copyWith(notes: value);
  }

  void addItem(WorkOrderItem item) {
    state = state.copyWith(items: [...state.items, item]);
  }

  void removeItem(int index) {
    final newList = List<WorkOrderItem>.from(state.items);
    newList.removeAt(index);
    state = state.copyWith(items: newList);
  }

  void updateItem(int index, WorkOrderItem item) {
    final newList = List<WorkOrderItem>.from(state.items);
    newList[index] = item;
    state = state.copyWith(items: newList);
  }

  bool _validate() {
    if (state.status.isEmpty) {
      state = state.copyWith(errorMessage: 'Seleccione un estado');
      return false;
    }
    return true;
  }

  void onSubmit() async {
    if (!_validate()) return;

    // Resetear isSuccess para permitir nuevos guardados
    state = state.copyWith(
      isLoading: true,
      isSavingItems: true,
      errorMessage: '',
      isSuccess: false,
    );

    try {
      print('=== onSubmit inicio ===');
      print('workOrderId: $workOrderId');
      print('items actuales: ${state.items.length}');
      print('items originales: ${state.originalItems.length}');

      // 1. Actualizar la orden de trabajo
      final updatedWorkOrder = WorkOrder(
        id: workOrderId,
        vehicleId: state.workOrder!.vehicleId,
        status: Mappers.textToWorkOrderStatus(state.status),
        initialDiagnosis: state.initialDiagnosis.isEmpty
            ? null
            : state.initialDiagnosis,
        notes: state.notes.isEmpty ? null : state.notes,
        createdAt: state.workOrder!.createdAt,
        checkIn: state.workOrder!.checkIn,
        checkOut: state.workOrder!.checkOut,
        laborEstimate: state.workOrder!.laborEstimate,
        partsEstimate: state.workOrder!.partsEstimate,
        shopId: state.workOrder!.shopId,
        createdBy: state.workOrder!.createdBy,
      );

      print('Actualizando workOrder...');
      await ref
          .read(workOrderRepositoryProvider)
          .updateWorkOrder(workOrderId, updatedWorkOrder);
      print('WorkOrder actualizado');

      // 2. Sincronizar ítems solo si la work order principal se guardó
      final itemsError = await _syncItems();

      if (ref.mounted) {
        // La work order principal se guardó exitosamente
        if (itemsError != null) {
          // Items tienen error pero la OT principal se guardó
          state = state.copyWith(
            isLoading: false,
            isSavingItems: false,
            isSuccess: true,
            originalItems: List.from(state.items),
            errorMessage:
                'OT actualizada. Los ítems no se pudieron guardar completamente.',
          );
        } else {
          // Todo OK
          state = state.copyWith(
            isLoading: false,
            isSavingItems: false,
            isSuccess: true,
            originalItems: List.from(state.items),
          );
        }
      }
    } on WorkOrderErrors catch (e) {
      if (ref.mounted) {
        state = state.copyWith(
          isLoading: false,
          isSavingItems: false,
          errorMessage: e.message,
        );
      }
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(
          isLoading: false,
          isSavingItems: false,
          errorMessage: 'Error al guardar: $e',
        );
      }
    }
  }

  /// Sincroniza los ítems locales con el backend
  /// Retorna el mensaje de error si falla, o null si todo OK
  Future<String?> _syncItems() async {
    print('=== _syncItems INICIO ===');
    final itemRepo = ref.read(workOrderItemRepositoryProvider);
    final currentItems = state.items;
    final originalItems = state.originalItems;
    String? lastError;
    print('Items a procesar: ${currentItems.length}');

    // Crear maps para búsqueda rápida por ID (solo items con ID del backend)
    final Map<int, WorkOrderItem> originalItemsById = {};
    for (final item in originalItems) {
      if (item.id != null) {
        originalItemsById[item.id!] = item;
      }
    }

    // Lista actualizada de items (para mantener referencias)
    final List<WorkOrderItem> updatedItems = List.from(currentItems);

    // 1. Ítems a eliminar:
    // - Solo items que YA tienen ID del backend Y ya no están en la lista actual
    for (final originalItem in originalItems) {
      if (originalItem.id == null) continue; // Skip items nuevos

      // Verificar si este item original todavía existe en currentItems
      final stillExists = currentItems.any(
        (item) => item.id == originalItem.id,
      );

      if (!stillExists) {
        // El item fue eliminado - intentar borrar del backend
        try {
          await itemRepo.deleteItem(originalItem.id!);
          print('Item ${originalItem.id} eliminado del backend');
        } catch (e) {
          lastError = 'Error eliminando ítem: $e';
          print('Error eliminando ítem ${originalItem.id}: $e');
        }
      }
    }

    // 2. Ítems a actualizar o crear
    for (int i = 0; i < updatedItems.length; i++) {
      final currentItem = updatedItems[i];

      if (currentItem.id != null &&
          originalItemsById.containsKey(currentItem.id)) {
        // Este item existe en el backend - verificar si cambió
        final originalItem = originalItemsById[currentItem.id!];
        if (_itemHasChanged(originalItem, currentItem)) {
          try {
            // Verificar si hay fotos locales nuevas para actualizar
            final hasNewPhotos =
                currentItem.beforePhotoFile != null ||
                currentItem.afterPhotoFile != null;

            WorkOrderItem updated;
            if (hasNewPhotos) {
              // Usar método especial para actualizar con fotos
              updated = await itemRepo.updateItemWithPhotos(
                id: currentItem.id!,
                workOrderId: workOrderId,
                itemType: currentItem.itemType,
                description: currentItem.description,
                quantity: currentItem.quantity,
                unitCost: currentItem.unitCost,
                unitPrice: currentItem.unitPrice,
                beforePhoto: currentItem.beforePhotoFile,
                afterPhoto: currentItem.afterPhotoFile,
              );
            } else {
              // Actualización normal sin fotos
              updated = await itemRepo.updateItem(currentItem.id!, currentItem);
            }
            // Limpiar archivos locales después de subir
            updatedItems[i] = WorkOrderItem(
              id: updated.id,
              workOrderId: updated.workOrderId,
              itemType: updated.itemType,
              description: updated.description,
              quantity: updated.quantity,
              unitCost: updated.unitCost,
              unitPrice: updated.unitPrice,
              beforePhoto: updated.beforePhoto,
              afterPhoto: updated.afterPhoto,
              createdAt: updated.createdAt,
            );
          } catch (e) {
            lastError = 'Error actualizando ítem: $e';
            print('Error actualizando ítem ${currentItem.id}: $e');
          }
        }
      } else if (currentItem.id == null) {
        // Este es un item nuevo - crearlo en el backend
        try {
          // Verificar si el ítem tiene fotos locales para subir
          final hasLocalPhotos =
              currentItem.beforePhotoFile != null ||
              currentItem.afterPhotoFile != null;

          WorkOrderItem created;
          if (hasLocalPhotos) {
            created = await itemRepo.createItemWithPhotos(
              workOrderId: workOrderId,
              itemType: currentItem.itemType,
              description: currentItem.description,
              quantity: currentItem.quantity,
              unitCost: currentItem.unitCost,
              unitPrice: currentItem.unitPrice,
              beforePhoto: currentItem.beforePhotoFile,
              afterPhoto: currentItem.afterPhotoFile,
            );
          } else {
            // Crear ítem sin fotos (método normal)
            final itemToCreate = WorkOrderItem(
              workOrderId: workOrderId,
              itemType: currentItem.itemType,
              description: currentItem.description,
              quantity: currentItem.quantity,
              unitCost: currentItem.unitCost,
              unitPrice: currentItem.unitPrice,
              beforePhoto: currentItem.beforePhoto,
              afterPhoto: currentItem.afterPhoto,
            );
            created = await itemRepo.createItem(itemToCreate);
          }

          // Limpiar archivos locales después de subir
          updatedItems[i] = WorkOrderItem(
            id: created.id,
            workOrderId: created.workOrderId,
            itemType: created.itemType,
            description: created.description,
            quantity: created.quantity,
            unitCost: created.unitCost,
            unitPrice: created.unitPrice,
            beforePhoto: created.beforePhoto,
            afterPhoto: created.afterPhoto,
            createdAt: created.createdAt,
          );
        } catch (e) {
          lastError = 'Error creando ítem: $e';
          print('Error creando ítem: $e');
        }
      }
    }

    // 4. Actualizar el estado con los items actualizados
    state = state.copyWith(items: updatedItems);

    print('=== _syncItems FIN === lastError: $lastError');
    return lastError;
  }

  /// Compara dos ítems para ver si hubo cambios
  bool _itemHasChanged(WorkOrderItem? original, WorkOrderItem current) {
    if (original == null) return true;

    // Verificar si hay fotos locales nuevas
    final hasNewBeforePhoto = current.beforePhotoFile != null;
    final hasNewAfterPhoto = current.afterPhotoFile != null;

    if (hasNewBeforePhoto || hasNewAfterPhoto) return true;

    // Comparar campos, handleando nulls correctamente
    return _compareValues(original.itemType, current.itemType) ||
        _compareValues(original.description, current.description) ||
        _compareValues(original.quantity, current.quantity) ||
        _compareValues(original.unitCost, current.unitCost) ||
        _compareValues(original.unitPrice, current.unitPrice);
  }

  /// Compara dos valores que pueden ser null
  bool _compareValues<T>(T? a, T? b) {
    if (a == null && b == null) return false;
    if (a == null || b == null) return true;
    return a != b;
  }

  void clearError() {
    state = state.copyWith(errorMessage: '');
  }
}

class UpdateWorkOrderState {
  final int workOrderId;
  final WorkOrder? workOrder;
  final Vehicle? vehicle;
  final Customer? customer;
  final String status;
  final String initialDiagnosis;
  final String notes;
  final List<WorkOrderItem> items;
  final List<WorkOrderItem> originalItems; // Ítems originales para comparar
  final bool isLoading;
  final bool isSavingItems;
  final String errorMessage;
  final bool isSuccess;

  UpdateWorkOrderState({
    required this.workOrderId,
    this.workOrder,
    this.vehicle,
    this.customer,
    this.status = 'RECEIVED',
    this.initialDiagnosis = '',
    this.notes = '',
    this.items = const [],
    this.originalItems = const [],
    this.isLoading = false,
    this.isSavingItems = false,
    this.errorMessage = '',
    this.isSuccess = false,
  });

  UpdateWorkOrderState copyWith({
    int? workOrderId,
    WorkOrder? workOrder,
    Vehicle? vehicle,
    Customer? customer,
    String? status,
    String? initialDiagnosis,
    String? notes,
    List<WorkOrderItem>? items,
    List<WorkOrderItem>? originalItems,
    bool? isLoading,
    bool? isSavingItems,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return UpdateWorkOrderState(
      workOrderId: workOrderId ?? this.workOrderId,
      workOrder: workOrder ?? this.workOrder,
      vehicle: vehicle ?? this.vehicle,
      customer: customer ?? this.customer,
      status: status ?? this.status,
      initialDiagnosis: initialDiagnosis ?? this.initialDiagnosis,
      notes: notes ?? this.notes,
      items: items ?? this.items,
      originalItems: originalItems ?? this.originalItems,
      isLoading: isLoading ?? this.isLoading,
      isSavingItems: isSavingItems ?? this.isSavingItems,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
