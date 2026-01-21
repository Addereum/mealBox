import 'package:hive/hive.dart';

class SettingsService {
  static const String _boxName = 'settingsBox';
  static const String _simpleModeKey = 'simpleMode';
  
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
  }
}