// screens/home_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/meal_service.dart';
import '../services/settings_service.dart';
import '../models/meal.dart';
import '../widgets/meal_dialog.dart';
import '../widgets/meal_list_tile.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../widgets/weekly_stats_widget.dart';
import '../widgets/bouncing_button.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'safe_foods_screen.dart';
import '../services/notification_service.dart';
import 'package:mealbox/l10n/generated/app_localizations.dart';
import 'package:confetti/confetti.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SettingsService _settingsService = SettingsService.instance;
  bool _isLoading = true;
  bool _simpleMode = false;
  bool _showStats = true;
  final ScrollController _scrollController = ScrollController();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _loadSettings();
    _settingsService.addListener(_onSettingsChanged);
  }
  
  @override
  void dispose() {
    _settingsService.removeListener(_onSettingsChanged);
    _scrollController.dispose();
    _confettiController.dispose();
    super.dispose();
  }
  
  void _onSettingsChanged() {
    if (_settingsService.simpleMode != _simpleMode) {
      setState(() {
        _simpleMode = _settingsService.simpleMode;
      });
    }
    if (_settingsService.showStats != _showStats) {
      setState(() {
        _showStats = _settingsService.showStats;
      });
    }
  }

  Future<void> _loadSettings() async {
    setState(() {
      _simpleMode = _settingsService.simpleMode;
      _showStats = _settingsService.showStats;
      _isLoading = false;
    });
    
    // Beim App-Start die Benachrichtigungsberechtigung (Android 13+) abfragen
    if (_settingsService.notifications) {
      await NotificationService().requestPermissions();
      await NotificationService().scheduleMealReminders(AppLocalizations.of(context)!);
    }
  }

  Future<void> _logSimpleMeal() async {
    final mealService = Provider.of<MealService>(context, listen: false);
    await mealService.addMeal('Meal');
    
    await _afterMealLogged(DateTime.now());
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.mealAdded('Meal')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _afterMealLogged(DateTime logTime) async {
    final mealService = Provider.of<MealService>(context, listen: false);
    
    // Confetti Check (3 Mahlzeiten am Tag)
    final todayMeals = await mealService.getMealsForDate(DateTime.now());
    if (todayMeals.length == 3) {
      _confettiController.play();
    }
    
    // Smart Reminders Check
    if (_settingsService.notifications) {
      final hour = logTime.hour;
      if (hour >= 5 && hour < 11) {
        await NotificationService().cancelReminder(0); // Frühstück
      } else if (hour >= 11 && hour < 16) {
        await NotificationService().cancelReminder(1); // Mittagessen
      } else if (hour >= 16 && hour < 23) {
        await NotificationService().cancelReminder(2); // Abendessen
      }
    }
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  Future<void> _logMeal(String mealType, DateTime? customTime, String? energyLevel, bool? tookMeds, String? imagePath) async {
    final mealService = Provider.of<MealService>(context, listen: false);
    await mealService.addMeal(mealType, customTime: customTime, energyLevel: energyLevel, tookMeds: tookMeds, imagePath: imagePath);
    
    await _afterMealLogged(customTime ?? DateTime.now());
    
    String message = AppLocalizations.of(context)!.mealAdded(mealType);
    if (energyLevel != null) {
      message += ' ($energyLevel)';
    }
    if (customTime != null) {
      message += ' (logged at ${DateFormat('HH:mm').format(customTime)})';
    }
    if (tookMeds == true) {
      message += ' 💊';
    }
    if (imagePath != null) {
      message += ' 📸';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
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

  void _logSimpleMealInternal() {
    _logMeal(AppLocalizations.of(context)!.meal, null, null, null, null);
  }

  void _triggerSOS() {
    final safeFoods = _settingsService.safeFoods;
    String suggestion;
    if (safeFoods.isNotEmpty) {
      final random = Random();
      suggestion = safeFoods[random.nextInt(safeFoods.length)];
    } else {
      suggestion = AppLocalizations.of(context)!.sosMessageFallback;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.sosTitle, style: TextStyle(color: Colors.red)),
        content: Text(AppLocalizations.of(context)!.sosMessagePrefix + suggestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Colors.grey)),
          ),
          if (safeFoods.isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _logMeal(suggestion, null, AppLocalizations.of(context)!.energyLow, null, null);
              },
              child: Text(AppLocalizations.of(context)!.logNow, style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
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
                title: Text(AppLocalizations.of(context)!.appTitle),
                actions: [
                  IconButton(
                    icon: Text('🛟', style: TextStyle(fontSize: 20)),
                    tooltip: AppLocalizations.of(context)!.safeFoods,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SafeFoodsScreen()),
                      );
                    },
                  ),
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
                              Text(AppLocalizations.of(context)!.history),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'settings',
                          child: Row(
                            children: [
                              Icon(Icons.settings, color: Colors.teal),
                              SizedBox(width: 10),
                              Text(AppLocalizations.of(context)!.settings),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
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
                          color: Theme.of(context).colorScheme.primary,
                          elevation: 0,
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
                                            DateFormat('EEEE, dd.MM.yyyy', Localizations.localeOf(context).languageCode).format(DateTime.now()),
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            AppLocalizations.of(context)!.todayEaten(todayMeals.length),
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
                                              AppLocalizations.of(context)!.simpleMode,
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
                        
                        SizedBox(height: 16),
                        
                        // Water Tracker
                        FutureBuilder<int>(
                          future: mealService.getWaterForDate(DateTime.now()),
                          builder: (context, snapshot) {
                            final amount = snapshot.data ?? 0;
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.blue.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.water_drop, color: Colors.blue[400]),
                                  SizedBox(width: 8),
                                  Text(
                                    AppLocalizations.of(context)!.water(amount),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.remove, color: amount > 0 ? Colors.blue[800] : Colors.grey),
                                    onPressed: amount > 0 ? () => mealService.removeWater(DateTime.now()) : null,
                                    constraints: BoxConstraints(),
                                    padding: EdgeInsets.all(4),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add, color: Colors.blue[800]),
                                    onPressed: () => mealService.addWater(DateTime.now()),
                                    constraints: BoxConstraints(),
                                    padding: EdgeInsets.all(4),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        if (_showStats) ...[
                          SizedBox(height: 16),
                          WeeklyStatsWidget(),
                        ],
                        
                        SizedBox(height: 24),
                        
                        // Add Button
                        Center(
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.addMealTitle,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 16),
                              BouncingButton(
                                onTap: _showMealDialog,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add, size: 24, color: Theme.of(context).colorScheme.onPrimary),
                                      SizedBox(width: 8),
                                      Text(
                                        AppLocalizations.of(context)!.addMeal,
                                        style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              BouncingButton(
                                onTap: _triggerSOS,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.sos, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text(
                                        AppLocalizations.of(context)!.noEnergy,
                                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 32),
                        
                        // Today's Meals
                        Text(
                          AppLocalizations.of(context)!.todayMealsTitle,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
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
                                          AppLocalizations.of(context)!.noMealsToday,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          AppLocalizations.of(context)!.pressAddToStart,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
                onPressed: _showMealDialog,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(_simpleMode ? Icons.check : Icons.add, color: Theme.of(context).colorScheme.onPrimary),
              ),
            );
          },
        );
      },
    );
  }
}