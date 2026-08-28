import 'dart:io';
import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealListTile extends StatelessWidget {
  final Meal meal;
  final Function(Meal) onDelete;
  final bool showDate;

  const MealListTile({
    Key? key,
    required this.meal,
    required this.onDelete,
    this.showDate = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: ListTile(
        leading: meal.imagePath != null
            ? GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(File(meal.imagePath!)),
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(meal.imagePath!),
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getMealColor(meal.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getMealIcon(meal.type),
                  color: _getMealColor(meal.type),
                ),
              ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                '${meal.type}${showDate ? ' (${meal.dateKey})' : ''}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: meal.isLoggedLate ? Theme.of(context).colorScheme.onSurfaceVariant : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            if (meal.tookMeds == true)
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.medication,
                  color: Colors.red[400],
                  size: 18,
                ),
              ),
            if (meal.isLoggedLate)
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.access_time,
                  color: Colors.orange,
                  size: 18,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('um ${meal.timeString} Uhr'),
            if (meal.energyLevel != null)
              Text(
                meal.energyLevel!,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            if (meal.isLoggedLate)
              Text(
                'Nachgetragen',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => onDelete(meal),
        ),
      ),
    );
  }

  IconData _getMealIcon(String type) {
    switch (type) {
      case 'Frühstück':
        return Icons.breakfast_dining;
      case 'Mittag':
        return Icons.lunch_dining;
      case 'Abend':
        return Icons.dinner_dining;
      case 'Snack':
        return Icons.cookie;
      default:
        return Icons.restaurant;
    }
  }

  Color _getMealColor(String type) {
    switch (type) {
      case 'Frühstück':
        return Colors.orange;
      case 'Mittag':
        return Colors.green;
      case 'Abend':
        return Colors.blue;
      case 'Snack':
        return Colors.red;
      default:
        return Colors.teal;
    }
  }
}