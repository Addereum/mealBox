import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/meal.dart';

class MealService {
  static const String _boxName = 'mealBox';

  Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  Future<void> addMeal(String mealType, {DateTime? customTime}) async {
  final box = await _getBox();
  final now = customTime ?? DateTime.now();
  final meal = customTime != null
      ? Meal.loggedLater(mealType, now)
      : Meal(
          id: now.millisecondsSinceEpoch.toString(),
          type: mealType,
          dateTime: now,
          timeString: DateFormat('HH:mm').format(now),
        );

  final dateKey = meal.dateKey;
  List<dynamic> meals = box.get(dateKey, defaultValue: []);
  meals.add(meal.toMap());
  await box.put(dateKey, meals);
}

  Future<void> deleteMeal(String dateKey, String mealId) async {
    final box = await _getBox();
    List<dynamic> meals = box.get(dateKey, defaultValue: []);
    meals.removeWhere((m) => m['id'] == mealId);
    await box.put(dateKey, meals);
  }

  Future<List<Meal>> getMealsForDate(DateTime date) async {
    final box = await _getBox();
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final List<dynamic> mealMaps = box.get(dateKey, defaultValue: []);
    
    return mealMaps
        .map((map) => Meal.fromMap(Map<String, dynamic>.from(map)))
        .toList();
  }

  Future<Map<String, List<Meal>>> getAllMeals() async {
    final box = await _getBox();
    final Map<String, List<Meal>> allMeals = {};
    
    for (final key in box.keys) {
      if (key is String && key.contains('-')) {
        final List<dynamic> mealMaps = box.get(key, defaultValue: []);
        allMeals[key] = mealMaps
            .map((map) => Meal.fromMap(Map<String, dynamic>.from(map)))
            .toList();
      }
    }
    
    // Sortieren nach Datum (neueste zuerst)
    final sortedKeys = allMeals.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    
    final sortedMap = <String, List<Meal>>{};
    for (final key in sortedKeys) {
      sortedMap[key] = allMeals[key]!;
    }
    
    return sortedMap;
  }

  Future<bool> hasMealsForDate(DateTime date) async {
    final meals = await getMealsForDate(date);
    return meals.isNotEmpty;
  }

  Future<void> clearAllData() async {
    final box = await _getBox();
    await box.clear();
  }
}