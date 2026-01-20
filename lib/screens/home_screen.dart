import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/meal_service.dart';
import '../models/meal.dart';
import '../widgets/meal_dialog.dart';
import '../widgets/meal_list_tile.dart';
import '../widgets/delete_confirmation_dialog.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MealService _mealService = MealService();
  List<Meal> _todayMeals = [];
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadTodayMeals();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTodayMeals() async {
    setState(() => _isLoading = true);
    _todayMeals = await _mealService.getMealsForDate(DateTime.now());
    setState(() => _isLoading = false);
  }

  Future<void> _logMeal(String mealType) async {
    await _mealService.addMeal(mealType);
    await _loadTodayMeals();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$mealType hinzugefügt'),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
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
    showDialog(
      context: context,
      builder: (context) => MealDialog(onMealSelected: _logMeal),
    );
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
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _navigateToHistory,
            tooltip: 'Historie',
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
                                  'Drücke auf "Hinzufügen" um zu beginnen',
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
        child: Icon(Icons.add),
      ),
    );
  }
}