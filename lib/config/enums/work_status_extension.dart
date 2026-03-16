import 'package:flutter/material.dart';
import 'package:wms/config/enums/status_enum.dart';

extension WorkStatusExtension on WorkStatus {
  IconData get icon {
    switch (this) {
      case WorkStatus.received:
        return Icons.inbox;
      case WorkStatus.diagnosis:
        return Icons.search;
      case WorkStatus.waitingAproval:
        return Icons.hourglass_empty;
      case WorkStatus.aproved:
        return Icons.thumb_up;
      case WorkStatus.inProgress:
        return Icons.build;
      case WorkStatus.waitingParts:
        return Icons.inventory;
      case WorkStatus.reapired:
        return Icons.handyman;
      case WorkStatus.readyForDelivery:
        return Icons.local_shipping;
      case WorkStatus.completed:
        return Icons.check_circle;
      case WorkStatus.canceled:
        return Icons.cancel;
    }
  }

  Color get color {
    switch (this) {
      case WorkStatus.received:
        return Colors.blue;
      case WorkStatus.diagnosis:
        return Colors.cyan;
      case WorkStatus.waitingAproval:
        return Colors.amber;
      case WorkStatus.aproved:
        return Colors.teal;
      case WorkStatus.inProgress:
        return Colors.orange;
      case WorkStatus.waitingParts:
        return Colors.indigo;
      case WorkStatus.reapired:
        return Colors.green;
      case WorkStatus.readyForDelivery:
        return Colors.purple;
      case WorkStatus.completed:
        return Colors.green;
      case WorkStatus.canceled:
        return Colors.red;
    }
  }
}
