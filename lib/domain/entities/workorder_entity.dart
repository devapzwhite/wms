import 'package:wms/config/enums/status_enum.dart';

class WorkOrder {
  final int? id;
  final int? shopId;
  final int vehicleId;
  final int? createdBy;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? initialDiagnosis;
  final double? laborEstimate;
  final double? partsEstimate;
  final WorkStatus status;
  final String? notes;
  final DateTime? createdAt;

  WorkOrder({
    this.id,
    this.shopId,
    required this.vehicleId,
    this.createdBy,
    this.checkIn,
    this.checkOut,
    this.initialDiagnosis,
    this.laborEstimate,
    this.partsEstimate,
    required this.status,
    this.notes,
    this.createdAt,
  });
}
