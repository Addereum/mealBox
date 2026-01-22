// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  final SettingsService _settingsService = SettingsService.instance;
  bool _isLoading = true;
  bool _simpleMode = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _settingsService.addListener(_onSettingsChanged);
  }
  
  @override
  void dispose() {
    _settingsService.removeListener(_onSettingsChanged);
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onSettingsChanged() {
    if (_settingsService.simpleMode != _simpleMode) {
      setState(() {
        _simpleMode = _settingsService.simpleMode;
      });
    }
  }

  Future<void> _loadSettings() async {
    setState(() {
      _simpleMode = _settingsService.simpleMode;
    });
  }

  Future<void> _logSimpleMeal() async {
    final mealService = Provider.of<MealService>(context, listen: false);
    await mealService.addMeal('Meal');
    
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

  Future<void> _logMeal(String mealType, DateTime? customTime) async {
    final mealService = Provider.of<MealService>(context, listen: false);
    await mealService.addMeal(mealType, customTime: customTime);
    
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
      final mealService = Provider.of<MealService>(context, listen: false);
      await mealService.deleteMeal(meal.dateKey, meal.id);
    }
  }

  void _showMealDialog() {
    if (_simpleMode) {
      _logSimpleMeal();
    } else {
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
    
    return Consumer<MealService>(
      builder: (context, mealService, child) {
        // WICHTIG: FutureBuilder für dynamische Updates
        return FutureBuilder<List<Meal>>(
          future: mealService.getMealsForDate(DateTime.now()),
          builder: (context, snapshot) {
            List<Meal> todayMeals = [];
            bool isLoading = snapshot.connectionState == ConnectionState.waiting;
            
            if (snapshot.hasData) {
              todayMeals = snapshot.data!;
            }
            
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
                controller: _scrollController,
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
                                            'Heute gegessen: ${todayMeals.length} Mahlzeit${todayMeals.length != 1 ? 'en' : ''}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white.withOpacity(0.9),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                        
                        isLoading
                            ? Center(child: CircularProgressIndicator(color: Colors.teal))
                            : todayMeals.isEmpty
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
                                    children: todayMeals.map((meal) {
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
          },
        );
      },
    );
  }
}