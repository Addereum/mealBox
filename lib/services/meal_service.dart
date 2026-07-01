import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/meal.dart';

class MealService with ChangeNotifier { 
  static const String _boxName = 'mealBox';
  static const String _waterBoxName = 'waterBox';
  
  static final MealService _instance = MealService._internal();
  factory MealService() => _instance;
  MealService._internal();
  
  Box<dynamic>? _box;
  Box<int>? _waterBox;
  
  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    _waterBox = await Hive.openBox<int>(_waterBoxName);
    await _migrateDataIfNeeded();
  }

  Future<void> _migrateDataIfNeeded() async {
    if (_box == null) return;
    bool needsMigration = false;
    for (final key in _box!.keys) {
      if (key is String && key.contains('-')) {
        final mealsList = _box!.get(key);
        if (mealsList is List) {
          bool updatedList = false;
          List<dynamic> newList = [];
          for (final item in mealsList) {
            if (item is Map) {
              try {
                final meal = Meal.fromMap(Map<String, dynamic>.from(item));
                newList.add(meal);
                updatedList = true;
                needsMigration = true;
              } catch (e) {
                print('Fehler bei Migration: $e');
              }
            } else {
              newList.add(item);
            }
          }
          if (updatedList) {
            await _box!.put(key, newList);
          }
        }
      }
    }
    if (needsMigration) {
      print('✅ Hive Daten auf TypeAdapter migriert');
    }
  }
  
  Future<Box> _getBox() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox(_boxName);
    }
    return _box!;
  }

  Future<void> addMeal(String mealType, {DateTime? customTime, String? energyLevel}) async {
    final box = await _getBox();
    final now = DateTime.now();
    
    Meal meal;
    
    if (customTime != null) {
      meal = Meal.loggedLater(mealType, customTime, energyLevel: energyLevel);
    } else {
      meal = Meal(
        id: now.millisecondsSinceEpoch.toString(),
        type: mealType,
        dateTime: now,
        timeString: DateFormat('HH:mm').format(now),
        energyLevel: energyLevel,
      );
    }

    final dateKey = meal.dateKey;
    List<dynamic> meals = box.get(dateKey, defaultValue: []);
    meals.add(meal); // Nutzt TypeAdapter statt toMap()

    await box.put(dateKey, meals);
    
    notifyListeners();
    print('✅ Meal added: $mealType at ${meal.timeString}');
  }

  Future<void> deleteMeal(String dateKey, String mealId) async {
    final box = await _getBox();
    List<dynamic> meals = box.get(dateKey, defaultValue: []);
    meals.removeWhere((m) => (m as Meal).id == mealId);
    await box.put(dateKey, meals);
    
    notifyListeners();
    print('🗑️ Meal deleted: $mealId');
  }

  Future<List<Meal>> getMealsForDate(DateTime date) async {
    final box = await _getBox();
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final List<dynamic> mealList = box.get(dateKey, defaultValue: []);
    
    return mealList.cast<Meal>().toList();
  }

  Future<Map<String, List<Meal>>> getAllMeals() async {
    final box = await _getBox();
    final Map<String, List<Meal>> allMeals = {};
    
    for (final key in box.keys) {
      if (key is String && key.contains('-')) {
        final List<dynamic> mealList = box.get(key, defaultValue: []);
        allMeals[key] = mealList.cast<Meal>().toList();
      }
    }
    
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
    
    if (_waterBox != null && _waterBox!.isOpen) {
      await _waterBox!.clear();
    }
    
    notifyListeners();
    print('🔥 All data cleared');
  }

  // --- Water Tracking ---

  Future<Box<int>> _getWaterBox() async {
    if (_waterBox == null || !_waterBox!.isOpen) {
      _waterBox = await Hive.openBox<int>(_waterBoxName);
    }
    return _waterBox!;
  }

  Future<int> getWaterForDate(DateTime date) async {
    final box = await _getWaterBox();
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return box.get(dateKey, defaultValue: 0) ?? 0;
  }

  Future<void> setWaterForDate(DateTime date, int amount) async {
    final box = await _getWaterBox();
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    // Max 20 glasses to prevent overflow/mistakes, min 0
    final safeAmount = amount < 0 ? 0 : (amount > 20 ? 20 : amount);
    await box.put(dateKey, safeAmount);
    notifyListeners();
  }

  Future<void> addWater(DateTime date) async {
    final current = await getWaterForDate(date);
    await setWaterForDate(date, current + 1);
  }

  Future<void> removeWater(DateTime date) async {
    final current = await getWaterForDate(date);
    if (current > 0) {
      await setWaterForDate(date, current - 1);
    }
  }

  Future<Map<String, int>> getAllWaterData() async {
    final box = await _getWaterBox();
    final Map<String, int> allWater = {};
    for (final key in box.keys) {
      allWater[key.toString()] = box.get(key) as int;
    }
    return allWater;
  }
  
  Future<void> importWaterData(Map<String, dynamic> data) async {
    final box = await _getWaterBox();
    for (final entry in data.entries) {
      await box.put(entry.key, entry.value as int);
    }
    notifyListeners();
  }
}