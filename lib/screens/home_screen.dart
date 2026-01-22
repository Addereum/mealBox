// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/meal_service.dart';
import '../services/settings_service.dart';
import '../models/meal.dart';
import '../widgets/meal_dialog.dart';
import '../widgets/meal_list_tile.dart';
import '../widgets/delete_confirmation_dialog.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MealService _mealService = MealService();
  final SettingsService _settingsService = SettingsService();
  List<Meal> _todayMeals = [];
  bool _isLoading = true;
  bool _simpleMode = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadTodayMeals();
    
    // CRITICAL: Add listener for settings changes
    _settingsService.addListener(_onSettingsChanged);
  }
  
  @override
  void dispose() {
    // CRITICAL: Remove listener to prevent memory leaks
    _settingsService.removeListener(_onSettingsChanged);
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onSettingsChanged() {
    // Called when settings change
    if (_settingsService.simpleMode != _simpleMode) {
      setState(() {
        _simpleMode = _settingsService.simpleMode;
      });
      print('Simple Mode updated in HomeScreen: $_simpleMode');
    }
  }

  Future<void> _loadSettings() async {
    // Get current value directly from service
    setState(() {
      _simpleMode = _settingsService.simpleMode;
    });
  }

  Future<void> _logSimpleMeal() async {
    await _mealService.addMeal('Meal');
    await _loadTodayMeals();
    
    await Future.delayed(Duration(milliseconds: 100));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Meal added ✅'),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  Future<void> _loadTodayMeals() async {
    setState(() => _isLoading = true);
    _todayMeals = await _mealService.getMealsForDate(DateTime.now());
    setState(() => _isLoading = false);
  }

  Future<void> _logMeal(String mealType, DateTime? customTime) async {
    await _mealService.addMeal(mealType, customTime: customTime);
    await _loadTodayMeals();
    
    await Future.delayed(Duration(milliseconds: 100));
    
    String message = '$mealType added ✅';
    if (customTime != null) {
      message += ' (logged at ${DateFormat('HH:mm').format(customTime)})';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _deleteMeal(Meal meal) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        mealType: meal.type,
        time: meal.timeString,
      ),
    );

    if (shouldDelete ?? false) {
      await _mealService.deleteMeal(meal.dateKey, meal.id);
      await _loadTodayMeals();
    }
  }

  void _showMealDialog() {
    if (_simpleMode) {
      // SIMPLE MODE: Log without dialog/meal type
      _logSimpleMeal();
    } else {
      // NORMAL MODE: Log with dialog/meal type
      showDialog(
        context: context,
        builder: (context) => MealDialog(onMealSelected: _logMeal),
      );
    }
  }

  void _navigateToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('MealBox 🍱'),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'history') {
                _navigateToHistory();
              } else if (value == 'settings') {
                _navigateToSettings();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'history',
                  child: Row(
                    children: [
                      Icon(Icons.history, color: Colors.teal),
                      SizedBox(width: 10),
                      Text('Historie'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings, color: Colors.teal),
                      SizedBox(width: 10),
                      Text('Einstellungen'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Padding(
            padding: EdgeInsets.all(isWeb ? 24.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Card(
                  color: Colors.teal,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('EEEE, dd.MM.yyyy').format(DateTime.now()),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Heute gegessen: ${_todayMeals.length} Mahlzeit${_todayMeals.length != 1 ? 'en' : ''}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Simple Mode Indicator (only when active)
                            if (_simpleMode)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.flash_on, size: 14, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text(
                                      'Simple',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Add Button
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Mahlzeit hinzufügen',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _showMealDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Hinzufügen',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 32),
                
                // Today's Meals
                Text(
                  'Heutige Mahlzeiten',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                
                SizedBox(height: 16),
                
                _isLoading
                    ? Center(child: CircularProgressIndicator(color: Colors.teal))
                    : _todayMeals.isEmpty
                        ? Container(
                            padding: EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.restaurant_menu,
                                  size: 64,
                                  color: Colors.grey[300],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Noch keine Mahlzeiten heute',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Drücke auf Hinzufügen, um zu beginnen!',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: _todayMeals.map((meal) {
                              return MealListTile(
                                meal: meal,
                                onDelete: _deleteMeal,
                              );
                            }).toList(),
                          ),
                
                SizedBox(height: isWeb ? 100 : 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMealDialog,
        backgroundColor: Colors.teal,
        child: Icon(_simpleMode ? Icons.check : Icons.add),
      ),
    );
  }
}