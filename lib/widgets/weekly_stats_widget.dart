import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/meal_service.dart';
import '../models/meal.dart';
import 'package:mealbox/l10n/generated/app_localizations.dart';

class WeeklyStatsWidget extends StatelessWidget {
  const WeeklyStatsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mealService = Provider.of<MealService>(context);
    
    final List<DateTime> last7Days = List.generate(7, (index) {
      return DateTime.now().subtract(Duration(days: 6 - index));
    });

    return FutureBuilder<List<List<Meal>>>(
      future: Future.wait(last7Days.map((d) => mealService.getMealsForDate(d))),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink(); // Hide until loaded
        }
        
        final allDaysMeals = snapshot.data!;
        
        int currentStreak = 0;
        int goodEnergyDays = 0;
        int goodEatingDays = 0;
        
        for (int i = 6; i >= 0; i--) {
          final dayMeals = allDaysMeals[i];
          final hasMeals = dayMeals.isNotEmpty;
          
          if (hasMeals) {
            currentStreak++;
            if (dayMeals.length >= 3) {
              goodEatingDays++;
              // Check if any meal had High or Med energy
              if (dayMeals.any((m) => m.energyLevel == '⚡ High' || m.energyLevel == '🔋 Med')) {
                goodEnergyDays++;
              }
            }
          } else {
            break;
          }
        }

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.weeklyStats,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
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
                              AppLocalizations.of(context)!.streakDays(currentStreak),
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
                    final hasMeals = allDaysMeals[index].isNotEmpty;
                    final isToday = index == 6; // Last element is today
                    
                    return Column(
                      children: [
                        Text(
                          DateFormat('E', Localizations.localeOf(context).languageCode).format(date).substring(0, 2),
                          style: TextStyle(
                            fontSize: 12,
                            color: isToday ? Theme.of(context).colorScheme.primary : Colors.grey[600],
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasMeals ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
                            border: isToday && !hasMeals 
                                ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) 
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
                if (goodEatingDays >= 2 && goodEnergyDays >= 2) ...[
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.insights, color: Colors.blue[700], size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.statsEncouragement,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue[900],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }
    );
  }
}
