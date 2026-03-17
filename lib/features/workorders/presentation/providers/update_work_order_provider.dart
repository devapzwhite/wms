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

      // 2. Sincronizar ítems con el backend
      final itemsError = await _syncItems();

      if (ref.mounted) {
        // Si hubo error en items pero la OT se guardó, mostrar warning
        if (itemsError != null) {
          state = state.copyWith(
            isLoading: false,
            isSavingItems: false,
            isSuccess: true,
            originalItems: List.from(state.items),
            errorMessage:
                'OT actualizada. Los ítems no se pudieron guardar (endpoint no disponible en backend).',
          );
        } else {
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

    // Crear sets para comparar por ID
    final currentIds = currentItems
        .where((item) => item.id != null)
        .map((item) => item.id)
        .toSet();
    final originalIds = originalItems
        .where((item) => item.id != null)
        .map((item) => item.id)
        .toSet();

    // Lista actualizada de items (para mantener referencias)
    final List<WorkOrderItem> updatedItems = List.from(currentItems);

    // 1. Ítems a eliminar (están en originales pero no en actuales)
    final idsToDelete = originalIds.difference(currentIds);
    for (final id in idsToDelete) {
      try {
        await itemRepo.deleteItem(id!);
      } catch (e) {
        lastError = 'Error eliminando ítem: $e';
        print('Error eliminando ítem $id: $e');
      }
    }

    // 2. Ítems a actualizar (están en ambos)
    for (int i = 0; i < updatedItems.length; i++) {
      final currentItem = updatedItems[i];
      if (currentItem.id != null && originalIds.contains(currentItem.id)) {
        // Buscar el ítem original para ver si cambió
        final originalItem = originalItems.firstWhere(
          (item) => item.id == currentItem.id,
        );
        if (_itemHasChanged(originalItem, currentItem)) {
          try {
            final updated = await itemRepo.updateItem(
              currentItem.id!,
              currentItem,
            );
            updatedItems[i] =
                updated; // Actualizar con la respuesta del servidor
          } catch (e) {
            lastError = 'Error actualizando ítem: $e';
            print('Error actualizando ítem ${currentItem.id}: $e');
          }
        }
      }
    }

    // 3. Ítems a crear (son nuevos, no tienen ID)
    for (int i = 0; i < updatedItems.length; i++) {
      final newItem = updatedItems[i];
      if (newItem.id == null) {
        try {
          // Asignar el workOrderId si no lo tiene
          final itemToCreate = newItem.workOrderId == null
              ? WorkOrderItem(
                  workOrderId: workOrderId,
                  itemType: newItem.itemType,
                  description: newItem.description,
                  quantity: newItem.quantity,
                  unitCost: newItem.unitCost,
                  unitPrice: newItem.unitPrice,
                  beforePhoto: newItem.beforePhoto,
                  afterPhoto: newItem.afterPhoto,
                )
              : newItem;
          final createdItem = await itemRepo.createItem(itemToCreate);
          updatedItems[i] = createdItem; // Actualizar con el ID del servidor
        } catch (e) {
          lastError = 'Error creando ítem: $e';
          print('Error creando ítem: $e');
        }
      }
    }

    // 4. Actualizar el estado con los items que ahora tienen sus IDs
    state = state.copyWith(items: updatedItems);

    print('=== _syncItems FIN === lastError: $lastError');
    return lastError;
  }

  /// Compara dos ítems para ver si hubo cambios
  bool _itemHasChanged(WorkOrderItem original, WorkOrderItem current) {
    return original.itemType != current.itemType ||
        original.description != current.description ||
        original.quantity != current.quantity ||
        original.unitCost != current.unitCost ||
        original.unitPrice != current.unitPrice;
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
