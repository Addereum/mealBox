import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // WICHTIG: Füge dies hinzu
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/mealbox_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lokalisierung für Deutsch initialisieren
  await initializeDateFormatting('de_DE', null);
  
  await Hive.initFlutter();
  await Hive.openBox('mealBox');
  
  runApp(const MealBoxApp());
}