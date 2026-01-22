import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // WICHTIG: Provider hinzufügen
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/mealbox_app.dart';
import 'services/meal_service.dart'; // MealService importieren

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lokalisierung für Deutsch initialisieren
  await initializeDateFormatting('de_DE', null);
  
  await Hive.initFlutter();
  
  // MealService initialisieren
  final mealService = MealService();
  await mealService.init();
  
  runApp(
    ChangeNotifierProvider<MealService>.value(
      value: mealService,
      child: const MealBoxApp(),
    ),
  );
}