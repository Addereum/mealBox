import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../constants.dart';

class SettingsService with ChangeNotifier {
  static const String _simpleModeKey = 'simpleMode';
  static const String _themeModeKey = 'themeMode';
  static const String _notificationsKey = 'notifications';
  static const String _showStatsKey = 'showStats';
  static const String _safeFoodsKey = 'safeFoods';
  static const String _mealNamesKey = 'mealNames';
  static const String _trackMedicationsKey = 'trackMedications';

  bool _simpleMode = false;
  bool _notifications = true;
  bool _showStats = true;
  ThemeMode _themeMode = ThemeMode.light;
  bool _trackMedications = false;
  List<String> _safeFoods = [];
  List<String> _mealNames = ["Frühstück 🍳", "Mittagessen 🥗", "Abendessen 🍽️", "Snack 🍎"];

  static SettingsService? _instance;

  SettingsService._internal() {
    _loadSettings();
  }

  static SettingsService get instance {
    _instance ??= SettingsService._internal();
    return _instance!;
  }

  bool get simpleMode => _simpleMode;
  bool get notifications => _notifications;
  bool get showStats => _showStats;
  ThemeMode get themeMode => _themeMode;
  bool get trackMedications => _trackMedications;
  List<String> get safeFoods => _safeFoods;
  List<String> get mealNames => _mealNames;

  Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(AppConstants.settingsBoxName)) {
      return await Hive.openBox(AppConstants.settingsBoxName);
    }
    return Hive.box(AppConstants.settingsBoxName);
  }

  Future<void> _loadSettings() async {
    final box = await _getBox();

    _simpleMode = box.get(_simpleModeKey, defaultValue: false);
    _notifications = box.get(_notificationsKey, defaultValue: true);
    _showStats = box.get(_showStatsKey, defaultValue: true);
    _trackMedications = box.get(_trackMedicationsKey, defaultValue: false);
    _safeFoods = box.get(_safeFoodsKey, defaultValue: <String>[]).cast<String>();
    
    final defaultMeals = ["Frühstück 🍳", "Mittagessen 🥗", "Abendessen 🍽️", "Snack 🍎"];
    _mealNames = box.get(_mealNamesKey, defaultValue: defaultMeals).cast<String>();

    final themeStr = box.get(_themeModeKey, defaultValue: 'light') as String;
    _themeMode = themeStr == 'dark' ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }

  Future<void> setSimpleMode(bool value) async {
    final box = await _getBox();
    await box.put(_simpleModeKey, value);
    _simpleMode = value;
    notifyListeners();
  }

  Future<void> setNotifications(bool value) async {
    final box = await _getBox();
    await box.put(_notificationsKey, value);
    _notifications = value;
    notifyListeners();
  }

  Future<void> setShowStats(bool value) async {
    final box = await _getBox();
    await box.put(_showStatsKey, value);
    _showStats = value;
    notifyListeners();
  }

  Future<void> setTrackMedications(bool value) async {
    final box = await _getBox();
    await box.put(_trackMedicationsKey, value);
    _trackMedications = value;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final box = await _getBox();

    // nur light/dark speichern, alles andere wird zu light
    final themeStr = (mode == ThemeMode.dark) ? 'dark' : 'light';

    await box.put(_themeModeKey, themeStr);
    _themeMode = themeStr == 'dark' ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }

  Future<void> addSafeFood(String food) async {
    if (!_safeFoods.contains(food)) {
      _safeFoods.add(food);
      final box = await _getBox();
      await box.put(_safeFoodsKey, _safeFoods);
      notifyListeners();
    }
  }

  Future<void> removeSafeFood(String food) async {
    if (_safeFoods.contains(food)) {
      _safeFoods.remove(food);
      final box = await _getBox();
      await box.put(_safeFoodsKey, _safeFoods);
      notifyListeners();
    }
  }

  Future<void> setSafeFoods(List<String> foods) async {
    _safeFoods = foods;
    final box = await _getBox();
    await box.put(_safeFoodsKey, _safeFoods);
    notifyListeners();
  }

  Future<void> setMealNames(List<String> names) async {
    _mealNames = names;
    final box = await _getBox();
    await box.put(_mealNamesKey, _mealNames);
    notifyListeners();
  }
}
