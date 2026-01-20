import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String mealType;
  final String time;

  const DeleteConfirmationDialog({
    Key? key,
    required this.mealType,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Mahlzeit löschen?'),
      content: Text('Soll "$mealType" um $time Uhr wirklich gelöscht werden?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Abbrechen', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Löschen', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}