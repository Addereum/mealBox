import 'package:flutter/material.dart';
import 'package:mealbox/l10n/generated/app_localizations.dart';

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
      title: Text(AppLocalizations.of(context)!.deleteConfirmTitle),
      content: Text(AppLocalizations.of(context)!.deleteConfirmMessage(mealType, time)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}