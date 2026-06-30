import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/meal_service.dart';

class WeeklyStatsWidget extends StatelessWidget {
  const WeeklyStatsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mealService = Provider.of<MealService>(context);
    
    final List<DateTime> last7Days = List.generate(7, (index) {
      return DateTime.now().subtract(Duration(days: 6 - index));
    });

    return FutureBuilder<List<bool>>(
      future: Future.wait(last7Days.map((d) => mealService.hasMealsForDate(d))),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink(); // Verstecken bis geladen
        }
        
        final hasMealsList = snapshot.data!;
        
        int currentStreak = 0;
        for (int i = 6; i >= 0; i--) {
          if (hasMealsList[i]) {
            currentStreak++;
          } else {
            break;
          }
        }

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Wochen-Statistik',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800],
                      ),
                    ),
                    if (currentStreak > 1)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.local_fire_department, size: 14, color: Colors.orange[800]),
                            SizedBox(width: 4),
                            Text(
                              '$currentStreak Tage',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (index) {
                    final date = last7Days[index];
                    final hasMeals = hasMealsList[index];
                    final isToday = index == 6; // letztes Element ist heute
                    
                    return Column(
                      children: [
                        Text(
                          DateFormat('E', 'de_DE').format(date).substring(0, 2),
                          style: TextStyle(
                            fontSize: 12,
                            color: isToday ? Colors.teal : Colors.grey[600],
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasMeals ? Colors.teal : Colors.grey[200],
                            border: isToday && !hasMeals 
                                ? Border.all(color: Colors.teal, width: 2) 
                                : null,
                          ),
                          child: hasMeals 
                              ? Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
