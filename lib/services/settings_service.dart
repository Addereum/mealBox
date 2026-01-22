// services/settings_service.dart
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class SettingsService with ChangeNotifier {
  static const String _boxName = 'settingsBox';
  static const String _simpleModeKey = 'simpleMode';
  
  bool _simpleMode = false;
  
  bool get simpleMode => _simpleMode;
  
  SettingsService() {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final box = await _getBox();
    _simpleMode = box.get(_simpleModeKey, defaultValue: false);
    notifyListeners();
  }
  
  Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }
  
  Future<bool> getSimpleMode() async {
    final box = await _getBox();
    return box.get(_simpleModeKey, defaultValue: false);
  }
  
  Future<void> setSimpleMode(bool value) async {
    final box = await _getBox();
    await box.put(_simpleModeKey, value);
    _simpleMode = value;
    notifyListeners(); // notify all listeners about the change
  }
}