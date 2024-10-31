// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quick_card/entity/item.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  final ValueChanged<bool?> onChecked;
  final VoidCallback onDelete;

  const ItemTile({
    super.key,
    required this.item,
    required this.onChecked,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.name),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDelete();
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: Checkbox(
          value: item.checkedOff,
          onChanged: onChecked,
        ),
        title: Text(
          item.name,
          style: TextStyle(
            fontSize: 16,
            decoration: item.checkedOff ? TextDecoration.lineThrough : null,
            color: item.checkedOff ? Colors.grey : Colors.black,
          ),
        ),
      ),
    );
  }
}
