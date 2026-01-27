import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsService with ChangeNotifier {
  static const String _boxName = 'settingsBox';
  static const String _simpleModeKey = 'simpleMode';
  static const String _themeModeKey = 'themeMode';

  bool _simpleMode = false;
  ThemeMode _themeMode = ThemeMode.light;

  static SettingsService? _instance;

  SettingsService._internal() {
    _loadSettings();
  }

  static SettingsService get instance {
    _instance ??= SettingsService._internal();
    return _instance!;
  }

  bool get simpleMode => _simpleMode;
  ThemeMode get themeMode => _themeMode;

  Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  Future<void> _loadSettings() async {
    final box = await _getBox();

    _simpleMode = box.get(_simpleModeKey, defaultValue: false);

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

  Future<void> setThemeMode(ThemeMode mode) async {
    final box = await _getBox();

    // nur light/dark speichern, alles andere wird zu light
    final themeStr = (mode == ThemeMode.dark) ? 'dark' : 'light';

    await box.put(_themeModeKey, themeStr);
    _themeMode = themeStr == 'dark' ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }
}
