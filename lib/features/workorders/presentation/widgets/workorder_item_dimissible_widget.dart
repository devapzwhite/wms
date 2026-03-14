import 'package:flutter/material.dart';
import 'package:wms/config/helpers/mappers.dart';
import 'package:wms/domain/entities/work_order_item_entity.dart';

class ItemDimissible extends StatelessWidget {
  const ItemDimissible({
    super.key,
    required this.item,
    required this.index,
    this.onDismissed,
  });

  final WorkOrderItem item;
  final int index;
  final Function(DismissDirection)? onDismissed;

  @override
  Widget build(BuildContext context) {
    final totalPrice = item.unitPrice! * item.quantity!;
    return Dismissible(
      key: ValueKey(item.hashCode),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: onDismissed,
      child: Card(
        child: ListTile(
          title: Text(Mappers.textToWorkOrderItemType(item.itemType).nombre),
          subtitle: Text(item.description, overflow: TextOverflow.ellipsis),
          trailing: Text('$totalPrice CLP '),
        ),
      ),
    );
  }
}
