import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../services/meal_service.dart';
import 'package:provider/provider.dart';
import 'package:mealbox/l10n/generated/app_localizations.dart';

class SafeFoodsScreen extends StatefulWidget {
  const SafeFoodsScreen({Key? key}) : super(key: key);

  @override
  _SafeFoodsScreenState createState() => _SafeFoodsScreenState();
}

class _SafeFoodsScreenState extends State<SafeFoodsScreen> {
  final TextEditingController _controller = TextEditingController();
  final SettingsService _settingsService = SettingsService.instance;
  bool _isAdding = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addFood() {
    final food = _controller.text.trim();
    if (food.isNotEmpty) {
      _settingsService.addSafeFood(food);
      _controller.clear();
      setState(() {
        _isAdding = false;
      });
    }
  }

  Future<void> _logSafeFood(String food) async {
    final mealService = Provider.of<MealService>(context, listen: false);
    await mealService.addMeal(food); // Save directly as name
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.mealAdded(food)),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.safeFoodsTitle),
        backgroundColor: Colors.blue,
      ),
      body: AnimatedBuilder(
        animation: _settingsService,
        builder: (context, _) {
          final foods = _settingsService.safeFoods;
          
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.blue.withOpacity(0.1),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[800]),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.safeFoodsDesc,
                        style: TextStyle(color: Colors.blue[900], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: foods.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fastfood_outlined, size: 64, color: Colors.grey[300]),
                            SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.noSafeFoods,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: foods.length,
                        itemBuilder: (context, index) {
                          final food = foods[index];
                          return Card(
                            elevation: 1,
                            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            child: ListTile(
                              leading: Text('🛟', style: TextStyle(fontSize: 20)),
                              title: Text(food, style: TextStyle(fontWeight: FontWeight.w500)),
                              trailing: IconButton(
                                icon: Icon(Icons.delete_outline, color: Colors.red[300]),
                                onPressed: () => _settingsService.removeSafeFood(food),
                              ),
                              onTap: () => _logSafeFood(food),
                            ),
                          );
                        },
                      ),
              ),
              if (_isAdding)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Z.B. Toast mit Butter',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                          onSubmitted: (_) => _addFood(),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.check_circle, color: Colors.teal, size: 36),
                        onPressed: _addFood,
                      ),
                    ],
                  ),
                ),
            ],
          );
        }
      ),
      floatingActionButton: !_isAdding 
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isAdding = true;
                });
              },
              backgroundColor: Colors.blue,
              child: Icon(Icons.add),
            ) 
          : null,
    );
  }
}
