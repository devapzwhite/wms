import 'package:image_picker/image_picker.dart';

class WorkOrderItem {
  final int? id;
  final int? workOrderId;
  final String itemType;
  final String description;
  final int? quantity;
  final double? unitCost;
  final double? unitPrice;
  final String? beforePhoto;
  final String? afterPhoto;
  final DateTime? createdAt;

  // Archivos locales (antes de subir al backend)
  final XFile? beforePhotoFile;
  final XFile? afterPhotoFile;

  WorkOrderItem({
    this.id,
    this.workOrderId,
    required this.itemType,
    required this.description,
    this.quantity,
    this.unitCost,
    this.unitPrice,
    this.beforePhoto,
    this.afterPhoto,
    this.createdAt,
    this.beforePhotoFile,
    this.afterPhotoFile,
  });

  /// Helpers para verificar si tiene imágenes
  bool get hasBeforePhoto =>
      beforePhotoFile != null ||
      (beforePhoto != null && beforePhoto!.isNotEmpty);
  bool get hasAfterPhoto =>
      afterPhotoFile != null || (afterPhoto != null && afterPhoto!.isNotEmpty);

  /// Copia con nuevos valores
  WorkOrderItem copyWith({
    int? id,
    int? workOrderId,
    String? itemType,
    String? description,
    int? quantity,
    double? unitCost,
    double? unitPrice,
    String? beforePhoto,
    String? afterPhoto,
    DateTime? createdAt,
    XFile? beforePhotoFile,
    XFile? afterPhotoFile,
    bool clearBeforePhotoFile = false,
    bool clearAfterPhotoFile = false,
    bool clearBeforePhoto = false,
    bool clearAfterPhoto = false,
  }) {
    return WorkOrderItem(
      id: id ?? this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      itemType: itemType ?? this.itemType,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
      unitPrice: unitPrice ?? this.unitPrice,
      beforePhoto: clearBeforePhoto ? null : (beforePhoto ?? this.beforePhoto),
      afterPhoto: clearAfterPhoto ? null : (afterPhoto ?? this.afterPhoto),
      createdAt: createdAt ?? this.createdAt,
      beforePhotoFile: clearBeforePhotoFile
          ? null
          : (beforePhotoFile ?? this.beforePhotoFile),
      afterPhotoFile: clearAfterPhotoFile
          ? null
          : (afterPhotoFile ?? this.afterPhotoFile),
    );
  }
}
