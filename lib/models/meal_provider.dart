import 'package:flutter/foundation.dart';
import 'meal.dart';

class MealProvider extends ChangeNotifier {
  List<Meal> _meals = [];
  
  List<Meal> get meals => _meals;
  
  void addMeal(Meal meal) {
    _meals.add(meal);
    notifyListeners(); // UI aktualisiert sich automatisch
    print('Mahlzeit hinzugefügt. Total: ${_meals.length}');
  }
  
  void clearAllMeals() {
    _meals.clear();
    notifyListeners(); // UI aktualisiert sich automatisch
    print('Alle Mahlzeiten gelöscht');
  }
  
  List<Meal> getMealsForDate(DateTime date) {
    return _meals.where((meal) => 
      meal.dateTime.year == date.year &&
      meal.dateTime.month == date.month &&
      meal.dateTime.day == date.day
    ).toList();
  }
  
  void removeMeal(String id) {
    _meals.removeWhere((meal) => meal.id == id);
    notifyListeners();
  }

  void importMeals(List<Meal> importedMeals) {
    _meals.addAll(importedMeals);
    notifyListeners();
    print('${importedMeals.length} Mahlzeiten importiert. Total: ${_meals.length}');
  }
}