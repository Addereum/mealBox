import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/meal.dart';
import '../services/meal_service.dart';
import '../widgets/meal_list_tile.dart';
import '../widgets/delete_confirmation_dialog.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final MealService _mealService = MealService();
  Map<String, List<Meal>> _allMeals = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    setState(() => _isLoading = true);
    _allMeals = await _mealService.getAllMeals();
    setState(() => _isLoading = false);
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
      await _loadMeals();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mahlzeit gelöscht')),
      );
    }
  }

  String _formatDateKey(String dateKey) {
    try {
      final parts = dateKey.split('-');
      final date = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      return DateFormat('EEEE, dd.MM.yyyy', 'de_DE').format(date);
    } catch (e) {
      return dateKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mahlzeiten-Historie 📅'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _allMeals.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 60, color: Colors.grey[400]),
                      SizedBox(height: 20),
                      Text(
                        'Keine Mahlzeiten vorhanden',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      Text(
                        'Beginne mit dem Loggen auf der Startseite!',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadMeals,
                  child: ListView.builder(
                    itemCount: _allMeals.length,
                    itemBuilder: (context, index) {
                      final dateKey = _allMeals.keys.elementAt(index);
                      final meals = _allMeals[dateKey]!;
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: Text(
                              _formatDateKey(dateKey),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                          ...meals.map((meal) => MealListTile(
                                meal: meal,
                                onDelete: _deleteMeal,
                                showDate: false,
                              )),
                          if (index < _allMeals.length - 1)
                            Divider(indent: 20, endIndent: 20),
                        ],
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadMeals,
        backgroundColor: Colors.teal,
        child: Icon(Icons.refresh),
      ),
    );
  }
}