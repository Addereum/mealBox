import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class MealNamesScreen extends StatefulWidget {
  const MealNamesScreen({Key? key}) : super(key: key);

  @override
  _MealNamesScreenState createState() => _MealNamesScreenState();
}

class _MealNamesScreenState extends State<MealNamesScreen> {
  final SettingsService _settingsService = SettingsService.instance;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = _settingsService.mealNames.map((name) => TextEditingController(text: name)).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveNames() async {
    final newNames = _controllers.map((c) => c.text.trim()).toList();
    // Fallback if one is empty
    for (int i = 0; i < newNames.length; i++) {
      if (newNames[i].isEmpty) {
        newNames[i] = "Mahlzeit ${i + 1}";
      }
    }
    await _settingsService.setMealNames(newNames);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Namen gespeichert ✅'),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mahlzeiten umbenennen'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveNames,
          )
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _controllers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextField(
              controller: _controllers[index],
              decoration: InputDecoration(
                labelText: 'Name für Mahlzeit ${index + 1}',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.edit, color: Colors.teal),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveNames,
        backgroundColor: Colors.teal,
        icon: Icon(Icons.save),
        label: Text('Speichern'),
      ),
    );
  }
}
